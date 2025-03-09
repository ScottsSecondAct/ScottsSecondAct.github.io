---
title: A Guide to Moore and Mealy Machines
categories:
  - Blog
tags:
  - Computer Engineering
  - Digital Logic
  - State Machines
  - Verilog
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

A Moore machine is a 6-tuple:

- ![S](https://latex.codecogs.com/svg.image?&space;S): Finite set of states.
- ![S0](https://latex.codecogs.com/svg.image?&space;S_0): Initial state, ![S0 in S](https://latex.codecogs.com/svg.image?&space;S_0\in&space;S)
- ![Σ](https://latex.codecogs.com/svg.image?\Sigma): Finite set of input symbols (alphabet).
- ![O](https://latex.codecogs.com/svg.image?O): Finite set of output symbols (alphabet).
- ![δ](https://latex.codecogs.com/svg.image?\delta): State transition function,  ![δ: S x Σ → S](https://latex.codecogs.com/svg.image?\delta:S\times\Sigma\rightarrow&space;S).
- ![G](https://latex.codecogs.com/svg.image?G): Output function, ![G: S → O](https://latex.codecogs.com/svg.image?G:S\rightarrow&space;O).

#### Properties

- The output depends only on the current state.
- They often require more states compared to Mealy machines.

#### State Diagram Representation

![Alternative Text](/assets/images/Moore-Automat-en.svg)

### Mealy Machines

In Mealy machines, the output depends on both the current state and the current input. Hence, outputs are associated with transitions rather than states.

#### Formal Definition

A Mealy machine is a 6-tuple:

- ![S](https://latex.codecogs.com/svg.image?&space;S): Finite set of states.
- ![S0](https://latex.codecogs.com/svg.image?&space;S_0): Initial state, ![S0 in S](https://latex.codecogs.com/svg.image?&space;S_0\in&space;S)
- ![Σ](https://latex.codecogs.com/svg.image?\Sigma): Finite set of input symbols (alphabet).
- ![O](https://latex.codecogs.com/svg.image?O): Finite set of output symbols (alphabet).
- ![δ](https://latex.codecogs.com/svg.image?\delta): State transition function,  ![δ: S x Σ → S](https://latex.codecogs.com/svg.image?\delta:S\times\Sigma\rightarrow&space;S).
- ![G](https://latex.codecogs.com/svg.image?G): Output function, ![G:  Sx Σ → O](https://latex.codecogs.com/svg.image?G:S\times\Sigma\rightarrow&space;O).

#### Properties

- The output depends on both current state and input.
- They often require fewer states compared to Moore machines.

#### State Diagram Representation

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

- States: S0, S1, S2
- Inputs: 1-bit Input_X
- Outputs: 1-bit Output_Y

#### Moore Machine Example

##### State Table

|Current State | Input_X | Next State | Output_Y |
|--------------|-------|------------|--------|
| S0 | 0 | S0 | 0 |
| S0 | 1 | S1 | 0 |
| S1 | 0 | S2 | 1 |
| S1 | 1 | S1 | 1 |
| S2 | 0 | S0 | 0 |
| S2 | 1 | S2 | 0 |

##### Verilog Implementation

{% highlight Verilog %}
module moore_fsm (
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state, next_state;

// State encoding
localparam S0 = 2'b00,
           S1 = 2'b01,
           S2 = 2'b10;

// Sequential logic (state register)
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= S0;
    else
        state <= next_state;
end

// Combinational logic (next state logic)
always @(*) begin
    case(state)
        S0: next_state = in ? S1 : S0;
        S1: next_state = in ? S1 : S2;
        S2: next_state = in ? S2 : S0;
        default: next_state = S0;
    endcase
end

// Output logic (Moore output depends only on the current state)
always @(*) begin
    case (state)
        S0: out = 1'b0;
        S1: out = 1'b1;
        S2: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule
{% endhighlight %}

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
