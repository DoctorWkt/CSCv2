`include "alu.v"
module alu_tb();
reg clock;
// Declare inputs as regs and outputs as wires
reg  [3:0] A;
reg  [3:0] B;
reg  [2:0] ALUop;
reg        Cin;
reg        enable;
reg        ALUbank;
wire [3:0] result;
wire [3:0] flags;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, alu_tb);
  $display ("time\t  A    B     ALUbank ALUop Cin result NZVC");
  $monitor ("%g\t %b %b      %b     %b  %b   %b  %b", 
	  $time, A, B, ALUbank, ALUop, Cin, result, flags);
  clock = 1;       // initial value of clock
  // Add 0+1
  A= 4'h0;
  B= 4'h1;
  ALUbank= 1;
  ALUop= 3'h0;
  Cin= 0;
  enable= 0;
  // Add 7 + 1
  #2 A= 4'h7;
  B= 4'h1;
  ALUbank= 1;
  ALUop= 3'h0;
  Cin= 0;
  // Disable the output
  #2 enable=1;
  // Enable the output
  #2 enable=0;
  #100 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #1 clock = ~clock; // Toggle clock every 5 ticks
end

// Connect DUT to test bench
alu U_alu (
        A,              // First operand
        B,              // Second operand
        ALUop,          // ALU operation
        Cin,            // Carry in
	enable,         // Enable, active low
        ALUbank,        // Which operation bank in use
        result,         // ALU result
        flags
);

endmodule
