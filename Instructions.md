# Instructions in the Crazy Small CPU Version 2

Here are the details of the input format accepted
by the *cas* assembler, and the instructions available
in the Crazy Small CPU version 2.

## Running the *cas* Assembler

Assuming that you have an input file called _myprog.s_, you
can assemble this by running the command:

```
./cas myprog.s
```

This will produce the ROM files:
 * botrom.rom and toprom.rom, used by Logisim and the *csim* simulator
 * botrom.img and toprom.img, to be burned to real EEPROMs

## Operands

All instructions have an optional 8-bit operand which can be:
 
 * a decimal constant
 * an octal constant, starting with 0
 * a hex constant, starting with 0x
 * a label

If the operand is omitted, then 255 is the implicit
operand. Operand values range from 0 to 255 decimal.

## Instructions

Some instructions use all eight bits of the operand,
shown as *addr* below. Some instructions use the lower
four bits of the operand, shown as *const* below.

The "Flags" column indicates if the value in the Flags
register is altered by the instruction. This also
indicates if the ALU result is written into RAM at the
explicit (or implicit) address operand.

|  Mnemonic  | Flags | Comment                                    |
|:----------:|:-----:|--------------------------------------------|
| ADDMB addr |   Y   |  Store A + B into RAM and also into B      |
| ADDM addr  |   Y   |  Store A + B into RAM			  |
| ANDM addr  |   Y   |  Store A & B into RAM			  |
| CLC        |   Y   |  Clear carry flag, set zero flag		  |
| DAB const  |       |  Display A and B, load A & B with constant |
| DADDM addr |   Y   |  Store BCD A + B into RAM		  |
| DIVM addr  |   Y   |  Store A / B into RAM			  |
| DMAB addr  |       |  Display A and B, load A & B from RAM	  |
| DSUBM addr |   Y   |  Store BCD A - B into RAM		  |
| HMULM addr |   Y   |  Store A * B (high nibble) into RAM	  |
| JCC addr   |       |  Jump if C clear				  |
| JCS addr   |       |  Jump if C set				  |
| JEQ addr   |       |  Jump if equal to zero			  |
| JGE addr   |       |  Jump if >= zero				  |
| JGT addr   |       |  Jump if greater than 0			  |
| JLE addr   |       |  Jump if <= zero				  |
| JLT addr   |       |  Jump if less than zero			  |
| JMP addr   |       |  Jump always				  |
| JNC addr   |       |  Jump if N clear				  |
| JNE addr   |       |  Jump if not equal to 0			  |
| JNS addr   |       |  Jump if N set				  |
| JVC addr   |       |  Jump if V clear				  |
| JVS addr   |       |  Jump if V set				  |
| JZC addr   |       |  Jump if Z clear				  |
| JZS addr   |       |  Jump if Z set				  |
| LCA const  |       |  Load constant into A			  |
| LCB const  |       |  Load constant into B			  |
| LMA addr   |       |  Load A from RAM				  |
| LMB addr   |       |  Load B from RAM				  |
| LMULM addr |   Y   |  Store A * B (low nibble) into RAM	  |
| MODM addr  |   Y   |  Store A % B into RAM			  |
| NOP        |       |  No operation				  |
| ORM addr   |   Y   |  Store A OR B into RAM			  |
| SMA addr   |   Y   |  Store A into RAM			  |
| SMBA addr  |   Y   |  Store A into RAM and B			  |
| SMB addr   |   Y   |  Store B into RAM			  |
| SMIA addr  |   Y   |  Store A + 1 into RAM			  |
| SUBM addr  |   Y   |  Store A - B into RAM			  |
| TAB        |   Y   |  Transfer A to B				  |
| TBA        |   Y   |  Transfer B to A				  |
| TBF        |   Y   |  Transfer B to flags			  |
| XORM addr  |   Y   |  Store A ^ B into RAM			  |
| ZEROM addr |   Y   |  Store zero into RAM			  |

## Assembler Comments

