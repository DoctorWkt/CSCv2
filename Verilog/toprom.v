// Top ROM
// (c) 2017 Warren Toomey, GPL3

module toprom (
  	input  [7:0] PC,	// PC's value
  	input  [3:0] NZVC,	// Flags value
  	output [2:0] ALUop,	// Outputs
  	output 	     PCincr,
  	output       Aload,
  	output 	     Bload,
  	output 	     Asel,
  	output 	     RAMwrite
  );

  parameter ADDR_WIDTH= 12;
  parameter ROM_DEPTH= 1 << ADDR_WIDTH;

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
