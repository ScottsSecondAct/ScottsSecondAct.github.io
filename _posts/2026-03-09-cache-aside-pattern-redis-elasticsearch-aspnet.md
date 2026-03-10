---
layout: post
title: "Implementing the Cache-Aside Pattern with Redis and Elasticsearch in ASP.NET Core"
date: 2026-03-09
categories: [dotnet, redis, elasticsearch, architecture]
tags: [csharp, aspnetcore, redis, elasticsearch, caching, cache-aside, distributed-cache]
---

Every high-traffic API eventually hits the same wall: the database can't keep up. The usual first instinct is to throw more hardware at it — but a well-placed cache is often far more effective and far cheaper. This post walks through a clean implementation of the **cache-aside pattern** using Redis and Elasticsearch in an ASP.NET Core 8 Web API.

The full source is on GitHub: [RedisExample](https://github.com/ScottsSecondAct/RedisExample).

---

## What Is the Cache-Aside Pattern?

Cache-aside (also called *lazy loading*) is the most common caching strategy for read-heavy workloads. The application code — not the cache infrastructure — is responsible for keeping the cache populated. The flow looks like this:

1. Check the cache first
2. If it's a **HIT**, return the cached value immediately
3. If it's a **MISS**, fetch from the primary data store, write the result into the cache, then return it

The "aside" in the name means the cache sits *beside* your data store, not in front of it. Your application bridges the two.

```
HTTP GET /api/business/{id}
    ↓
BusinessRepository
    ├─→ Redis (IDistributedCache)
    │   ├─→ HIT:  return immediately (fast path)
    │   └─→ MISS: ↓
    └─→ Elasticsearch (IElasticClient)
        └─→ Write to Redis, then return
```

Cache-aside has a few useful properties worth calling out:

- **The cache only holds what's been asked for.** You aren't pre-loading the entire dataset — entries are populated on demand.
- **Cache failures are non-fatal.** If Redis goes down, reads fall through to Elasticsearch. Slower, but still correct.
- **Invalidation is explicit.** When a record changes, you remove it from the cache. The next read repopulates it.

---

## Project Overview

This is an ASP.NET Core 8 Web API that stores business listings (name, rating, tags, address, hours) in Elasticsearch and caches individual lookups in Redis.

**Tech stack:**
- **ASP.NET Core 8** — Web API host
- **Elasticsearch 7.x** via `NEST` — primary document store
- **Redis** via `StackExchange.Redis` + `Microsoft.Extensions.Caching.StackExchangeRedis` — distributed cache via `IDistributedCache`
- **AutoMapper** — maps between domain models and DTOs
- **Swagger/OpenAPI** — API documentation

For local development, both Redis and Elasticsearch run in Docker:

```yaml
services:
  redis:
    image: redis:7
    ports:
      - "6379:6379"

  elasticsearch:
    image: elasticsearch:7.17.9
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
```

---

## Wiring It Up in Startup

Both services are registered in `ConfigureServices`. Redis gets its connection string from config:

```csharp
services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = Configuration.GetConnectionString("redis");
    options.InstanceName = "RedisExample";
});

services.AddElasticsearch(Configuration);
services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
services.AddScoped<IBusinessRepository, BusinessRepository>();
```

`AddElasticsearch` is a custom extension that configures `NEST`, applies default index mappings, and auto-creates the `businesses` index on startup:

```csharp
public static void AddElasticsearch(this IServiceCollection services, IConfiguration configuration)
{
    var url = configuration["elasticsearch:url"];
    var defaultIndex = configuration["elasticsearch:index"];

    var settings = new ConnectionSettings(new Uri(url))
        .DefaultIndex(defaultIndex);

    // Exclude these fields from the inverted index
    settings.DefaultMappingFor<Business>(m => m
        .Ignore(b => b.Name)
        .Ignore(b => b.Address)
        .Ignore(b => b.IsClaimed)
    );

    var client = new ElasticClient(settings);
    services.AddSingleton<IElasticClient>(client);

    client.Indices.Create(indexName, index => index.Map<Business>(x => x.AutoMap()));
}
```

The `Ignore` calls are worth noting: they tell NEST not to add these fields to the inverted index. The data is still stored in `_source` (and will be returned in results), but it won't be indexed for full-text search. Useful for keeping your mapping lean when certain fields are lookup-only.

---

## The Cache Extension Methods

A small pair of generic extension methods wraps `IDistributedCache` with JSON serialization/deserialization, so the rest of the codebase never has to think about byte arrays:

```csharp
public static async Task SetRecordAsync<T>(
    this IDistributedCache cache,
    string recordId,
    T data,
    TimeSpan? absoluteExpireTime = null,
    TimeSpan? slidingExpirationTime = null,
    CancellationToken cancellationToken = default)
{
    var options = new DistributedCacheEntryOptions
    {
        AbsoluteExpirationRelativeToNow = absoluteExpireTime ?? TimeSpan.FromSeconds(20),
        SlidingExpiration = slidingExpirationTime
    };

    var json = JsonSerializer.Serialize(data);
    await cache.SetStringAsync(recordId, json, options, cancellationToken);
}

public static async Task<T> GetRecordAsync<T>(
    this IDistributedCache cache,
    string recordId)
{
    var json = await cache.GetStringAsync(recordId);
    return json is null ? default : JsonSerializer.Deserialize<T>(json);
}
```

The default TTL is **20 seconds** — intentionally short for a demo project so you can observe both HITs and MISSes without waiting around. In production you'd set this based on how stale your data can tolerate being (minutes to hours for slowly-changing records).

---

## The Repository: Where Cache-Aside Actually Lives

The pattern is implemented entirely in `BusinessRepository`. The controller and the data store have no idea the cache exists.

```csharp
public (Business business, bool fromCache) GetBusiness(string id)
{
    var cached = _distributedCache.GetRecordAsync<Business>(id).Result;

    if (cached is not null)
    {
        _logger.LogInformation("Cache HIT for business {Id}", id);
        return (cached, true);
    }

    _logger.LogInformation("Cache MISS for business {Id} — fetching from Elasticsearch", id);

    var response = _elasticClient.Get<Business>(id);

    if (!response.Found)
        return (null, false);

    _distributedCache.SetRecordAsync(id, response.Source).Wait();

    return (response.Source, false);
}
```

The method returns a tuple `(Business, bool)` — the business record and a flag indicating whether it came from cache. The controller uses this to set a response header (more on that below).

**Cache invalidation on write** is explicit. When a record is updated, the cache entry is evicted:

```csharp
public void UpdateBusiness(string id, Business business)
{
    _elasticClient.IndexDocument(business);
    _distributedCache.RemoveAsync(id).Wait();
    _logger.LogInformation("Updated business {Id} and evicted from cache", id);
}
```

The next GET for that ID will be a MISS, hit Elasticsearch, and repopulate the cache with the fresh data.

---

## Making the Cache Visible: The X-Cache Header

One of my favorite small touches in this project is surfacing cache behavior directly in the HTTP response:

```csharp
[HttpGet("{id}", Name = nameof(GetBusinessById))]
public ActionResult<BusinessReadDto> GetBusinessById(string id)
{
    var (record, fromCache) = _businessRepository.GetBusiness(id);

    if (record is null)
        return NotFound($"Business {id} not found.");

    Response.Headers["X-Cache"] = fromCache ? "HIT" : "MISS";

    return Ok(_mapper.Map<BusinessReadDto>(record));
}
```

`X-Cache` is a de facto standard header used by CDNs and reverse proxies (Varnish, Cloudflare, etc.) to indicate cache status. Adding it here means you can verify the cache is working directly from Swagger, curl, or browser DevTools — no need to tail logs.

```
GET /api/business/1001

HTTP/1.1 200 OK
X-Cache: HIT
Content-Type: application/json
```

---

## What Gets Cached and What Doesn't

The `GetAllBusinesses()` endpoint skips the cache entirely and queries Elasticsearch directly:

```csharp
public IEnumerable<Business> GetAllBusinesses()
{
    var response = _elasticClient.Search<Business>(s => s
        .Query(q => q.MatchAll())
        .Sort(sort => sort.Ascending(f => f.Id))
    );

    return response.Documents;
}
```

This is a deliberate trade-off. Caching a list result creates thorny invalidation problems: any create, update, or delete potentially changes the list. You'd either end up with stale lists or constantly evicting the cache entry (defeating the purpose). Caching individual document lookups by ID has a clear value proposition and a clean invalidation story.

---

## Observations and Trade-offs

A few things worth discussing if you're evaluating this pattern for production use:

**Cache stampede.** If a popular cache entry expires, many concurrent requests can all get MISSes simultaneously and hammer the database. Solutions include probabilistic early expiration, locking, or background refresh. This project doesn't implement those, but they're worth knowing about.

**Synchronous waits on async operations.** The repository uses `.Result` and `.Wait()` on async cache calls because the repository interface is synchronous. This blocks thread-pool threads and is not recommended for production. The right fix is to make `IBusinessRepository` return `Task<T>` and `async/await` all the way up.

**List caching strategies.** If you need to cache list results, look at cache-busting keys (e.g., a version counter in Redis that you increment on writes) or short TTLs where eventual consistency is acceptable.

**No sliding expiration here.** The current implementation uses only absolute expiration. Sliding expiration keeps frequently accessed entries alive longer — useful if your hot set is stable and small.

---

## Running It Locally

```bash
# Start Redis and Elasticsearch
docker compose up -d

# Build and run the API
dotnet run

# Seed some test data
curl -X POST http://localhost:5000/api/business/seed

# Fetch a business — watch the X-Cache header change on repeated calls
curl -i http://localhost:5000/api/business/1001
```

Hit that last URL twice in quick succession and you'll see `X-Cache: MISS` on the first request and `X-Cache: HIT` on subsequent ones (until the 20-second TTL expires).

---

## Wrapping Up

The cache-aside pattern is one of the most practical tools in distributed systems design. The implementation here is deliberately simple — the goal is to make the pattern legible, not to ship a production-hardened caching layer. But the bones are all there:

- Cache-first reads with transparent fallback
- Explicit cache invalidation on writes
- Configurable TTL
- Observable behavior via response headers
- Clean separation between caching logic and the controller

If you're building APIs that read more than they write, cache-aside is worth reaching for early.

Source: [github.com/scottdavispdx/RedisExample](https://github.com/ScottsSecondAct/RedisExample)
