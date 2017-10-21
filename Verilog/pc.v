// 8-bit PC
// (c) 2017 Warren Toomey, GPL3
module pc (
	clk,		// Clock input
	PCincr,		// Increment PC
	data,		// Input data
	result		// PC output
  );

  input		clk;
  input		PCincr;
  input  [7:0] 	data;
  output [7:0] 	result;

  // All the input ports should be wires   
  wire clk;
  wire PCincr;
  wire [7:0] data;

  // Output
  reg [7:0] result;
  initial result = 0;

  always @(posedge clk) begin
    if (!PCincr)
      result <= data;
    else
      result <= result + 1;
  end

endmodule
