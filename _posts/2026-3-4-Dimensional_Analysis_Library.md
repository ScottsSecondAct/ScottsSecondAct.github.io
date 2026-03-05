---
title: Compile-Time Dimensional Analysis in Modern C++
categories:
  - Blog
tags:
  - C++
  - Compiler
  - Dimensional Analysis
---

*Catching dimension bugs before your code compiles.*

---

NASA's Mars Climate Orbiter was destroyed when it entered Mars' atmosphere at too low an altitude on September 23, 1999. The root cause was a mismatch between measurement systems: Lockheed Martin's ground-based navigation software produced thruster force data in **pound-force seconds** (an Imperial/English unit), while NASA's Jet Propulsion Laboratory (JPL) systems expected that data in **newton-seconds** (the metric/SI unit). Since one pound-force is roughly 4.45 newtons, the cumulative navigation errors over the months-long journey sent the spacecraft on a trajectory that brought it about 57 km above the Martian surface instead of the planned 150+ km. At that altitude, it either burned up or broke apart in the atmosphere.

The mission cost around $328 million and became one of the most cited examples in engineering and science education of why unit consistency and interface specification matter. It led NASA to strengthen its verification procedures for unit handling across contractor boundaries.

Adding meters to seconds is a bug. Every physicist knows it. Yet C++ has traditionally been happy to let you do it:

```cpp
double dist = 10.0;   // meters?
double time = 2.0;    // seconds?
double speed = dist + time; // nonsense — but compiles fine
```

The compiler sees only `double`. The bug ships.

Dimensional analysis libraries fix this by encoding physical units into the type system. This post walks through the design of one such library — a header-only, zero-overhead implementation using C++20 templates, concepts, and user-defined literals.

---

## The Core Idea: Dimensions as Integer Packs

Every SI quantity can be described by seven integer exponents — one for each base unit:

| Symbol | Base Unit  |
|--------|------------|
| M      | kilogram   |
| L      | metre      |
| T      | second     |
| I      | ampere     |
| K      | kelvin     |
| N      | mole       |
| J      | candela    |

A velocity (m/s) has exponents `[0, 1, -1, 0, 0, 0, 0]`. A force (kg·m/s²) has `[1, 1, -2, 0, 0, 0, 0]`. The library encodes this directly in template parameters:

```cpp
template <int M, int L, int T, int I=0, int K=0, int N=0, int J=0>
struct Dimensions {
    static constexpr int mass       = M;
    static constexpr int length     = L;
    static constexpr int time       = T;
    static constexpr int current    = I;
    static constexpr int temp       = K;
    static constexpr int amount     = N;
    static constexpr int luminosity = J;
};
```

All seven values live entirely in the type — no runtime storage whatsoever.

---

## Arithmetic on Dimensions

When you multiply two quantities, their exponents add. When you divide, they subtract. Two compile-time metafunctions handle this:

```cpp
template <typename D1, typename D2>
struct DimAdd {
    using type = Dimensions<
        D1::mass    + D2::mass,
        D1::length  + D2::length,
        D1::time    + D2::time,
        D1::current + D2::current,
        D1::temp    + D2::temp,
        D1::amount  + D2::amount,
        D1::luminosity + D2::luminosity>;
};

template <typename D1, typename D2>
struct DimSub {
    using type = Dimensions<
        D1::mass    - D2::mass,
        // ...
    >;
};
```

These run entirely at compile time. The resulting type is computed by the compiler, not at runtime.

---

## The `Quantity` Wrapper

`Quantity<Dim>` wraps a single `double` with dimension type information:

```cpp
template <typename Dim>
struct Quantity {
    double value;
    explicit constexpr Quantity(double v) : value(v) {}

    template <IsQuantity RHS>
    constexpr auto operator*(RHS rhs) const {
        return Quantity<typename DimAdd<Dim, typename RHS::DimensionType>::type>(
            value * rhs.value
        );
    }

    template <IsQuantity RHS>
    constexpr auto operator/(RHS rhs) const {
        return Quantity<typename DimSub<Dim, typename RHS::DimensionType>::type>(
            value / rhs.value
        );
    }

    constexpr Quantity operator+(Quantity rhs) const { return Quantity(value + rhs.value); }
    constexpr Quantity operator-(Quantity rhs) const { return Quantity(value - rhs.value); }
    constexpr auto operator<=>(const Quantity&) const = default;
};
```

