# Instructions in the Crazy Small CPU Version 2

Here are the current instructions in CSC version 2.

## Operands

All instructions have an optional 8-bit operand which can be:
 
 * a decimal constant
 * an octal constant, starting with 0
 * a hex constant, starting with 0x
 * a label

If the operand is omitted, then 255 is the implicit
operand.

## Instructions

Some instructions use all eight bits of the operand,
shown as *addr* below. Some instructions use the lower
four bits of the operand, shown as *const* below.

The "Flags" column indicates if the value in the Flags
register is altered by the instruction. This also
indicates if the ALU result is written into RAM at the
explicit (or implicit) address operand.

| Mnemonic | Flags | Comment                                    |
|:--------:|:-----:|--------------------------------------------|
|   ADDMB  |   Y   |  Store A + B into RAM and also into B      |
|   ADDM   |   Y   |  Store A + B into RAM			|
|   ANDM   |   Y   |  Store A & B into RAM			|
|   CLC    |   Y   |  Clear carry flag, set zero flag		|
|   DAB    |       |  Display A and B, load A & B with constant	|
|   DADDM  |   Y   |  Store BCD A + B into RAM			|
|   DIVM   |   Y   |  Store A / B into RAM			|
|   DMAB   |       |  Display A and B, load A & B from memory	|
|   DSUBM  |   Y   |  Store BCD A - B into RAM			|
|   HMULM  |   Y   |  Store A * B (high nibble) into RAM	|
|   JCC    |       |  Jump if C clear				|
|   JCS    |       |  Jump if C set				|
|   JEQ    |       |  Jump if equal to zero			|
|   JGE    |       |  Jump if >= zero				|
|   JGT    |       |  Jump if greater than 0			|
|   JLE    |       |  Jump if <= zero				|
|   JLT    |       |  Jump if less than zero			|
|   JMP    |       |  Jump always				|
|   JNC    |       |  Jump if N clear				|
|   JNE    |       |  Jump if not equal to 0			|
|   JNS    |       |  Jump if N set				|
|   JVC    |       |  Jump if V clear				|
|   JVS    |       |  Jump if V set				|
|   JZC    |       |  Jump if Z clear				|
|   JZS    |       |  Jump if Z set				|
|   LCA    |       |  Load constant into A			|
|   LCB    |       |  Load constant into B			|
|   LMA    |       |  Load B from RAM				|
|   LMB    |       |  Load B from RAM				|
|   LMULM  |   Y   |  Store A * B (low nibble) into RAM		|
|   MODM   |   Y   |  Store A % B into RAM			|
|   NOP    |       |  No operation				|
|   ORM    |   Y   |  Store A OR B into RAM			|
|   SMA    |   Y   |  Store A into RAM				|
|   SMBA   |   Y   |  Store A into RAM and B			|
|   SMB    |   Y   |  Store B into RAM				|
|   SMIA   |   Y   |  Store A + 1 into RAM			|
|   SUBM   |   Y   |  Store A - B into RAM			|
|   TAB    |   Y   |  Transfer A to B				|
|   TBA    |   Y   |  Transfer B to B				|
|   TBF    |   Y   |  Copy B to flags				|
|   XORM   |   Y   |  Store A ^ B into RAM			|
|   ZEROM  |   Y   |  Store zero into RAM			|

## Assembler Comments

In the assembly input, a comment starts at a hash character (#)
and continues to the end of the line. All of this is ignored by the
assembler. Blank input lines are ignored by the assembler.

## Labels and The EQU Pseudo-op

The assembler provides labels to name:

  * constants
  * memory locations
  * jump destination points

To define a label with a value, write your label at the beginning
of the line, followed by a colon, then the EQU pseudo-op and the value.
Example:

```
num1:	EQU	34	# Store num1 in location 34
five:	EQU	five	# The constant 5
```

Later on in your program, you can write

```
	LCA	5	# Load 5 into A
	LCB	five	# Also load 5, into B
	SMB	num1	# Store B's value in num1
```

Any label which is defined without EQU gets the value of the
program counter at that point, and can be used as a jump destination point.
For example:

```
loop1:
loop2:	LCA	five
	. . .
	. . .
	JMP	loop2
	. . .
	JMP	loop1
```

## 2-Dimensional Instructions

To be written
