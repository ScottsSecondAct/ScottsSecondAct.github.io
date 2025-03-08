---
title: A Guide to Moore and Mealy Machines
categories:
  - Blog
tags:
  - Computer Engineering
  - Digital Logic
  - State Machines
---
Finite State Machines (FSMs) are computational models used to represent and control the behavior of systems through states and transitions. They’re widely used in areas such as digital circuit design, compiler design, communication protocols, and software modeling.

An FSM consists of:

- **States:** Defined configurations representing various possible situations the system can be in.
- **Inputs:** Events or signals that trigger transitions between states.
- **Outputs:** Results or actions associated with states or transitions.
- **Transitions:** Rules determining state changes based on inputs.
- **Initial State:** The starting point of the machine.

FSMs can be represented visually using state diagrams, with circles representing states, arrows denoting transitions, and labeled inputs/outputs.

## Moore and Mealy Machines

Two fundamental types of FSMs are:

- **Moore Machines**
- **Mealy Machines**

### Moore Machines

In Moore machines, the current output is determined solely by the current state of the machine. The input affects transitions between states, but not the output directly.

#### Formal Definition

A Moore machine is a 6-tuple \( M = (S, s_0, \Sigma, O, \delta, G) \):

- \( S \): Finite set of states.
- \( s_0 \): Initial state, \( s_0 \in S \).
- \( \Sigma \): Finite set of input symbols (alphabet).
- \( O \): Finite set of output symbols (alphabet).
- \( \delta \): State transition function, \( \delta: S \times \Sigma \rightarrow S \).
- \( G \): Output function, \( G: S \rightarrow O \).

#### Properties

- Output depends only on the current state.
- Often requires more states compared to Mealy machines.

#### State Diagram Representation

![Alternative Text](/assets/images/Moore-Automat-en.svg)

### Mealy Machines

In Mealy machines, the output depends on both the current state and the current input. Hence, outputs are associated with transitions rather than states.

#### Formal Definition

A Mealy machine is a 6-tuple \( M = (Q, \Sigma, \Delta, \delta, \lambda, q_0) \):

- \( Q \): Finite set of states.
- \( \Sigma \): Finite set of input symbols (alphabet).
- \( \Delta \): Finite set of output symbols.
- \( \delta \): State transition function, \( \delta: Q \times \Sigma \rightarrow Q \).
- \( \lambda \): Output function, \( \lambda: Q \times \Sigma \rightarrow \Delta \).
- \( q_0 \): Initial state, \( q_0 \in Q \).

#### Properties

- Output depends on both current state and input.
- Usually requires fewer states compared to Moore machines.

#### State Diagram Representation

State diagram for a Mealy machine:

   input/output
       |
       v
+------------+
|  State A   |
+------------+

#### Key Differences

| Feature                 | Moore Machine                     | Mealy Machine                          |
|-------------------------|-----------------------------------|----------------------------------------|
| Output depends on       | Current state                     | Current state and input                |
| Output association      | With states                        | With transitions                       |
| Number of states        | Typically more                    | Typically fewer                        |
| Speed of response       | Slower (output after state)       | Faster (output during transition)      |
| Complexity of design    | Simpler output logic              | Slightly more complex output logic     |

---

### 4. Example Comparison

#### Moore Machine Example:

Consider a Moore machine that outputs `1` when the number of `1` inputs seen so far is even, and outputs `0` otherwise.

- States: Even (E), Odd (O)
- Outputs: State E → `1`, State O → `0`

| Current State | Input | Next State | Output |
|---------------|-------|------------|--------|
| E             | 0     | E          | 1      |
| E             | 1     | O          | 1      |
| O             | 0     | O          | 0      |
| O             | 1     | E          | 0      |

#### Mealy Machine Example

A Mealy machine example: Outputs `1` whenever input transitions from `0` to `1`.

| Current State | Input | Next State | Output |
|---------------|-------|------------|--------|
| A             | 0     | A          | 0      |
| A             | 1     | B          | 1      |
| B             | 0     | A          | 0      |
| B             | 1     | B          | 0      |

### 5. Practical Applications

- **Moore Machines**:
  - Traffic light control systems
  - Vending machines with outputs dependent on internal state (e.g., current amount of money inserted)
  - Control logic circuits

- **Mealy Machines**:
  - Real-time communication protocols
  - Data transmission and encoding systems
  - Signal edge detection in digital circuits

### 6. Summary

- **Moore Machines** have state-based outputs, simpler to understand but may require more states.
- **Mealy Machines** have transition-based outputs, allowing fewer states and faster reactions, but slightly more complex logic.

Choosing between Moore and Mealy machines depends on the specific application requirements, complexity constraints, and speed of output responses required.
