`include "pc.v"
module pc_tb();
reg clk;
// Declare inputs as regs and outputs as wires
reg        PCincr;
reg  [7:0] data;
wire [7:0] result;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, pc_tb);
  $display ("time\tclk PCincr data result");
  $monitor ("%g\t %b     %b    %h    %h", 
	  $time, clk, PCincr, data, result);
  clk = 0;       // initial value of clk
  PCincr= 1;
  #1 data= 4'h2;
  // Increment the PC
  #2 PCincr= 1;
  #2 PCincr= 1;
  // Load the data
  #2 PCincr= 0;
  #2 PCincr= 1;
  // Load new data
  data= 4'h5;
  #2 PCincr= 0;
  #2 PCincr= 1;
  #100 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #1 clk = ~clk; // Toggle clk every tick
end

// Connect DUT to test bench
pc U_pc (
        clk,            // Clock input
        PCincr,         // Increment PC
        data,           // Input data
        result          // PC output
);

endmodule
