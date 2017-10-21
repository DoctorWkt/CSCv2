// Top ROM
// (c) 2017 Warren Toomey, GPL3
module toprom (
	PC,		// PC's value
	NZVC,		// Flags value
	enable,		// Enable, active low
	ALUop,		// Outputs
	PCincr,
	Aload,
	Bload,
	Asel,
	RAMwrite
);

input  [7:0] PC;
input  [3:0] NZVC;
input 	     enable;
output [2:0] ALUop;
output 	     PCincr;
output 	     Aload;
output 	     Bload;
output 	     Asel;
output 	     RAMwrite;

// All the input ports should be wires   
wire [7:0] PC;
wire [3:0] NZVC;
wire enable;

wire [2:0] ALUop;
wire 	   PCincr;
wire 	   Aload;
wire 	   Bload;
wire 	   Asel;
wire 	   RAMwrite;

// ROM that performs the ALU operations
reg [7:0] ROM [0:4095];

// Internal wiring
wire [11:0] rom_in;
wire [7:0]  rom_out;

// Wire up the ROM's input and output
assign rom_in[7:0]  = PC;
assign rom_in[11:8] = NZVC;
assign rom_out= ROM[rom_in];

// Output only when enable is low
assign ALUop=    (enable) ? 3'bz : rom_out[2:0];
assign PCincr=   (enable) ? 1'bz : rom_out[3];
assign Aload=    (enable) ? 1'bz : rom_out[4];
assign Bload=    (enable) ? 1'bz : rom_out[5];
assign Asel=     (enable) ? 1'bz : rom_out[6];
assign RAMwrite= (enable) ? 1'bz : rom_out[7];

initial begin
  $readmemh("toprom.rom", ROM);
end

endmodule
