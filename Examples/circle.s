# Drawing a circle using Minsky's circle algorithm.
# Thanks to Chris Baird for the suggestion.
# Requires a terminal that supports VT100 escape
# sequences.
# (c) 2017 Warren Toomey, GPL3

xhi:	EQU 0
xlo:	EQU 1
yhi:	EQU 2
ylo:	EQU 3
tmplo:	EQU 4
tmphi:	EQU 5
ihi:	EQU 6
ilo:	EQU 7
cntlo:  EQU 17
cnthi:  EQU 18
digit1:	EQU 19
digit2:	EQU 20
digit3:	EQU 21
caller: EQU 22

        ZEROM yhi	# Initialise the variables
        ZEROM ylo
        ZEROM cntlo
        ZEROM cnthi

	LCA 0x3		# Set x to decimal 48, 0x30
	SMA xhi
	ZEROM xlo	# y starts at zero

loop:	LMA xhi         # Store x>>4 into temp
        SMA tmplo
        LCA 0 | N LCA 0xf
        SMA tmphi

ok1:	CLC
	LMA ylo		# y= y - (x>>4), i.e. y= y - 1/16 * x
	LMB tmplo
	SUBM ylo
	LMA yhi
	LMB tmphi
	SUBM yhi

        LMA yhi         # Store y>>4 into temp
        SMA tmplo
        LCA 0 | N LCA 0xf
        SMA tmphi

ok2:	CLC
	LMA xlo		# x= x + (y>>4), i.e x= x + 1/16 * y
	LMB tmplo
	ADDM xlo
	LMA xhi
	LMB tmphi
	ADDM xhi

        LCA 0x1		# Print Escape
        LCB 0xB
        DAB
        LCA 0x5		# Print [
        LCB 0xB
        DAB

	CLC
	LCA 0x2		# Set i to x + 34, x + 0x22
	LMB xlo
	ADDM ilo
	LCA 0x2
	LMB xhi
	ADDM ihi

	LCA 0		# Print i in decimal
	JMP prdec

endcall1:
        LCA 0x3		# Print semicolon
        LCB 0xB
        DAB

	CLC
	LCA 0x2		# Set i to y + 34, y + 0x22
	LMB ylo
	ADDM ilo
	LCA 0x2
	LMB yhi
	ADDM ihi

	LCA 1		# Print i in decimal
	JMP prdec

endcall2:
        LCA 0x4		# Print H
        LCB 0x8
        DAB
        LCA 0x2		# Print asterisk
        LCB 0xA
        DAB

	LMA cntlo
	SMIA cntlo
	JCC loop	# Loop back 256 times
	LMA cnthi
	SMIA cnthi
	JCC loop	# Loop back 256 times

end:    JMP end


# Function to print iho/ilo out in decimal
#
prdec:
	SMA caller	# Save caller id
        LMB     ihi	# Get the top-most digit
        TBF
        LCA 0 | LCA 0 | LCA 0 | LCA 0 | LCA 0 | \
		LCA 0 | JMP dec96 | LCA 1 | LCA 1 | \
		LCA 1 | LCA 1 | LCA 1 | JMP dec192 | \
		LCA 2 | LCA 2 | LCA 2
        SMA digit1

        		# Get some of the second digit
        TBF
        LCA 0 | LCA 1 | LCA 3 | LCA 4 | LCA 6 | \
		LCA 8 | LCA 9 | LCA 1 | LCA 2 | \
		LCA 4 | LCA 6 | LCA 7 | LCA 9 | \
		LCA 0 | LCA 2 | LCA 4
        SMA digit2

        		# Get the leftover from the high nibble
        TBF
        LCA 0 | LCA 6 | LCA 2 | LCA 8 | LCA 4 | \
		LCA 0 | LCA 6 | LCA 2 | LCA 8 | \
		LCA 4 | LCA 0 | LCA 6 | LCA 2 | \
		LCA 8 | LCA 4 | LCA 0

	CLC		# Add the low nibble to the leftover from the high nibble
        LMB ilo
        ADDMB

	JCS caryon	# We have a result 16 to 24, deal with that
			# We have a result 0 to 15
	TBF
			# Save the correct decimal digit into digit3
	SMB digit3 | NzVc LCA 0 | NzVC LCA 1 | NZvc LCA 2 | NZvC LCA 3 | \
		NZVc LCA 4 | NZVC LCA 5
	TBF
	JMP printi | NzVc SMA digit3 | NzVC SMA digit3 | NZvc SMA digit3 | \
		NZvC SMA digit3 | NZVc SMA digit3 | NZVC SMA digit3
	LMA digit2	# Increment digit2 if required
	SMIA digit2
	JMP printi

caryon:			# We have a result 16 to 24, deal with that
			# Save the correct decimal digit into digit3
	TBF
	LCA 6 | LCA 7 | LCA 8 | LCA 9 | LCA 0 | \
		LCA 1 | LCA 2 | LCA 3 | LCA 4
	SMA digit3
			# Work out what to add to digit2
	TBF
	LCB 1 | LCB 1 | LCB 1 | LCB 1 | LCB 2 | \
		LCB 2 | LCB 2 | LCB 2 | LCB 2
	LMA digit2
	CLC
	ADDM digit2
	JMP printi

		# We get here because the top nibble has the decimal value
		# 96 or 192, so the bottom nibble can affect all three
		# decimal digits
dec96:	LMB ilo
	TBF
        LCA 1 | LCA 0 | LCA 0 | LCA 0 | LCA 0
        SMA digit1
	TBF
        LCA 0 | LCA 9 | LCA 9 | LCA 9 | LCA 9 | \
		NZVc LCA 1 | NZVC LCA 1
        SMA digit2
	TBF
        LCA 6 | LCA 7 | LCA 8 | LCA 9 | LCA 0 | \
		LCA 1 | LCA 2 | LCA 3 | LCA 4 | \
		LCA 5 | LCA 6 | LCA 7 | LCA 8 | \
		LCA 9 | LCA 0 | LCA 1
        SMA digit3
	JMP printi

dec192: LMB ilo
	TBF
        LCA 1 | N LCA 2
        SMA digit1
	TBF
        LCA 9 | N LCA 0
        SMA digit2
	TBF
        LCA 2 | LCA 3 | LCA 4 | LCA 5 | LCA 6 | \
		LCA 7 | LCA 8 | LCA 9 | LCA 0 | \
		LCA 1 | LCA 2 | LCA 3 | LCA 4 | \
		LCA 5 | LCA 6 | LCA 7
        SMA digit3

printi:	LCA	3		# Print out the three digits
	LMB	digit1
	DAB	3
	LMB	digit2
	DAB	3
	LMB	digit3
	DMAB	caller
	TBF
	nzvc JMP endcall1 | nzvC JMP endcall2
