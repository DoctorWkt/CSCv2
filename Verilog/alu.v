// 4-bit ALU implemented with a ROM
// (c) 2017 Warren Toomey, GPL3

module alu (
	A,		// First operand
	B,		// Second operand
	ALUop,		// ALU operation
	Cin,		// Carry in
	enable,		// Enable, active low
	ALUbank,	// Which operation bank in use
	result,		// ALU result
	flags		// NZVC flags
  );

  parameter ADDR_WIDTH= 13;
  parameter ROM_DEPTH= 1 << ADDR_WIDTH;

  input  [3:0] 	A;
  input  [3:0] 	B;
  input  [2:0]  ALUop;
  input		Cin;
  input 	enable;
  input 	ALUbank;
  output [3:0]  result;
  output [3:0]  flags;
  
  // All the input ports should be wires   
  wire [3:0] A;
  wire [3:0] B;
  wire [2:0] ALUop;
  wire Cin;
  wire enable;
  wire ALUbank;

  wire [3:0] result;
  wire [3:0] flags;

  // ROM that performs the ALU operations
  reg [7:0] ROM [0:ROM_DEPTH-1];

  // Internal wiring
  wire [ADDR_WIDTH-1:0] rom_in;
  wire [7:0]  rom_out;

  // Wire up the ROM's input and output
  assign rom_in[3:0] = B;
  assign rom_in[7:4] = A;
  assign rom_in[10:8] = ALUop;
  assign rom_in[11] = Cin;
  assign rom_in[12] = ALUbank;
  assign rom_out= ROM[rom_in];

  // Output only when enable is low
  assign flags=  (enable) ? 4'bz : rom_out[3:0];
  assign result= (enable) ? 4'bz : rom_out[7:4];

  initial begin
    $readmemh("alu.rom", ROM);
  end

endmodule
