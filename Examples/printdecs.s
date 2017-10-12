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
        nzvc LCA 0 | nzvC LCA 0 | nzVc LCA 0 | nzVC LCA 0 | nZvc LCA 0 | nZvC LCA 0 | nZVc JMP dec96 | nZVC LCA 1 | Nzvc LCA 1 | NzvC LCA 1 | NzVc LCA 1 | NzVC LCA 1 | NZvc JMP dec192 | NZvC LCA 2 | NZVc LCA 2 | NZVC LCA 2
        SMA digit1

        # Get some of the second digit
        TBF
        nzvc LCA 0 | nzvC LCA 1 | nzVc LCA 3 | nzVC LCA 4 | nZvc LCA 6 | nZvC LCA 8 | nZVc LCA 9 | nZVC LCA 1 | Nzvc LCA 2 | NzvC LCA 4 | NzVc LCA 6 | NzVC LCA 7 | NZvc LCA 9 | NZvC LCA 0 | NZVc LCA 2 | NZVC LCA 4
        SMA digit2

        # Get the leftover from the high nibble
        TBF
        nzvc LCA 0 | nzvC LCA 6 | nzVc LCA 2 | nzVC LCA 8 | nZvc LCA 4 | nZvC LCA 0 | nZVc LCA 6 | nZVC LCA 2 | Nzvc LCA 8 | NzvC LCA 4 | NzVc LCA 0 | NzVC LCA 6 | NZvc LCA 2 | NZvC LCA 8 | NZVc LCA 4 | NZVC LCA 0
        # Add the low nibble to the leftover from the high nibble
	CLC
        LMB xlo
        ADDMB

	# We have a result 16 to 24, deal with that
	JCS caryon
	# We have a result 0 to 15
	TBF
	# Save the correct decimal digit into digit3
	SMB digit3 | NzVc LCA 0 | NzVC LCA 1 | NZvc LCA 2 | NZvC LCA 3 | NZVc LCA 4 | NZVC LCA 5
	TBF
	JMP printx | NzVc SMA digit3 | NzVC SMA digit3 | NZvc SMA digit3 | NZvC SMA digit3 | NZVc SMA digit3 | NZVC SMA digit3
	# Increment digit2 if required
	LMA digit2
	SMIA digit2
	JMP printx


caryon:	# We have a result 16 to 24, deal with that
	# Save the correct decimal digit into digit3
	TBF
	nzvc LCA 6 | nzvC LCA 7 | nzVc LCA 8 | nzVC LCA 9 | nZvc LCA 0 | nZvC LCA 1 | nZVc LCA 2 | nZVC LCA 3 | Nzvc LCA 4
	SMA digit3
	# Work out what to add to digit2
	TBF
	nzvc LCB 1 | nzvC LCB 1 | nzVc LCB 1 | nzVC LCB 1 | nZvc LCB 2 | nZvC LCB 2 | nZVc LCB 2 | nZVC LCB 2 | Nzvc LCB 2
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
        LCA 1 | nzvc LCA 0 | nzvC LCA 0 | nzVc LCA 0 | nzVC LCA 0
        SMA digit1
	TBF
        LCA 0 | nzvc LCA 9 | nzvC LCA 9 | nzVc LCA 9 | nzVC LCA 9 | NZVc LCA 1 | NZVC LCA 1
        SMA digit2
	TBF
        nzvc LCA 6 | nzvC LCA 7 | nzVc LCA 8 | nzVC LCA 9 | nZvc LCA 0 | nZvC LCA 1 | nZVc LCA 2 | nZVC LCA 3 | Nzvc LCA 4 | NzvC LCA 5 | NzVc LCA 6 | NzVC LCA 7 | NZvc LCA 8 | NZvC LCA 9 | NZVc LCA 0 | NZVC LCA 1
        SMA digit3
	JMP printx

dec192:
	LMB xlo
	TBF
        LCA 1 | Nxxx LCA 2
        SMA digit1
	TBF
        LCA 9 | Nxxx LCA 0
        SMA digit2
	TBF
        nzvc LCA 2 | nzvC LCA 3 | nzVc LCA 4 | nzVC LCA 5 | nZvc LCA 6 | nZvC LCA 7 | nZVc LCA 8 | nZVC LCA 9 | Nzvc LCA 0 | NzvC LCA 1 | NzVc LCA 2 | NzVC LCA 3 | NZvc LCA 4 | NZvC LCA 5 | NZVc LCA 6 | NZVC LCA 7
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