In the assembly input, a comment starts at a hash character (#)
and continues to the end of the line. All of this is ignored by the
*cas* assembler. Blank input lines are ignored by the assembler. The
assembler supports backslash '\\' characters to continue a single
line over multiple lines.

## Labels and The EQU Pseudo-op

The *cas* assembler provides labels for you to name:

  * constants
  * RAM locations
  * jump destination points

To associate a label with a value, write your label at the beginning
of the line, followed by a colon, then the EQU pseudo-op and the value.
Example:

```
num1:	EQU	34	# Associate num1 as location 34
five:	EQU	5	# Associate five as the constant 5
```

Later on in your program, you can write

```
	LCA	5	# Load 5 into A
	LCB	five	# Also load 5, into B
	SMB	num1	# Store B's value in location num1
```

Any label which is defined without an EQU gets the value of the
program counter at that point and can be used as a jump destination point.
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

As there is no HALT instruction, you should end your programs with
an infinite loop, e.g.

```
end:	JMP	end
```

The *csim* simulator recognises a jump to the current program counter
value and exits the simulation.

## ALU Flags

Any ALU operation that is written to RAM sets the value of the
Flags register. This register holds four bits:

  * N: set if the ALU result is negative
  * Z: set if the ALU result is zero
  * V: set if there was an overflow
  * C: set if there was a carry

4-bit binary nibble values are treated as signed values in the range
-8 to +7 decimal. All ALU operations may set the negative (N)
and zero (Z) flags. The overflow (V) flag is set when
the signed A and B values have one sign (positive or negative)
and the result has a different sign.

4-bit BCD nibble values are treated as unsigned values in the range
0 to 9 decimal.  The BCD operations do not set the negative (N) or
overflow (V) flag. If you try to do a BCD operation when one or the
inputs is out of the 0 to 9 range, the result is zero.

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
instructions for the positions that indicate a set carry (C) flag.
The other eight positions will be filled with NOP instructions.

The assembler gives the programmer explict control over this choice as
well. At each instruction location, you can define which instructions
to insert for one, many or all sixteen of the NZVC Flags combinations.

Each assembly line can contain multiple instructions. Instructions are
separated by a vertical bar. By default, the first instruction on the
line is placed into all sixteen instruction positions.

Other instructions are placed in increasing positions, up to the sixteenth
position. For example, the instruction line:

```
	LCA 0 | LCB 1 | JMP 3 | ADDM 8
```

stores the `LCA 0` instruction into all sixteen positions, and then
overwrites position 1 with `LCB 1`, position 2 with `JMP 3` and
position 3 with `ADDM 8`.

You can also prefix an instruction with a word which is a combination
of the `NZVCnzvc` letters. Uppercase letters require that flag to be set.
Lowercase letters require that flag to be clear. If this 'flags' word
appears, then the instruction is placed in those positions that correspond
to the set (or cleared) flags.

Here is a full example. Consider the instruction line:

```
	LCA 2 | Nz LCA 3 | LCA 4
```

The *cas* assembler will place the instructions in these sixteen positions:

|  Position  | Flags | Instruction        |
|:----------:|:-----:|--------------------|
|    0       |  nzvc | LCA 2 (default)    |
|    1       |  nzvC | LCA 2 (default)    |
|    2       |  nzVc | LCA 4 (position 2) |
|    3       |  nzVC | LCA 2 (default)    |
|    4       |  nZvc | LCA 2 (default)    |
|    5       |  nZvC | LCA 2 (default)    |
|    6       |  nZVc | LCA 2 (default)    |
|    7       |  nZVC | LCA 2 (default)    |
|    8       |  Nzvc | LCA 3 (Nz)         |
|    9       |  NzvC | LCA 3 (Nz)         |
|   10       |  NzVc | LCA 3 (Nz)         |
|   11       |  NzVC | LCA 3 (Nz)         |
|   12       |  NZvc | LCA 2 (default)    |
|   13       |  NZvC | LCA 2 (default)    |
|   14       |  NZVc | LCA 2 (default)    |
|   15       |  NZVC | LCA 2 (default)    |


Here is an example of manually choosing the instructions to perform
based on the Flags values. We want to print the 4-bit nibble at RAM
location 10 out as an ASCII character, i.e. '0' .. '9' or 'A' .. 'F'.
This requires the code to map nibble values 0x0 .. 0x9 to the ASCII values
0x30 to 0x39, and the nibble values 0xa to 0xf to the ASCII values
0x41 to 0x46.

I've numbered each line, and each line is described after the code.

```
1.	 CLC				# Clear carry before the add
2.       LCA  7
3.       LMB  10
4.       ADDMB                           # B=B+7, flags set
5.       LMB  10 | zC NOP                # Reload the digit if 0-9
6.       LCA  3  | zC LCA  4
7.       DAB
```

1. Clear the carry so the ADDMB won't be affected by a carry in.

2. Load constant 7 into A. Why 7? Read on.

3. Load the nibble to print from location 10.

4. Add 7 to this nibble and store the result back in B. If the nibble was
   0xa (10), then this becomes 17, except that this won't fit in the B
   register, so it becomes 0x1: the low nibble of ASCII 'A' (0x41).
   This will have set the carry (C) flag: in fact, any nibble value from
   9 up to 15 will set the carry flag.

   That's a problem though, as we don't want to convert the nibble value
   9 into an uppercase character. Luckily, 9 + 7 = 16, which sets the
   carry flag but also turns into 0 and sets the zero (Z) flag.

   So, nibble values 10 and upwards, when added to 7, set the carry flag.
   Value 9 also does this, but it sets the zero flag as well.

5. If the carry flag is set but not the zero flag (*C*), do nothing.
   We keep B+7 in the B register. For all other flag combinations, reload
   the original nibble value into the B register.

   At this point, we either have flags *zC* and B+7 in the B register
   because the nibble value was 10 .. 15, or we have the original nibble
   value in the B register because the nibble value was 0 .. 9.

6. For nibble values 10 and upwards (*zC*), set A to 0x4: we now have
   the correct ASCII character 'A' .. 'F' in the A/B registers.
   For all other nibble values, set A to 0x3: we now have the correct
   ASCII digits '0' .. '9' in the A/B registers.

7. Print out the ASCII character in the A/B registers to the UART.

## Function Calls

Even though the CPU architecture is Harvard style, there is a way to 
perform function calls as long as there are only sixteen callers or less to
the function.

It works as follows. Each function caller loads a "caller id" into either
the A or B register before jumping to the function. The function saves the
caller id. Just before the end of the function, the function loads the
stored caller id into the Flags register with an instruction sequence
ending with a TBF instruction.

The Flags register now holds one of the sixteen caller ids. We can now use
a 2-dimensional instruction to jump back to the instruction following the
original function call. Here is an example of two function calls followed
by the function itself.

```
caller:	EQU 0		# Id of the function caller

# Print digit 2 and newline
	LCA 0		# Caller id
	LCB 2
	JMP printdigit
enddigit2:

# Print digit 4 and newline
	LCA 1		# Caller id
	LCB 4
	JMP printdigit
enddigit4:

	. . .

# Function to print a digit followed by a newline
printdigit: SMA caller	# Save caller id
	LCA 3
	DAB 0		# Print the digit, load 0 into A
	LCB 10
	DMAB caller	# Print newline, get caller id
	TBF		# Transfer caller to flags
			# Jump based on flags value
	JMP enddigit2 | JMP enddigit4
```
