`include "register.v"
module register_tb();
reg clk;
// Declare inputs as regs and outputs as wires
reg        load;
reg  [3:0] data;
wire [3:0] result;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, register_tb);
  $display ("time\t  clk load data result\n");
  $monitor ("%g\t %b %b %b %b", 
	  $time, clk, load, data, result);
  clk = 1;       // initial value of clk
  load= 1;
  data= 4'h2;
  // Load the data
  #2 load= 0;
  #2 load= 1;
  // Load new data
  data= 4'h5;
  #2 load= 0;
  #2 load= 1;
  #100 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #1 clk = ~clk; // Toggle clk every tick
end

// Connect DUT to test bench
register U_register (
        clk,            // Clock input
        load,           // Load line (active low)
        data,           // Input data
        result          // Register output
);

endmodule