Three things stand out here:

**Size**: `sizeof(Quantity<anything>) == sizeof(double) == 8`. The dimension type lives only in the compiler's type system — it takes up no space at runtime.

**Operator constraints**: `operator+` and `operator-` take `Quantity` (same type only), so adding a length to a time simply won't compile. `operator*` and `operator/` use the `IsQuantity` concept and return a new `Quantity` with the computed dimension type.

**Spaceship operator**: Defaulting `operator<=>` gives you `==`, `!=`, `<`, `>`, `<=`, `>=` for free — all constrained to same-dimension comparisons.

### The `IsQuantity` Concept

```cpp
template <typename T>
concept IsQuantity = requires {
    typename T::DimensionType;
} && std::is_same_v<T, Quantity<typename T::DimensionType>>;
```

This gates the cross-quantity operators so they only participate in overload resolution when both operands are `Quantity` specializations. Plain `double` doesn't accidentally match.

---

## What a Type Error Looks Like

```cpp
auto dist  = 10.0_m;
auto time  = 2.0_s;
auto oops  = dist + time;  // error!
```

The compiler rejects this because `operator+` requires both arguments to be the same `Quantity` type — `Quantity<Dimensions<0,1,0>>` (Length) and `Quantity<Dimensions<0,0,1>>` (Time) are different types. The error fires at compile time, before a single byte of machine code is generated.

---

## Math Functions: `pow`, `sqrt`, `abs`

The library extends dimension arithmetic to common math operations.

`pow<N>` scales all exponents by N:

```cpp
template<int N, IsQuantity Q>
constexpr auto pow(Q q) {
    return Quantity<typename DimScale<typename Q::DimensionType, N>::type>(
        std::pow(q.value, N)
    );
}
```

`sqrt` halves all exponents — but only if they're all even, checked with `static_assert`:

```cpp
template<typename D>
struct DimHalve {
    static_assert(D::mass % 2 == 0,   "sqrt: mass exponent must be even");
    static_assert(D::length % 2 == 0, "sqrt: length exponent must be even");
    // ...
    using type = Dimensions<D::mass/2, D::length/2, D::time/2, ...>;
};
```

Taking `sqrt` of a velocity would produce a non-integer exponent — that's a physics error, caught at compile time with a readable message.

---

## User-Friendly API: Type Aliases and UDLs

Raw `Quantity<Dimensions<1,1,-2>>` isn't ergonomic. The `units.h` header wraps it in named aliases:

```cpp
using Mass        = Quantity<Dimensions<1,0,0>>;
using Length      = Quantity<Dimensions<0,1,0>>;
using Time        = Quantity<Dimensions<0,0,1>>;
using Velocity    = Quantity<Dimensions<0,1,-1>>;
using Acceleration= Quantity<Dimensions<0,1,-2>>;
using Force       = Quantity<Dimensions<1,1,-2>>;
using Energy      = Quantity<Dimensions<1,2,-2>>;
// ... and dozens more
```

User-defined literals (UDLs) make construction natural:

```cpp
auto distance = 10.0_km;     // Length (stored as metres internally)
auto duration = 30.0_min;    // Time (stored as seconds)
auto speed    = distance / duration;  // Velocity — type deduced automatically
```

The full UDL set is comprehensive — SI prefixes, imperial units, astronomical distances, particle physics scales:

```cpp
// Mass
auto proton_mass = 1.0_Da;    // dalton → kg
auto body_weight = 180.0_lb;  // pounds → kg

// Length
auto orbit = 1.0_au;          // astronomical unit → m
auto galaxy = 8.0_kpc;        // kiloparsec → m

// Temperature (with affine conversion)
auto body_temp = 37.0_degC;   // → 310.15 K (stored as kelvin)
auto room_temp = 72.0_degF;   // → 295.37 K

// Energy
auto photon = 2.5_eV;         // electron-volt → joules
auto meal   = 500.0_kcal;     // food calories → joules
```

Temperature UDLs handle the affine offset (°C → K, °F → K) at construction time, so all downstream arithmetic works correctly in absolute kelvin.

---

## Physical Constants

The `constants` namespace provides CODATA/SI-redefinition values with full dimensional types:

