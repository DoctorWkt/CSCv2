# Print out 000 to 255 in decimal
# (c) 2017 Warren Toomey, GPL3

xhi:	EQU  0
xlo:	EQU  1
digit1:	EQU  2
digit2:	EQU  3
digit3:	EQU  4

        ZEROM xhi			# Initialise the X nibbles
        ZEROM xlo
loop:

        # Get the top-most digit
        LMB     xhi
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
        # Add the low nibble to the leftover from the high nibble
	CLC
        LMB xlo
        ADDMB

	# We have a result 16 to 24, deal with that
	JCS caryon
	# We have a result 0 to 15
	TBF
	# Save the correct decimal digit into digit3
	SMB digit3 | NzVc LCA 0 | NzVC LCA 1 | NZvc LCA 2 | NZvC LCA 3 | \
		NZVc LCA 4 | NZVC LCA 5
	TBF
	JMP printx | NzVc SMA digit3 | NzVC SMA digit3 | NZvc SMA digit3 | \
		NZvC SMA digit3 | NZVc SMA digit3 | NZVC SMA digit3
	# Increment digit2 if required
	LMA digit2
	SMIA digit2
	JMP printx


caryon:	# We have a result 16 to 24, deal with that
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
	JMP printx

# We get here because the top nibble has the decimal value
# 96 or 192, so the bottom nibble can affect all three
# decimal digits
dec96:
	LMB xlo
	TBF
        LCA 1 | LCA 0 | LCA 0 | LCA 0 | LCA 0
        SMA digit1
	TBF
        LCA 0 | nzvc LCA 9 | nzvC LCA 9 | nzVc LCA 9 | nzVC LCA 9 | \
		NZVc LCA 1 | NZVC LCA 1
        SMA digit2
	TBF
        LCA 6 | LCA 7 | LCA 8 | LCA 9 | LCA 0 | \
		LCA 1 | LCA 2 | LCA 3 | LCA 4 | \
		LCA 5 | LCA 6 | LCA 7 | LCA 8 | \
		LCA 9 | LCA 0 | LCA 1
        SMA digit3
	JMP printx

dec192:
	LMB xlo
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

printx:	LCA	3		# Print out the three digits
	LMB	digit1
	DAB	3
	LMB	digit2
	DAB	3
	LMB	digit3
	DAB	0
	LCB	10		# and a newline
	DAB

# Increment xlo
	LMA  xlo
	SMIA xlo
	JCC  loop

# Increment xhi
	LMA  xhi
	SMIA xhi
	JCC  loop

end:    JMP end
