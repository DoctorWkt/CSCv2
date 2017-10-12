# Crazy Small CPU Version 2

This is version 2 of my Crazy Small CPU, and is a work in progress. For
a more stable version, please see the
[Crazy Small CPU website.](http://minnie.tuhs.org/Programs/CrazySmallCPU)

The only physical change from version 1 to version 2 is a wire that connects
Asel from the Flags register to A12, the most significant address line of
the ALU ROM. This doubles the number of ALU operations that the ALU can
perform. It also paves the way for the CPU to do function calls.
