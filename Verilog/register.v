// 4-bit register
// (c) 2017 Warren Toomey, GPL3
module register (
	clk,		// Clock input
	load,		// Load line (active low)
	data,		// Input data
	result		// Register output
  );

  input		clk;
  input		load;
  input  [3:0] 	data;
  output [3:0] 	result;

  // All the input ports should be wires   
  wire clk;
  wire load;
  wire [3:0] data;

  // Output is a register, obviously
  reg [3:0] result;
  initial result = 0;

  always @(posedge clk) begin
    if (load==0)
      result <= data;
  end

endmodule
