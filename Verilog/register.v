// 4-bit register
// (c) 2017 Warren Toomey, GPL3

module register (
	input clk,		// Clock input
	input reset,		// Reset line
	input load,		// Load line (active low)
	input  [3:0] data,	// Input data
	output [3:0] result	// Register output
  );

  // Result is a register, obviously
  reg [3:0] internal_result;
  assign result= internal_result;

  always @(posedge clk) begin
    if (reset)
      internal_result <= 0;
    else
      if (load==0)
        internal_result <= data;
  end

endmodule
