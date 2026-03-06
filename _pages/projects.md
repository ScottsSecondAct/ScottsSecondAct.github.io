---
title: "Projects"
layout: single
permalink: /projects/
author_profile: true
toc: true
toc_label: "Contents"
math: true
---

## tiny-os

A bare-metal real-time operating system for the Raspberry Pi 5, written in Rust.

### Overview

tiny-os is a preemptive, priority-based RTOS targeting the Broadcom BCM2712 system-on-chip at the heart of the Raspberry Pi 5. It runs directly on the hardware with no underlying operating system — just the ARM Cortex-A76 cores, a kernel, and your tasks.

The project explores what it takes to build an operating system from scratch on modern 64-bit ARM hardware: bootstrapping from the GPU bootloader, configuring the MMU and GIC interrupt controller, implementing a deterministic scheduler, and providing inter-task communication primitives that work correctly in both single-core and SMP configurations.

### Goals

- **Deterministic scheduling** with sub-microsecond interrupt-to-task latency on a 2.4 GHz Cortex-A76 core
- **Static allocation throughout** — no heap in the kernel, fixed-size memory pools, all objects allocated at initialization
- **MMU-based task isolation** using ARMv8-A translation tables with per-task address spaces and ASID-tagged TLB entries
- **Configurable SMP support** — run on one core or all four, with per-core ready queues and IPI-based cross-core signaling
- **Rust implementation** (`#[no_std]`, `aarch64-unknown-none` target) with assembly limited to the exception vector table, context switch, and EL2-to-EL1 drop

### Hardware

| | |
|---|---|
| **SoC** | Broadcom BCM2712 (C1 and D0 steppings) |
| **CPU** | Quad-core ARM Cortex-A76 @ 2.4 GHz, ARMv8.2-A |
| **RAM** | 1–16 GB LPDDR4X (all Pi 5 variants supported) |
| **Interrupts** | ARM GICv2 (GIC-400) |
| **Timer** | ARMv8 Generic Timer, 54 MHz |
| **I/O** | RP1 southbridge via PCIe x4 |

tiny-os also runs on the Raspberry Pi 500, 500+, and Compute Module 5.

### Architecture

The kernel executes at EL1. Application tasks run at EL0 with hardware-enforced memory isolation. System calls enter the kernel through SVC exceptions; hardware interrupts are routed through the GIC.

Key subsystems:

- **Scheduler** — Preemptive fixed-priority with O(1) task selection via CLZ on a 256-level priority bitmap. Optional round-robin time-slicing within equal-priority levels.
- **Context switch** — Full AArch64 register save/restore (X0–X30, SP_EL0, ELR_EL1, SPSR_EL1) with lazy NEON/FP save. MMU context switch via TTBR0_EL1 with ASID tagging to avoid TLB flushes.
- **IPC** — Counting semaphores, mutexes with priority inheritance, fixed-size message queues, and event flags. All primitives are SMP-safe.
- **Memory** — Fixed-size block pool allocator with O(1) alloc/free. Guard pages for hardware stack overflow detection. Per-task page tables with configurable memory regions.
- **Drivers** — Uniform trait-based driver interface. Included drivers for RP1 UART (PL011), SPI, I2C, GPIO, Gigabit Ethernet, and BCM2712 SD controller.

### Bare-Metal Boot

tiny-os boots as `kernel8.img` from the Pi 5's FAT32 boot partition. Three `config.txt` settings are essential for bare-metal operation:

| Setting | Purpose |
|---|---|
| `os_check=0` | Disables the firmware's OS compatibility check |
| `uart_early_init=1` | Firmware initializes RP1 UART0 and preserves the PCIe link to RP1 |
| `pciex4_reset=0` | Inherits firmware's PCIe configuration, avoiding the need for a full RC driver at boot |

### Safety Targets

The design targets IEC 61508 SIL-2 and ISO 26262 ASIL-B certification, leveraging the Ferrocene qualified Rust toolchain. All `unsafe` code is confined to well-documented modules with explicit safety invariant comments.

### Status

tiny-os is in active development. The formal specification (v1.1) is complete and covers all kernel subsystems, the SMP model, and the Raspberry Pi 5 hardware platform. Implementation is proceeding through a ten-phase roadmap, beginning with bare-metal bootstrap and UART console output.

### Links

