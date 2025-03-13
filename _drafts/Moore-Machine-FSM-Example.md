---
title: An Example of a Moore Machine
categories:
  - Blog
tags:
  - Computer Engineering
  - Digital Logic
  - State Machines
  - Verilog
---

### Examples

#### Moore Machine Example

- States: S0, S1, S2
- Inputs: 1-bit Input
- Outputs: 1-bit Output

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

![Moore Machine State Diagram](/assets/images/moore-machine.png)

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

