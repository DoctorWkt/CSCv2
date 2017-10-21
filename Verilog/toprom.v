// Top ROM
// (c) 2017 Warren Toomey, GPL3

module toprom (
	PC,		// PC's value
	NZVC,		// Flags value
	ALUop,		// Outputs
	PCincr,
	Aload,
	Bload,
	Asel,
	RAMwrite
  );

  parameter ADDR_WIDTH= 12;
  parameter ROM_DEPTH= 1 << ADDR_WIDTH;


  input  [7:0]  PC;
  input  [3:0]  NZVC;
  output [2:0]  ALUop;
  output 	PCincr;
  output      	Aload;
  output 	Bload;
  output 	Asel;
  output 	RAMwrite;

  // All the input ports should be wires   
  wire [7:0] PC;
  wire [3:0] NZVC;

  wire [2:0] ALUop;
  wire 	     PCincr;
  wire 	     Aload;
  wire 	     Bload;
  wire 	     Asel;
  wire 	     RAMwrite;

  // ROM unit
  reg [7:0] ROM [0:ROM_DEPTH-1];

  // Internal wiring
  wire [ADDR_WIDTH-1:0] rom_in;
  wire [7:0]  	        rom_out;

  // Wire up the ROM's input and output
  assign rom_in[7:0]  = PC;
  assign rom_in[11:8] = NZVC;
  assign rom_out= ROM[rom_in];

  assign ALUop=    rom_out[2:0];
  assign PCincr=   rom_out[3];
  assign Aload=    rom_out[4];
  assign Bload=    rom_out[5];
  assign Asel=     rom_out[6];
  assign RAMwrite= rom_out[7];

  initial begin
    $readmemh("toprom.rom", ROM);
  end

endmodule
