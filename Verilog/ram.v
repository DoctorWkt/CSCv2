// This uses the iCE40 Block RAM, but has an output
// reg so there's a 1-clock delay on output. To get
// it to work with CSCv2, the clock here is twice
// the frequency of the main CSCv2 clock.
//
// Code borrowed from Clifford Wolf on reddit, then
// modified by Warren Toomey.
module ram (
  input      clk,
  input      [7:0] addr,
  input      [3:0] wdata,
  output reg [3:0] rdata,
  input      we
  );

  // 256 4-bit words
  reg [3:0] mem [0:255];

  // Update a location on active low
  // write enable. Always output data
  // from that address.
  always @(posedge clk) begin
    if (!we)
      mem[addr] <= wdata;
    rdata <= mem[addr];
  end
endmodule
