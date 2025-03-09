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
Finite State Machines (FSMs) are computational models used to represent and control the behavior of systems through states and transitions. They’re widely used in areas such as digital circuit design, compiler design, communication protocols, and software modeling.  This post describes two fundamental types of FSMs: the Moore machine and the Mealy machine

- [Finite State Machines](#finite-state-machines)
- [Moore and Mealy Machines](#moore-and-mealy-machines)
  - [Moore Machines](#moore-machines)
    - [Formal Definition](#formal-definition)
    - [Properties](#properties)
    - [State Diagram Representation](#state-diagram-representation)
  - [Mealy Machines](#mealy-machines)
    - [Formal Definition](#formal-definition-1)
    - [Properties](#properties-1)
    - [State Diagram Representation](#state-diagram-representation-1)
  - [Key Differences](#key-differences)
  - [Examples](#examples)
    - [Moore Machine Example](#moore-machine-example)
      - [State Table](#state-table)
      - [State Diagram](#state-diagram)
      - [Verilog Implementation](#verilog-implementation)
    - [Mealy Machine Example](#mealy-machine-example)
  - [Practical Applications](#practical-applications)
  - [Summary](#summary)

## Finite State Machines

An FSM consists of:

- **States:** Defined configurations representing various possible situations the system can be in.
- **Inputs:** Events or signals that trigger transitions between states.
- **Outputs:** Results or actions associated with states or transitions.
- **Transitions:** Rules determining state changes based on inputs.
- **Initial State:** The starting point of the machine.

FSMs can be represented visually using state diagrams, with circles representing states, arrows denoting transitions, and labeled inputs/outputs.

## Moore and Mealy Machines

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

coming soon

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

coming soon

### Key Differences

| Feature                 | Moore Machine                     | Mealy Machine                          |
|-------------------------|-----------------------------------|----------------------------------------|
| Output depends on       | Current state                     | Current state and input                |
| Output association      | With states                        | With transitions                       |
| Number of states        | Typically more                    | Typically fewer                        |
| Speed of response       | Slower (output after state)       | Faster (output during transition)      |
| Complexity of design    | Simpler output logic              | Slightly more complex output logic     |

---

### Examples

- States: S0, S1, S2
- Inputs: 1-bit Input_X
- Outputs: 1-bit Output_Y

#### Moore Machine Example

##### State Table

|Current State | Input | Next State | Output |
|--------------|-------|------------|--------|
| S0 | 0 | S0 | 0 |
| S0 | 1 | S1 | 0 |
| S1 | 0 | S2 | 1 |
| S1 | 1 | S1 | 1 |
| S2 | 0 | S0 | 0 |
| S2 | 1 | S2 | 0 |

##### State Diagram

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

// Testbench
module moore_fsm_tb;

// Inputs
reg clk;
reg reset;
reg in;

// Outputs
wire out;

// Instantiate the Unit Under Test (UUT)
moore_fsm uut (
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out)
);

// Clock generation (10 ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Dump waveforms for post-simulation analysis
 initial begin
    $dumpfile("moore_fsm_tb.vcd");
    $dumpvars(0, moore_fsm_tb);
end

    // Reset task
task apply_reset;
    input [31:0] duration;
    begin
        reset = 1;
        #duration;
        reset = 0;
    end
endtask

initial begin
    // Initialize Inputs
    in = 0;
    apply_reset(10);  // Apply reset for 10 ns

    // Wait for a clock edge after reset deassertion
    @(negedge clk);

    // Test Sequence with self-checking
    // Initiallin in S0, expected output = 0
    in = 0;
    @(negedge clk);
    if (out !== 0) $display("Error at time %0t", $time);

    // Transition to S1, expecting output = 1
    in = 1;
    @(negedge clk);
    if (out !== 1) $display("Error at time %0t", $time);

    // Stay in S1, expecting output = 1
    in = 1;
    @(negedge clk);
    if (out !== 1) $display("Error at time %0t", $time);

    // Transition to S2, expecting output = 0
    in = 0;
    @(negedge clk);
    if (out !== 0) $display("Error at time %0t", $time);

    // Transition to S0, expecting output = 0
    in = 0;
    @(negedge clk);
    if (out !== 0) $display("Error at time %0t", $time);

    // Transition to S1, expecting output = 1
    in = 1;
    @(negedge clk);
    if (out !== 1) $display("Error at time %0t", $time);

    // Transition to S2, expecting output = 0
    in = 0;
    @(negedge clk);
    if (out !== 0) $display("Error at time %0t", $time);

    // Stay in S2, expecting output = 0
    in = 1;
    @(negedge clk);
    if (out !== 0) $display("Error at time %0t", $time);

    // Return to S0, expecting output = 0
    in = 0;
    @(negedge clk);
    if (out !== 0) $display("Error at time %0t", $time);

    // End simulation after test completion
    #10;
    $display("Test completed at time %0t", $time);
    $finish;
end

    // Monitor outputs continuously
initial begin
    $monitor("Time=%0t | reset=%b | in=%b | state=%b | out=%b",
        $time, reset, in, uut.state, out);
end

endmodule
{% endhighlight %}

#### Mealy Machine Example

coming soon

### Practical Applications

- **Moore Machines**:
  - Traffic light control systems
  - Vending machines with outputs dependent on internal state (e.g., current amount of money inserted)
  - Control logic circuits
  - Digital locks and security systems
  - Elevator control systems
  - Game states
  - Industrial controllers

- **Mealy Machines**:
  - Real-time communication protocols
  - Data transmission and encoding systems
  - Signal edge detection in digital circuits
  - Interactive User Interfaces
  - Real-time control systems
  - Error detection and correction

### Summary

- **Moore Machines** have state-based outputs, simpler to understand but may require more states.
- **Mealy Machines** have transition-based outputs, allowing fewer states and faster reactions, but slightly more complex logic.

Choosing between Moore and Mealy machines depends on the specific application requirements, complexity constraints, and speed of output responses required.
