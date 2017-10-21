// Bottom ROM
// (c) 2017 Warren Toomey, GPL3

module botrom (
	PC,		// PC's value
	NZVC,		// Flags value
	address		// Output
  );

  input  [7:0] PC;
  input  [3:0] NZVC;
  output [7:0] address;

  parameter ADDR_WIDTH= 12;
  parameter ROM_DEPTH= 1 << ADDR_WIDTH;

  // All the input ports should be wires   
  wire [7:0] PC;
  wire [3:0] NZVC;

  wire [7:0] address;

  // ROM that performs the ALU operations
  reg [7:0] ROM [0:ROM_DEPTH-1];

  // Internal wiring
  wire [ADDR_WIDTH-1:0] rom_in;
  wire [7:0]  rom_out;

  // Wire up the ROM's input and output
  assign rom_in[7:0]  = PC;
  assign rom_in[11:8] = NZVC;
  assign rom_out= ROM[rom_in];

  assign address= rom_out[7:0];

  initial begin
    $readmemh("botrom.rom", ROM);
  end

endmodule
