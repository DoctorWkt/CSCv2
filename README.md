# Crazy Small CPU, version 2

This repository holds the files associated with Warren's crazy small
breadboard CPU built with only eleven chips. For more details on the design of
the CPU itself, see the
[Crazy Small CPU website.](http://minnie.tuhs.org/Programs/CrazySmallCPU)

The files are:
 * _crazycpu.circ_, a version of the CPU that runs in Logisim
 * _Schematic.pdf_, a PDF version of the CPU's breadboard design done in Kicad
 * _cas_, the assembler for the CPU
 * _clc_, a very crude compiler that outputs assembly that can be given to _cas_
 * _csim_, a simulator that can run assembled programs. This allows you to test programs without loading them into Logisim or burning ROMs
 * _gen_alu_, a program to generate the contents of the ALU ROM
 * _notes_, my journal and notes as I went through the design and implementation stages
 * _Makefile_, to help make some of the ROM files. _make all_ will build the ALU ROM contents, assemble _fibminsky.s_ and produce the top and bottom control ROM images

Some example programs in the _Examples_ directory include:

 * _fibminsky.s_, a program that calculates Fibonacci numbers and then draws a sine wave using Minsky's circle algorithm.
 * _genfibn_, a Perl program that generates the assembly code for the Fibonacci program. You tell it what size Fibonacci number to generate, up to 24 digits.
 * _minsky.cl_. This is a reimplementation of the Minsky's circle algorithm program in the high-level language, just to test the compiler. Use the Makefile to build _minsky_, then run _csim_ by hand.
 * _bubblesort.s_, sort an array of numbers with Bubblesort.
 * _circle.s_, draw a circle using Minsky's circle algorithm and VT100 escape sequences.
 * _decimal.s_, print out numbers in decimal.
 * _enumttt.s_, enumerate winning tic-tac-toe boards.
 * _firstfunction.s_, an example of function calls and returns.
 * _genascii.s_, generate all the printable ASCII characters.
 * _hanoi.s_, perform the Towers of Hanoi algorithm.
 * _hexbench2.s_, a CPU speed testing program.
 * _mel.s_, print two stanzas of "Mel the Programmer".
 * _printdecs.s_, print out numbers in decimal.
 * _printhex.s_, print one number out in hexadecimal.
 * _printhexes.s_, print numbers out in hexadecimal.
 * _stack.s_, an example of a stack and its operations.

The _Verilog_ directory holds an implementation of the CPU in Icarus Verilog. A description of the CPU's instruction
set can be found in _Instructions.md_. A description of the _cas_ assembler and the _csim_ simulator can be found
in _Usage.md_.
 
 If you want to leave any comments, feel free to use the [GitHub issues page](https://github.com/DoctorWkt/CrazySmallCPU/issues) for this purpose.
