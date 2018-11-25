// Top-level Icarus version: CPU and UART
// (c) 2017 Warren Toomey, GPL3

`include "cscv2.v"
`include "uart.v"

module icarus_top (
  	input 	      dblclk	// Clock signal
  );

  // CPU wires
  /* verilator lint_off UNUSED */
  wire [3:0]  Aval;
  wire [3:0]  Bval;
  wire [7:0]  PCval;
  wire        RAMwrite;
  wire [7:0]  address;
  wire [3:0]  Flagsval;
  wire [2:0]  ALUop;
  wire [3:0]  ALUresult;
  wire [3:0]  RAMresult;
  wire [3:0]  databus;
  wire        Aload;
  wire        Bload;
  wire        Asel;

  // UART input
  wire [7:0] AB;
  wire	     TX;	// UART control line
  assign AB[7:4] = Aval;
  assign AB[3:0] = Bval;

  // Components
  cscv2 CPU(dblclk, TX, Aval, Bval, PCval, RAMwrite, address, Flagsval,
	    ALUop, ALUresult, RAMresult, databus, Aload, Bload, Asel);
  uart UART(AB, TX);

endmodule
