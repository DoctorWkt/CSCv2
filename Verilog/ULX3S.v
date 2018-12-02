// Top-Level Verilog Module
// Only include pins the design is actually using.  Make sure that the pin is
// given the correct direction: input vs. output vs. inout
`include "cscv2.v"
`include "txuart.v"

`ifdef VERILATOR

module ULX3S(i_clk, o_setup, o_uart_tx);
  input wire i_clk;
  output wire [31:0] o_setup; // Tell UART co-sim about clocks per baud
  output wire o_uart_tx;    // UART transmit signal line

`else

module ULX3S (input clk_25mhz, output ftdi_rxd, output [7:0] led);
  wire i_clk;
  assign i_clk= clk_25mhz;
  assign ftdi_rxd= o_uart_tx;   // Wire it up to real ULX3S line
  assign led= PCval;
`endif

  // The 25MHz clock is used to increment a counter.
  // We tap one of the bits to provide a lower frequency
  // clock, csc_clk. Internally the csc_clk is used for the
  // RAM component and the CPU itself runs at half this clock.
  reg [15:0] counter=0;
  always @(posedge i_clk) counter <= counter + 1;
  wire	     csc_clk;
  assign     csc_clk= counter[12];

/* verilator lint_off UNUSED */
  // CPU wires: not all used
  wire       TX;
  wire [3:0] Aval;
  wire [3:0] Bval;
  wire [7:0] PCval;
  wire       RAMwrite;
  wire [7:0] address;
  wire [3:0] Flagsval;
  wire [2:0] ALUop;
  wire [3:0] ALUresult;
  wire [3:0] RAMresult;
  wire [3:0] databus;
  wire       Aload;
  wire       Bload;
  wire       Asel;
/* verilator lint_on UNUSED */

  // CPU
  cscv2 CPU(csc_clk, TX, Aval, Bval, PCval, RAMwrite,
            address, Flagsval, ALUop, ALUresult, RAMresult,
            databus, Aload, Bload, Asel);

  // UART input and output
  wire [7:0] tx_data;
  assign     tx_data[7:4]= Aval;
  assign     tx_data[3:0]= Bval;
  wire       o_uart_tx;
  /* verilator lint_off UNUSED */
  wire       tx_busy;			// Unused
  /* verilator lint_on UNUSED */


  // The TX line goes low, but it stays low for many 25MHz clock
  // cycles as the CPU is running at a lower clock rate. We need
  // tx_stb to go high for one clock cycle only.
  reg  oldTX= 1;
  reg tx_stb= 0;
  always @(posedge i_clk) begin
    // Strobe tx_stb only when TX drops, on one 25MHz cycle only
    if ((TX==0) && (oldTX==1))
      tx_stb <= 1;
    else
      tx_stb <= 0;

    // Save TX for the next cycle
    oldTX <= TX;
  end

  // UART
  parameter   CLOCK_RATE_HZ = 25_000_000;	// 25MHz clock
  parameter       BAUD_RATE =      9_600;	// 9600 baud
  parameter CLOCKS_PER_BAUD = CLOCK_RATE_HZ/BAUD_RATE;
`ifdef VERILATOR
  assign o_setup = CLOCKS_PER_BAUD;
`endif
  txuart #(CLOCKS_PER_BAUD[23:0])
              transmitter(i_clk, tx_stb, tx_data, o_uart_tx, tx_busy);
endmodule
