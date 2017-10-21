`include "botrom.v"
module botrom_tb();
reg clock;
// Declare inputs as regs and outputs as wires
reg  [7:0] PC;
reg  [3:0] NZVC;
wire [7:0] address;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, botrom_tb);
  $display ("time\tPC NZVC address");
  $monitor ("%g\t%h    %h",
	  $time, PC, NZVC, address);
  clock = 1;       // initial value of clock
  PC=0;
  NZVC=0;
  #2 PC=1;
  #2 PC=2;
  #2 PC=3;
  #100 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #1 clock = ~clock; // Toggle clock every 5 ticks
end

// Connect DUT to test bench
botrom U_botrom (
        PC,             // PC's value
        NZVC,           // Flags value
        address         // Output
);

endmodule
