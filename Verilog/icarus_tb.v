`include "icarus_top.v"
module icarus_tb();

// Declare inputs as regs and outputs as wires
reg clk;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, icarus_tb);
  clk = 0;       	// initial value of clk
  #800000 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #1 clk = ~clk; 	// Toggle clk every tick
end

// Connect DUT to test bench
icarus_top DUT(
        clk           	// Clock signal
);

endmodule
