// Crazy Small CPU version 2
// (c) 2017 Warren Toomey, GPL3

`include "register.v"
`include "alu.v"
`include "botrom.v"
`include "pc.v"
`include "ram.v"
`include "toprom.v"

module cscv2 (
	clk,		// Clock signal
	Aval,		// Output of A register
	Bval,		// Output of B register
	PCval,		// Output of PC
	RAMwrite,
	address,
	Flagsval,
	ALUop,
	ALUresult,
	Aload,
	Bload,
	Asel
  );

  // I/O Definitions
  input 	clk;
  output [3:0]  Aval;
  output [3:0]  Bval;
  output [7:0]  PCval;
  output	RAMwrite;
  output [7:0]  address;
  output [3:0]  Flagsval;
  output [2:0]  ALUop;
  output [3:0]  ALUresult;
  output        Aload;
  output        Bload;
  output       Asel;

  // I/O Wires
  wire       clk;
  wire [3:0] Aval;
  wire [3:0] Bval;
  wire [7:0] PCval;

  // Control Wires
  wire [2:0] ALUop;
  wire       PCincr;
  wire       Aload;
  wire       Bload;
  wire       Asel;
  wire       RAMwrite;

  // Register outputs
  wire [3:0] Flagsval;
  wire [7:0] address;	// From bottom ROM
  wire Cin;
  assign Cin= Flagsval[0];

  // Lower 4 bits of the address
  wire [3:0] addrlow;
  assign addrlow= address[3:0];

  // ALU output
  wire [3:0] ALUresult;
  wire [3:0] ALUflags;

  // Register multiplexer
  wire [3:0] regmux;
  assign regmux= (Asel) ? ALUresult : addrlow;

  // Components
  register A(clk, Aload, regmux, Aval);
  register B(clk, Bload, regmux, Bval);
  register Flags(clk, RAMwrite, ALUflags, Flagsval);
  pc PC(clk, PCincr, address, PCval);
  alu ALU(Aval, Bval, ALUop, Cin, RAMwrite, Asel, ALUresult, ALUflags);
  toprom TOP(PCval, Flagsval, ALUop, PCincr, Aload, Bload, Asel, RAMwrite);
  botrom BOT(PCval, Flagsval, address);
  ram RAM(clk, address, ALUresult, RAMwrite);

endmodule
