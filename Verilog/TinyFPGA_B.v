// Top-Level Verilog Module
// Only include pins the design is actually using.  Make sure that the pin is
// given the correct direction: input vs. output vs. inout
`include "cscv2.v"
`include "txuart.v"

module TinyFPGA_B (
  //output pin1_usb_dp,
  //inout pin2_usb_dn,
  input pin3_clk_16mhz,
  //output pin4,
  //output pin5,
  //output pin6,
  //output pin7,
  //output pin8,
  //output pin9,
  //input  pin10,
  //output pin11,
  //output pin12,
  output pin13,
  //inout pin14_sdo,
  //inout pin15_sdi,
  //inout pin16_sck,
  //inout pin17_ss,
  //inout pin18,
  //inout pin19,
  //inout pin20,
  //inout pin21,
  //inout pin22,
  //inout pin23,
  //inout pin24
);

  // The 16MHz clock is used to increment a counter.
  // We tap one of the bits to provide a lower frequency
  // clock, csc_clk. Internally the csc_clk is used for the
  // RAM component and the CPU itself runs at half this clock.
  reg [15:0] counter=0;
  always @(posedge pin3_clk_16mhz) counter <= counter + 1;
  wire	     csc_clk;
  assign     csc_clk= counter[11];

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

  // CPU
  cscv2 CPU(csc_clk, TX, Aval, Bval, PCval, RAMwrite,
            address, Flagsval, ALUop, ALUresult, RAMresult,
            databus, Aload, Bload, Asel);

  // UART input and output
  wire [7:0] tx_data;
  assign     tx_data[7:4]= Aval;
  assign     tx_data[3:0]= Bval;
  wire       o_uart_tx;
  assign     pin13= o_uart_tx;
  wire       tx_busy;			// Unused

  // The TX line goes low, but it stays low for many 16MHz clock
  // cycles as the CPU is running at a lower clock rate. We need
  // tx_stb to go high for one clock cycle only.
  reg  oldTX= 1;
  reg tx_stb= 0;
  always @(posedge pin3_clk_16mhz) begin
    // Strobe tx_stb only when TX drops, on one 16MHz cycle only
    if ((TX==0) && (oldTX==1))
      tx_stb <= 1;
    else
      tx_stb <= 0;

    // Save TX for the next cycle
    oldTX <= TX;
  end

  // UART
  parameter       CLOCK_RATE_HZ = 16_000_000; // 16MHz clock
  parameter       BAUD_RATE = 115_200;        // 115.2 KBaud
  parameter       INITIAL_UART_SETUP = (CLOCK_RATE_HZ/BAUD_RATE);
  txuart #(INITIAL_UART_SETUP[23:0])
              transmitter(pin3_clk_16mhz, tx_stb, tx_data, o_uart_tx, tx_busy);
endmodule
