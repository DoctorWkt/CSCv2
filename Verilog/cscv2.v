// Crazy Small CPU version 2
// (c) 2017 Warren Toomey, GPL3

// Just a few notes on the Verilog implementation of the CSCv2.
//
// Firstly, the ram.v component waits a clock cycle before it
// outputs when the address changes. So we give it a clock signal
// twice the frequency of the main CPU clock signal.
//
// The UART is now separate from the CPU, but we output the TX
// control line which is still the OR of Aload, Bload and the clock.
//
// Because the high impedance logic state doesn't get synthesised well,
// there is a new multiplexer, databus. This chooses either the RAM
// output or the ALU output based on the RAMwrite control line.
//
// Apart from the above, everything else is exactly the same as the
// version made from 7400-style chips.

`include "register.v"
`include "alu.v"
`include "botrom.v"
`include "pc.v"
`include "ram.v"
`include "toprom.v"

module cscv2 (
  	input 	      dblclk,	// Clock signal
	output	      TX,	// UART control line, active low
  	output [3:0]  Aval,	// Output of A register
  	output [3:0]  Bval,	// Output of B register
				// Outputs of other internal data/control lines.
				// Used for debugging and diagnostics
  	output [7:0]  PCval,
  	output	      RAMwrite,
  	output [7:0]  address,
  	output [3:0]  Flagsval,
  	output [2:0]  ALUop,
  	output [3:0]  ALUresult,
  	output [3:0]  RAMresult,
  	output [3:0]  databus,
  	output        Aload,
  	output        Bload,
  	output        Asel
  );

  // Half speed clock, i.e. half the speed of the RAM clock
  reg clk= 0;

  // Control Wires not provided as outputs
  wire       PCincr;

  // Register outputs
  wire Cin;
  assign Cin= Flagsval[0];

  // Lower 4 bits of the address
  wire [3:0] addrlow;
  assign addrlow= address[3:0];

  // ALU output
  wire [3:0] ALUflags;

  // Register multiplexer
  wire [3:0] regmux;
  assign regmux= (Asel) ? databus : addrlow;

  // New multiplexer to avoid high-Z logic
  assign databus= (RAMwrite) ? RAMresult : ALUresult;

  // UART control line
  assign TX = Aload | Bload | clk;

  // Components
  register A(clk, Aload, regmux, Aval);
  register B(clk, Bload, regmux, Bval);
  register Flags(clk, RAMwrite, ALUflags, Flagsval);
  pc PC(clk, PCincr, address, PCval);
  alu ALU(Aval, Bval, ALUop, Cin, Asel, ALUresult, ALUflags);
  toprom TOP(PCval, Flagsval, ALUop, PCincr, Aload, Bload, Asel, RAMwrite);
  botrom BOT(PCval, Flagsval, address);
  ram RAM(dblclk, address, ALUresult, RAMresult, RAMwrite);

  // Calculate the CPU clock from the RAM clock
  always @(posedge dblclk)
     clk <= ~clk;

endmodule
