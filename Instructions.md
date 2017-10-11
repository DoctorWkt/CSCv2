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

As there is no *HALT* instruction, you should end your programs with
an infinite loop, e.g.

```
end:	JMP	end
```

The *csim* simulator recognises a jump to the current program counter
value and exits the simulation.

## ALU Flags

Any ALU operation that is written to RAM sets the value of the
Flags register. This has four bits:

  * N: set if the ALU result is negative
  * Z: set if the ALU result is zero
  * V: set if there was an overflow
  * Z: set if there was a carry

All ALU operations may set the negative (N) and zero (Z) flags.
The the overflow (V) flag is set when the signed A and B 
values have one sign (positive or negative) and the result
has a different sign. Note that the BCD operations do not
set the overflow (V) flag.

The carry (C) flag is set when the result does not fit into four
bits. ALU operations that may set the carry (C) flag are:

  * addition, subtraction and multiplication of any type
  * incrementing A's value

Finally, the TBF instruction sets the four NZVC flag bits to
be the value of the B register.

The Flags register retains its value until it is overwritten.
The conditional jump instructions can be used to jump to an
instruction location based on the various combinations of the
Flags register.


## 2-Dimensional Instructions

At each instruction location, there can be up to sixteen instructions.
Each one is chosen based on the sixteen possible combinations of
NZVC bits in the Flags register.

The conditional jump instructions automatically fill these sixteen
positions with JMP or NOP instructions to obtain the desired behaviour.
For example, if you write the instruction

```
	JCS	endloop		# End loop when carry is set
```

then eight of the positions at this location will be set to JMP
instructions, for the positions that indicate a set carry (C) flag.
The other eight positions will be filled with NOP instructions.

The assembler gives the program manual control over this choice as
well. At each instruction location, you can define which instructions
to insert for one, many or all sixteen of the NZVC Flags combinations.

Each line can contain multiple instructions. Each instruction can be
preceded by a four letter keyword that indicates the Flags combination
that applies to this instruction.

The keyword is the regular expression [Nnx][Zzx][Vvx][Ccx]. Uppercase
letters require that flag to be set. Lowercase letters require that
flag to be clear. Letter 'x' indicates that the flag can be any value.

If the line starts with an instruction with no flags keyword, then this
instruction is filled in at all sixteen positions. Further instructions
can then replace this original instruction.

An example of this is the manual definition of the JCS instruction:

```
	NOP 	| xxxC JMP endloop	# End loop when carry is set
```

(more soon)
