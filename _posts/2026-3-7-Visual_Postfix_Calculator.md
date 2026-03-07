---
title: "Building a Visual RPN Scientific Calculator with JavaFX and AI Assistance"
date: 2026-03-07
author: Scott
tags: [java, javafx, data-structures, rpn, calculator, ai, csci-13]
header:
  image: /assets/images/VisualPostfixCalculator.jpg
  teaser: /assets/images/VisualPostfixCalculator.jpg
description: >
  How I built a full scientific RPN calculator in JavaFX that visualizes
  the stack in real time — as a teaching tool for CSCI-13 at Sierra College,
  with AI assistance from Anthropic's Claude.
---

![Visual RPN Scientific Calculator](VisualPostfixCalculator.jpg)

# Building a Visual RPN Scientific Calculator with JavaFX and AI Assistance

For my CSCI-13 course — *Programming Concepts and Methodology II* — at
[Sierra College](https://www.sierracollege.edu), I wanted a project that
would demonstrate a fundamental data structure concept in the most concrete
way possible: a **stack you can actually see working in real time**.

The result is the [Visual RPN Scientific Calculator](https://github.com/ScottsSecondAct/VisualPostfixCalculator),
a full-featured JavaFX desktop application that uses **Reverse Polish Notation (RPN)**
and keeps the stack permanently visible beside the keypad. Every push, pop,
and arithmetic result updates the live stack display instantly.

---

## What Is RPN and Why Does It Matter?

Most calculators use infix notation — you write `3 + 4` and press `=`. The
calculator silently manages the order of operations for you, hiding all the
internal state.

**RPN (postfix notation)** flips this around: operands come first, operators
come after. To compute `(3 + 4) × 2` in RPN:

```
3   Enter  →  stack: [3]
4   Enter  →  stack: [4, 3]
+          →  stack: [7]       (pops 4 and 3, pushes 7)
2   Enter  →  stack: [2, 7]
×          →  stack: [14]      (pops 7 and 2, pushes 14)
```

No parentheses. No hidden precedence rules. The stack *is* the state, and
the state is always visible.

This makes RPN calculators a natural teaching tool for CSCI-13, which covers
data abstraction, data structures, and associated algorithms. A stack-based
calculator is one of the cleanest illustrations of the LIFO contract: every
operation is a transformation of a visible, bounded sequence of values.

Professional engineers have long understood this — Hewlett-Packard shipped
RPN as the default mode on their scientific calculators for decades, and it
remains a favorite of engineers and scientists who value precision and
explicit control over operator precedence.

---

## The Project

The calculator is a JavaFX 17 desktop application with a clean horizontal
layout: a live stack display on the left and a full scientific keypad on
the right.

**Feature highlights:**

- Full scientific function set: trig (`sin`, `cos`, `tan`, `asin`, `acos`,
  `atan`), logarithms (`ln`, `log`), exponentials (`eˣ`, `10ˣ`), roots
  (`sqrt`, `∛x`), powers (`x²`, `yˣ`), and more (`1/x`, `abs`, `x!`)
- Built-in constants π and *e*
- Stack operations: Swap, Drop, Dup, and **50-level undo**
- Memory registers: MS, MR, M+, MC
- Angle mode toggle (DEG / RAD)
- Display format cycle (NORM / FIX / SCI / ENG)
- Full keyboard shortcuts for every operation
- Live scrollable stack visualization

---

## Architecture: Clean Separation of Concerns

The biggest architectural decision was extracting all calculator logic into a
standalone `CalculatorEngine` class with **zero JavaFX dependency**.

```
┌──────────────────────────┐     ┌───────────────────────┐
│  VisualPostfixCalculator │────▶│   CalculatorEngine    │
│                          │     │                       │
│  JavaFX Application      │     │  All calc logic:      │
│  Thin UI layer only      │     │  stack, undo, memory  │
│  Button layout & events  │     │  ops, modes, format   │
│  Stack visualization     │     │                       │
└──────────────────────────┘     └───────────┬───────────┘
                                             │
                                 ┌───────────▼───────────┐
                                 │   LinkedListStack<T>  │
                                 │                       │
                                 │  Generic stack backed │
                                 │  by a LinkedList.     │
                                 │  push/pop/peek/clear  │
                                 │  getContents()        │
                                 └───────────────────────┘
```

`CalculatorEngine` encapsulates:
- A `LinkedListStack<Double>` for the operand stack
- A 50-level undo history (stores full engine snapshots)
- 10 independent memory registers
- Angle mode (DEG/RAD) and display format (NORM/FIX/SCI/ENG)
- All operations return `Optional<String>` — empty means success, a
  present value is an error message for the UI to display

`VisualPostfixCalculator` is a thin layer: it wires buttons to engine calls,
reads the result Optional, and updates the display. It has no calculator
logic of its own.

This separation meant every piece of logic could be tested independently,
without needing a running JavaFX application at all.

### Custom LinkedListStack

The stack is a hand-rolled `LinkedListStack<T>` backed by
`java.util.LinkedList`. It was built from scratch rather than using
`java.util.Stack` to make the data structure relationship explicit for the
CSCI-13 context. It exposes `push`, `pop`, `peek`, `clear`, `size`,
`isEmpty`, and a `getContents()` snapshot method that returns a copy for
safe display rendering.

---

## Testing: Three Levels Deep

The project ships with 296 tests across four test classes:

| Class | Type | Coverage |
|---|---|---|
| `LinkedListStackTest` | Unit | All stack methods and edge cases |
| `CalculatorLogicTest` | Unit | 150+ corner cases across every engine method |
| `CalculatorIntegrationTest` | Integration | Multi-step RPN workflows, trig identities, log laws, undo chains, error recovery |
| `CalculatorUITest` | E2E | Full UI using TestFX — buttons, keyboard, modes, memory |

The E2E tests use [TestFX](https://github.com/TestFX/TestFX), a framework
for testing JavaFX applications. One interesting challenge: on WSL2, the
AWT Robot (which TestFX normally uses to simulate mouse clicks) doesn't
reliably deliver events through the WSLg display layer. The fix was to
use `interact(() -> button.fire())` — triggering button actions directly
on the JavaFX Application Thread — instead of mouse simulation. Keyboard
input via `write()` and `type()` worked fine throughout.

All 296 tests pass.

---

## AI-Assisted Development

This project was built with [Anthropic's Claude](https://claude.ai) as a
collaborative partner throughout. That's worth being transparent about.

AI assistance was used for:
- **Architecture decisions** — suggesting the engine/UI separation
- **Scaffolding** — generating initial implementations to review and modify
- **Debugging** — tracing test failures (like the TestFX/WSL2 issue above)
  and reasoning through edge cases
- **Test generation** — producing comprehensive corner-case test suites

This is the same way a professional engineer uses documentation, Stack
Overflow, or a senior colleague. Every line of generated code was reviewed,
understood, and often modified before integration. The understanding stayed
with the developer; the AI accelerated the work.

CSCI-13's emphasis on software engineering techniques makes this a
particularly relevant approach to model: AI tools are part of the modern
engineering toolkit, and using them well — with critical judgment, not blind
acceptance — is a skill worth developing alongside the fundamentals.

---

## Getting Started

```bash
# Clone
git clone https://github.com/ScottsSecondAct/VisualPostfixCalculator.git
cd VisualPostfixCalculator

# Run (requires Java 17+)
./gradlew run

# Run all tests
./gradlew test
```

Runs on Windows, macOS, and Linux. On WSL2 (Windows Subsystem for Linux),
WSLg provides the display automatically on Windows 11 and Windows 10
build 21362+.

---

## What's Next

The stack visualization is the heart of this project — it turns an abstract
concept into something you can watch evolve with every keystroke. Future
directions might include a history/trace mode that shows each RPN step as
an annotated replay, or a "teach mode" that explains what each operation did
to the stack in plain language.

The source is MIT licensed and lives on GitHub:
**[github.com/ScottsSecondAct/VisualPostfixCalculator](https://github.com/ScottsSecondAct/VisualPostfixCalculator)**

---

*Built for CSCI-13 — Programming Concepts and Methodology II at
[Sierra College](https://www.sierracollege.edu).*
