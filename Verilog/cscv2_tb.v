`include "cscv2.v"
module cscv2_tb();

// Declare inputs as regs and outputs as wires
reg clk;
wire [3:0] A;
wire [3:0] B;
wire [7:0] PC;
wire RAMwrite;
wire [7:0] address;
wire [3:0] Flagsval;
wire [2:0] ALUop;
wire [3:0] ALUresult;
wire Aload;
wire Bload;
wire Asel;
wire [7:0] AB;
assign AB[7:4] = A;
assign AB[3:0] = B;

// Initialize all variables
initial begin        
  $dumpfile("test.vcd");
  $dumpvars(0, cscv2_tb);
//  $display ("time\tclk PC A B RMw addr NZVC Aop Ars Al Bl Asl");
//  $monitor ("%g\t %b  %h %h %h  %h   %h  %b  %h  %h   %b  %b   %b", 
//   	  $time, clk, PC, A, B, RAMwrite, address, Flagsval,
//   		ALUop, ALUresult, Aload, Bload, Asel);
  clk = 1;       // initial value of clk
  #800000 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #1 clk = ~clk; // Toggle clk every tick
end

// UART output
always @ (posedge clk)
begin : UART
  if ( !Aload && !Bload ) begin
    $write("%c", AB);
  end
end

// Connect DUT to test bench
cscv2 U_cscv2 (
        clk,            // Clock signal
        A,           	// Output of A register
        B,           	// Output of B register
        PC,           	// Output of PC
	RAMwrite,
	address,
	Flagsval,
	ALUop,
	ALUresult,
	Aload,
	Bload,
	Asel
);

endmodule