- [Specification (v1.1)](https://github.com/ScottsSecondAct/tiny-os/docs/tiny_os_specification_v1.1.docx) — Full technical specification document
- [GitHub](https://github.com/ScottsSecondAct/tiny-os) — Source repository

### Background

tiny-os evolved from an earlier design called simple\_os, which targeted ARM Cortex-M microcontrollers. The pivot to the Raspberry Pi 5 and its Cortex-A76 cores required rethinking the interrupt model (NVIC to GICv2), memory protection (MPU to MMU), privilege model (Thread/Handler mode to EL0/EL1), and the context switch mechanism. The choice of Rust over C was driven by the alignment between Rust's ownership semantics and the kernel's static allocation philosophy — many of the invariants that MISRA C guidelines enforce through coding discipline are checked at compile time by the Rust type system.

---

## OLang — A Domain-Specific Language for Mechanistic Genomics

**OLang** is a native C++23/LLVM 18-powered Domain-Specific Language (DSL) and multi-scale compiler architecture designed to bridge the gap between biological intent and computational implementation. The full title of the research program is:

> *OLang: A Domain-Specific Language and Multi-Scale Compiler Architecture for Mechanistic Genomics and Agentic Modeling of Type 1 Diabetes Pathology*

The dissertation applies OLang to a concrete scientific objective: solving Type 1 Diabetes (T1DM) through CRISPR-mediated immune evasion, specifically the **#BETA-7-X** configuration, orchestrated through a federated AI agent fleet capable of simulating 1 million parallel cellular digital twins.

---

### The Problem

Computational systems biologists are forced to bridge two worlds: the *biological world* of mechanistic hypotheses about genes, cells, and disease, and the *computational world* of C++, Python, and XML configuration files. Existing simulation frameworks (PhysiCell, CompuCell3D) are libraries, not languages. They have no semantic awareness of biological entities, leading to boilerplate code that buries the science.

More critically, as AI-driven laboratory automation enters the picture, there is no formal layer ensuring that AI-generated biological protocols are *safe to execute*. OLang addresses both problems: it provides a dedicated DSL with biological type safety, and it acts as a **Governance-as-Code** layer where biological safety is enforced at the binary level before any simulation or lab instruction runs.

---

### Core Thesis: Governance-as-Code

The central premise is that biological discovery must transition from stochastic, manual experimentation to **formal engineering verification**. OLang enforces this through three primary mechanisms:

- **Dimensional Analysis** — A header-only C++ template library (`Unit<T>`) using compile-time metaprogramming to prevent *Biological Paradoxes* — mass-balance violations, unit mismatches — before any code executes.
- **Formal Verification (LTL)** — Integration of Linear Temporal Logic keywords (`ALWAYS`, `EVENTUALLY`, `PROOF`) into the language grammar to mathematically guarantee that proposed genetic edits maintain stealth immune states across all possible stress tests.
- **Capability-Based RBAC** — A strict Role-Based Access Control system that isolates the **Executor Agent** (physical capability) from the **Simulator Agent** (virtual capability), preventing unverified AI-generated protocols from interacting with lab hardware.

---

### The Language (Frontend)

OLang introduces a type system that treats biological entities as **first-class citizens**:

| Type | Represents | Example |
|------|-----------|---------|
| `Agent` | Discrete, stateful cell | Beta cell, T-cell |
| `Field` | Continuous, diffusive quantity | Glucose, cytokine concentration |
| `Gene` | Regulatory, stochastic network node | HLA-DR3 allele, insulin promoter |

The compiler's semantic analysis layer enforces biological logic at compile time — preventing errors such as "diffusing a cell" or "applying a gene regulatory network to a chemical field." OLang unifies declarative PDE definitions (diffusion equations) with imperative agent behavior (if/then state transitions) in a single coherent syntax.

The `|||` (Massive Parallel) operator is a first-class language construct that the compiler lowers directly to **NVPTX/CUDA kernels**, enabling GPU-scale parallelism without requiring the programmer to write GPU code.

---

### The Compiler (Backend)

The OLang compiler pipeline uses a custom lowering strategy built on the LLVM C++ API:

$$\text{BioIR} \xrightarrow{\text{lower}} \text{MathIR} \xrightarrow{\text{lower}} \text{LLVM IR} \xrightarrow{\text{codegen}} \text{Native Binary / NVPTX}$$

Key backend innovations:

- **AoS → SoA transformation** — The compiler automatically reshapes `Agent` data from Array of Structures (intuitive to write) to Structure of Arrays (SIMD-optimized) during compilation, without the programmer being aware.
- **Hybrid Scheduler** — A runtime engine that synchronizes two fundamentally different time domains:
  - *Continuous time*: deterministic PDE solvers for diffusion fields (Crank-Nicolson scheme)
  - *Discrete time*: stochastic solvers for intracellular gene networks (Gillespie / Kinetic Monte Carlo) and agent state transitions
- **CUDA Kernel Lowering** — The `|||` operator compiles to NVPTX, enabling the Simulator Agent to execute massive parallel workloads on GPU hardware.

---

### The Federated Agent Fleet

OLang is the runtime language for a decentralized discovery loop composed of specialized agents:

1. **Analyst Agent** — Ingests and parses real-world translational data, such as scRNA-seq logs from the Human Pancreas Analysis Program (HPAP).
2. **Strategist Agent** — Operates as the "Architect," using SMT-based declarative solvers to define the mathematical search space for immune evasion configurations.
3. **Simulator Agent** — Executes parallel OLang programs via the `|||` operator, running GPU-accelerated cellular digital twins at scale.
4. **Executor Agent** — The restricted "Handshake" agent that translates only formally verified protocols into physical CRISPR synthesis and robotic lab instructions.

The RBAC layer ensures the Executor Agent can only act on protocols that have passed LTL verification — a hard binary-level guarantee, not a runtime check.

---

### Mechanistic Genomics

OLang embeds **Gene Regulatory Networks (GRNs)** directly into Agent definitions. Genetic variants are not just risk flags — they modify the compiled behavior of the agent. For example, an HLA-DR3/DR4 risk allele does not simply "add risk"; it changes the *probability threshold* of an antigen presentation event in the compiled state machine.

This genotype-to-phenotype mapping allows mechanistic hypotheses about specific genetic variants to be directly expressed, compiled, and tested in simulation. The **#BETA-7-X** configuration represents a specific set of CRISPR edits targeting immune evasion — the formal proof of its stability across immune stress scenarios is a primary deliverable of the dissertation.

---

### Validation: Type 1 Diabetes Model

The scientific proof-of-concept simulates the autoimmune destruction of pancreatic \\(\beta\\)-cells in the Islets of Langerhans.

**Agents modeled:**
- \\(\beta\\)-cells — insulin-producing, subject to apoptosis
- CD8+ T-cells — migrating, cytotoxic killers
- Macrophages — antigen-presenting

**Fields modeled:**
- Glucose, Insulin
- Pro-inflammatory cytokines: IL-1\\(\beta\\), TNF-\\(\alpha\\)

**Mathematical Engine:**
- **Kinetic Monte Carlo (KMC)** for stochastic immunological synapse binding events
- **Flux Balance Analysis (FBA)** for deterministic metabolic steady-state verification

**Copy-on-Write (CoW) Snapshots** enable simulation at scale: parallel runs share a read-only baseline Islet State, allocating thread-local memory only for specific genetic deltas — enabling 1 million concurrent simulations on standard GPU hardware.

**Success criterion:** The model formally proves that the **#BETA-7-X** configuration maintains immune stealth across all stress-tested HLA genetic starting conditions, without hand-tuning parameters.

---

### Performance Goals

| Metric | Target |
|--------|--------|
| Compilation time | Comparable to C++ (LLVM backend) |
| Execution speed | Within 2× of hand-written PhysiCell C++ |
| Parallel scale | \\(10^6\\) concurrent cellular digital twins (GPU) |
| Formal verification | LTL proof of #BETA-7-X across all immune stress scenarios |

---

### Roadmap to Matriculation

| Phase | Timeline | Milestones |
|-------|----------|-----------|
| **Phase 1** | 2026 | ANTLR4 C++ frontend, AST, `Unit<T>` template library, basic compiler pipeline |
| **Phase 2** | 2027 | LLVM C++ API integration, IR generation, CUDA parallel runtime, federated agent framework |
| **Phase 3** | 2028 | Hardware bridge (Executor Agent), wet-lab validation, formal LTL proof of #BETA-7-X |

---

### Status

OLang is an active research project in Phase 1. Early syntax design, the ANTLR4 frontend, and the `Unit<T>` compile-time dimensional analysis library are underway. The T1D simulation and formal verification of the **#BETA-7-X** configuration serve as the primary scientific validation targets.
