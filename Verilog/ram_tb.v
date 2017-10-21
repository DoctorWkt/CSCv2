`include "ram.v"
module ram_tb();
reg clk;
// Declare inputs as regs and outputs as wires
reg  [7:0] address;
reg        enable;

// Deal with inout data
wire [3:0] output_data;
wire [3:0] bidir_data;
reg [3:0] input_data;

assign output_data = bidir_data;
assign bidir_data = (enable) ? 4'bz : input_data;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, ram_tb);
  $display ("time\taddress we indata outdata");
  $monitor ("%g\t%h      %b  %h      %h",
	  $time, address, enable, input_data, output_data);
  clk = 1;       // initial value of clk
  address=1;
  input_data=3;
  enable=0;
  #2 enable=1;
  #2 address=4;
  #2 address=1;
  #2 address=5;
  input_data=6;
  enable=0;
  #2 enable=1;
  address=1;
  #2 address=5;
  #100 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #1 clk = ~clk; // Toggle clk every 5 ticks
end

// Connect DUT to test bench
ram U_ram (
	clk         , // Clock Input
	address     , // Address Input
	bidir_data  , // Data bi-directional
	enable        // Write enable, active low
);

endmodule
