# Verilog Version of Crazy Small CPU Version 2

This directory contains an implementation of the CSCv2 CPU in Verilog,
which can both be simulated and synthesised on to an FPGA. There are
three make files: Makefile, VerMakefile and YoMakefile.

## Icarus Verilog

If you have Icarus Verilog and you have assembled ```alu.rom```,
```botrom.rom``` and ```toprom.rom``` files in the parent directory,
you can do:

```
make
```

to compile the Verilog sources here and run the CPU with these ROM images.
This will also produce a ```test.vcd``` waveform output file. You can also
```make clean``` to remove the output files, and ```make realclean``` to
do the same but also to remove the copies of the ROM images in this directory.

## Verilator

If you have Verilator installed, you can simulate the CPU with this tool.
Once you have assembled ```alu.rom```, ```botrom.rom``` and ```toprom.rom```
files in the parent directory, you can do:

```
make -f VerMakefile
```

to compile the Verilog sources here with Verilator and run the CPU with these
ROM images. You can also ```make -f VerMakefile clean``` to remove the output
files.

## IceStorm and TinyFPGA B2

If you have a [TinyFPGA B2](https://store.tinyfpga.com/products/tinyfpga-b2)
and the [IceStorm toolchain](http://www.clifford.at/icestorm/) installed,
you can synthesize a bitstream to program onto this device.
Once you have assembled ```alu.rom```, ```botrom.rom``` and ```toprom.rom```
files in the parent directory, you can do:

```
make -f YoMakefile
```

to compile the Verilog sources here with yosys and friends, and this will
produce the bitstream file ```TinyFPGA_B.bin```.
You can also ```make -f YoMakefile clean``` to remove the output files.

Pin 13 on the TinyFPGA B2 is the UART output from the board, running at
115,200 bps. You will need to wire this pin and the TinyFPGA ground pin
to a serial receiver, e.g. a USB to 3.3V TTL Converter USB Adapter Cable.

## Using the ULX3S FPGA Board

If you have a [ULX3S FPGA Board](http://radiona.org/new-fpga-board-ulx3s/)
and a recent (Dec 2018 or later)
[yosys/trellis/nextpnr toolchain](https://github.com/SymbiFlow/prjtrellis)
installed, 
you can synthesize a bitstream to program onto this device.
Once you have assembled ```alu.rom```, ```botrom.rom``` and ```toprom.rom```
files in the parent directory, you can do:

```
make -f ULMakefile
```

to compile the Verilog sources here with yosys and friends, and this will
produce the bitstream file ```ulx3s.bit```.
You can ```make -f ULMakefile clean``` to remove the output files.
You can ```make -f ULMakefile prog``` to program the board using the
_ujprog_ program.

Use a serial program like _minicom_ running at 9,600 bps and with no
hardware flow control to see the output from the CPU.

## Changes from the Chip Version of CSCv2

Firstly, the ```ram.v``` component waits a clock cycle before it
outputs when the address changes. So we give it a clock signal
twice the frequency of the main CPU clock signal.

The UART is now separate from the CPU, but we output the TX
control line which is still the OR of Aload, Bload and the clock.

Because the high impedance logic state doesn't get synthesised well,
there is a new multiplexer, databus. This chooses either the RAM
output or the ALU output based on the RAMwrite control line.

Apart from the above, everything else is exactly the same as the
CSCv2 version made from 7400-style chips.
