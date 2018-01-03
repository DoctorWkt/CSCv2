// Top-Level Verilog Module
// Only include pins the design is actually using.  Make sure that the pin is
// given the correct direction: input vs. output vs. inout
`include "cscv2.v"

module TinyFPGA_B (
  output pin1_usb_dp,
  //inout pin2_usb_dn,
  input pin3_clk_16mhz,
  output pin4,
  output pin5,
  output pin6,
  output pin7,
  output pin8,
  output pin9,
  input  pin10,
  output pin11,
  output pin12,
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

  // The 16MHz clock is used to increment this counter.
  // We tap one of the bits to provide a lower frequency
  // clock to the CPU. We tap the next highest bit to
  // get a half-speed clock for the UART.
  // Internally the csc_clk is used for the RAM component
  // and the CPU itself runs at half this clock.
  reg [23:0] counter;
  always @(posedge pin3_clk_16mhz) counter <= counter + 1;

  // CPU wires: not all used
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
  wire       Reset;
  wire	     csc_clk;
  assign     csc_clk= counter[13];

  // UART input
  wire [7:0] AB;
  wire       TX;        // UART control line
  assign AB[7:4]= Aval;
  assign AB[3:0]= Bval;

  /// Left side of board. Strange wiring to make it
  /// easier to wire up to the UM245R
  assign pin1_usb_dp= TX;
  assign pin4=        AB[3];
  assign pin5=        AB[6];
  assign pin6=        AB[5];
  assign pin7=        csc_clk;
  assign pin8=        AB[7];
  assign pin9=        AB[1];
  assign pin10=       Reset;
  assign pin11=       AB[2];
  assign pin12=       AB[4];
  assign pin13=       AB[0];

  /// right side of board
  //assign pin14_sdo= 1'bz;
  //assign pin15_sdi= 1'bz;
  //assign pin16_sck= 1'bz;
  //assign pin17_ss=  1'bz;
  //assign pin18=     1'bz;
  //assign pin19=     1'bz;
  //assign pin20=     1'bz;
  //assign pin21=     1'bz;
  //assign pin22=     1'bz;
  //assign pin23=     1'bz;
  //assign pin24=     1'bz;

  // Components
  cscv2 CPU(csc_clk, Reset, TX, Aval, Bval, PCval, RAMwrite,
            address, Flagsval, ALUop, ALUresult, RAMresult,
            databus, Aload, Bload, Asel);
endmodule
