module alu (
        input [3:0] A,          // First operand
        input [3:0] B,          // Second operand
        input [2:0] ALUop,      // ALU operation
        input Cin,              // Carry in
        input ALUbank,          // Which operation bank in use
        output [3:0] result,    // ALU result
        output [3:0] flags      // NZVC flags
  );

  parameter ADDR_WIDTH= 13;
  parameter ROM_DEPTH= 1 << ADDR_WIDTH;

  // ROM unit
  reg [7:0] ROM [0:ROM_DEPTH-1];

  // Internal wiring
  wire [ADDR_WIDTH-1:0] rom_in;
  wire [7:0]  	        rom_out;

  // Wire up the ROM's input and output
  assign rom_in= {ALUbank, Cin, ALUop, A, B};
  assign rom_out= ROM[rom_in];
  assign result= rom_out[7:4];
  assign flags= rom_out[3:0];

  initial begin
    $readmemh("alu.rom", ROM);
  end

endmodule