```cpp
namespace constants {
    inline constexpr Velocity     c   {299'792'458.0};    // speed of light
    inline constexpr Action       h   {6.62607015e-34};   // Planck constant
    inline constexpr Action       hbar{1.054571817e-34};  // reduced Planck
    inline constexpr Charge       e   {1.602176634e-19};  // elementary charge
    inline constexpr Entropy      k_B {1.380649e-23};     // Boltzmann constant
    inline constexpr MolarEntropy R   {8.314462618};      // gas constant
    inline constexpr Mass         m_e {9.1093837015e-31}; // electron mass
    // ...
}
```

These aren't just magic numbers — they're typed. Multiplying `constants::h` by a `Frequency` gives an `Energy`, correctly.

---

## Stream Output

Debugging is easier with readable output. The library implements `operator<<` that prints the value with its SI dimension string:

```cpp
auto force = 5.0_kg * 9.81_m / 1.0_s / 1.0_s;
std::cout << force;  // prints: 49.05 [kg·m·s^-2]
```

The dimension string is computed from the type's exponents at compile time and formatted as a UTF-8 string (using `·` as the middle dot separator).

---

## Real Code Reads Like Physics

With everything in place, real usage is straightforward:

```cpp
#include "units.h"

// Newton's second law
auto mass   = 5.0_kg;
auto accel  = 9.81_m / 1.0_s / 1.0_s;
auto weight = mass * accel;     // Force — correct type, no cast

// Ohm's law
auto voltage  = 12.0_V;
auto resistance = 100.0_ohm;
auto current  = voltage / resistance;  // Current (amperes)

// Thermodynamics
auto delta_T = 20.0_K;
auto heat_cap = 4182.0_J / 1.0_kg / 1.0_K;  // SpecificHeat — J/(kg·K)
auto water    = 0.5_kg;
auto heat     = water * heat_cap * delta_T;   // Energy — correct

// Relativistic energy
using namespace constants;
auto E = m_e * pow<2>(c);   // Energy (J) — E = mc²
```

Dimension mismatches anywhere in the chain are compile errors, not runtime surprises.

---

## Zero Overhead

The library makes a concrete guarantee: a `Quantity` is exactly 8 bytes — identical to a bare `double`. All operators are `constexpr inline`, the dimension arithmetic lives entirely in the type system, and the compiler's optimizer sees through it completely. In a release build, code using `Quantity` produces identical machine code to code using raw `double`.

---

## What's in the Box

The library ships as three independent header-only components:

- **`dimensions.h`** — the core engine: `Dimensions`, `DimAdd`, `DimSub`, `DimScale`, `DimHalve`, `IsQuantity`, `Quantity`, `pow`, `sqrt`, `abs`, `operator<<`
- **`units.h`** — the user-facing layer: all SI aliases, physical constants, and 80+ UDLs covering SI, imperial, astronomical, and particle-physics scales
- **`ecs.h`** — a bonus sparse-set Entity Component System, unrelated to dimensional analysis, included as a self-contained utility

The test suite covers 16 test suites and over 80 cases, including type-correctness checks done entirely with `static_assert` at compile time.

---

## Getting Started

Requirements: Clang 18.1.3+ (GCC works too), CMake 3.20+. GoogleTest is fetched automatically.

```bash
export CXX=clang++-18
cmake -G Ninja -B build -S .
cmake --build build -j$(nproc)
./build/engine_tests   # run the test suite
./build/engine_demo    # run the demo
```

To use the library in your own code, copy `include/dimensions.h` and `include/units.h` into your project and `#include "units.h"`. No install step, no build system integration — it's header-only.

---

## Summary

The library demonstrates how C++20's type system — integer non-type template parameters, template metafunctions, concepts, and user-defined literals — can enforce physics constraints at compile time with no runtime cost. The key ideas:

1. Encode SI exponents as a 7-integer template pack (`Dimensions<M,L,T,I,K,N,J>`)
2. Compute exponent arithmetic with metafunctions (`DimAdd`, `DimSub`, `DimScale`, `DimHalve`)
3. Wrap `double` in a typed `Quantity<Dim>` with operators that produce correctly-typed results
4. Use the `IsQuantity` concept to constrain cross-quantity operators
5. Layer named aliases and UDLs on top for ergonomics
6. Guarantee `sizeof(Quantity<D>) == 8` — zero overhead by construction

The result is code that reads like physics, fails like physics, and runs like bare metal.
