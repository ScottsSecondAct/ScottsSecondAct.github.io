# Scott's Second Act

Personal site for Scott Davis — educator, computer engineer, and computer scientist. Built with Jekyll and the Minimal Mistakes theme, with a custom Obsidian-compatible notes system for publishing interconnected knowledge notes.

Live at: [scottssecondact.github.io](https://scottssecondact.github.io)

## Features

- **Blog posts** — standard Jekyll posts with categories, tags, and pagination
- **Obsidian Notes** — a `_notes/` collection rendered in Obsidian's dark theme with full wiki-style features:
  - `[[Wikilinks]]` — auto-resolved internal links
  - `![[Transclusions]]` — inline note embedding (supports heading/block anchors, up to 5 levels deep)
  - `> [!callout]` — all 13 Obsidian callout types
  - `#tags` — rendered as linked tag badges
  - Automatic backlinks panel
  - D3.js force-directed graph view
- **KaTeX** — client-side LaTeX math rendering
- **Search** — built-in Lunr search

## Tech Stack

| Layer | Technology |
|---|---|
| Static site generator | Jekyll (Ruby) |
| Theme | Minimal Mistakes |
| Notes styling | Custom SCSS scoped to `.obsidian-note` |
| Math | KaTeX (client-side) |
| Graph | D3.js v7 |
| Markdown | kramdown + GFM + Rouge highlighting |
| Hosting | GitHub Pages via GitHub Actions |

## Project Structure

```
_config.yml                   # Site config, collections, defaults
_notes/                       # Obsidian-style notes (layout: obsidian-note)
_posts/                       # Blog posts
_pages/                       # Static pages (About, etc.)
_drafts/                      # Unpublished drafts
_layouts/
  obsidian-note.html          # Note layout — wraps content in .obsidian-note
_sass/minimal-mistakes/
  _obsidian-theme.scss        # Obsidian CSS scoped to .obsidian-note
_plugins/
  obsidian_compat.rb          # All Obsidian features: wikilinks, callouts, tags,
                              #   transclusions, backlinks
_includes/
  backlinks.html              # Auto-generated backlinks panel
  graph.html                  # D3.js knowledge graph
assets/
  css/main.scss               # Imports MM theme + obsidian-theme
  images/                     # Site images; notes images in images/notes/
```

## Local Development

**Prerequisites:** Ruby, Bundler

```bash
# Install dependencies
bundle install

# Start local dev server with live reload
bundle exec jekyll serve --livereload

# Production build
bundle exec jekyll build
```

Site is served at `http://localhost:4000`.

> **WSL2 note:** If file watching fails, add `--force_polling`. If the server won't bind, add `--host 0.0.0.0`.

## Adding Content

### Blog Post

Create `_posts/YYYY-MM-DD-title.md` with frontmatter:

```yaml
---
title: "Post Title"
date: YYYY-MM-DD
categories: [category]
tags: [tag1, tag2]
---
```

### Note

Create `_notes/note-title.md` with frontmatter:

```yaml
---
title: "Note Title"
---
```

Notes automatically get the `obsidian-note` layout and are published at `/notes/note-title/`.

#### Wikilinks

```markdown
[[Another Note]]
[[Another Note|display text]]
![[Embedded Note]]
![[Embedded Note#Heading]]
```

#### Callouts

```markdown
> [!note] Optional title
> Callout content here.
```

Supported types: `note`, `tip`, `important`, `warning`, `caution`, `abstract`, `info`, `todo`, `success`, `question`, `failure`, `danger`, `bug`, `example`, `quote`

## Deployment

Pushing to `master` triggers a GitHub Actions workflow that builds with `--safe false` (required for custom plugins) and deploys to GitHub Pages.

## License

MIT — see [LICENSE](LICENSE)

The Minimal Mistakes theme is copyright Michael Rose, also MIT licensed.
