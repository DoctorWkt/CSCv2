// Design Name : ram_sp_sr_sw
// File Name   : ram_sp_sr_sw.v
// Function    : Synchronous read write RAM 
// Coder       : Deepak Kumar Tala
// Modified by : Warren Toomey

module ram (
    clk,	// Clock Input
    address,	// Address Input
    data,	// Data bi-directional
    we		// Write enable, active low
  ); 

  parameter DATA_WIDTH= 4 ;
  parameter ADDR_WIDTH= 8 ;
  parameter RAM_DEPTH= 1 << ADDR_WIDTH;

  // Input Ports
  input                  clk;
  input [ADDR_WIDTH-1:0] address;
  input                  we;
  wire                   clk;
  wire [ADDR_WIDTH-1:0]  address;
  wire                   we;

  // Inout Ports
  inout [DATA_WIDTH-1:0]  data;
  wire  [DATA_WIDTH-1:0]  data;

  // Internal variables
  reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

  // Tri-State Buffer control 
  // output : When we == 1
  assign data= (we) ? mem[address] : 4'bz; 

  // Memory Write Block 
  // Write Operation : When we == 0
  always @ (posedge clk)
  begin : MEM_WRITE
    if ( !we ) begin
      mem[address]= data;
      // $display("Wrote %h to addr %h", data, address);
    end
  end

endmodule
