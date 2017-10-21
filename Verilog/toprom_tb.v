`include "toprom.v"
module toprom_tb();
reg clock;
// Declare inputs as regs and outputs as wires
reg  [7:0] PC;
reg  [3:0] NZVC;
reg        enable;
wire [2:0] ALUop;
wire       PCincr;
wire       Aload;
wire       Bload;
wire       Asel;
wire       RAMwrite;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, toprom_tb);
  $display ("time\tPC NZVC en ALUop PCincr Aload Bload Asel RAMwr");
  $monitor ("%g\t%h %b  %b     %h    %b     %b     %b     %b    %b", 
	  $time, PC, NZVC, enable, ALUop, PCincr, Aload, Bload, Asel, RAMwrite);
  clock = 1;       // initial value of clock
  enable=0;
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
toprom U_toprom (
        PC,             // PC's value
        NZVC,           // Flags value
        enable,         // Enable, active low
        ALUop,          // Outputs
        PCincr,
        Aload,
        Bload,
        Asel,
        RAMwrite
);

endmodule
