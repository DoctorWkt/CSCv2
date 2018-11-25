// 4-bit register
// (c) 2017 Warren Toomey, GPL3

module register (
	input clk,		// Clock input
	input load,		// Load line (active low)
	input  [3:0] data,	// Input data
	output [3:0] result	// Register output
  );

  // Result is a register, obviously
  reg [3:0] internal_result=0;
  assign result= internal_result;

  always @(posedge clk) begin
      if (load==0)
        internal_result <= data;
  end

endmodule
