# Print out 0x00 to 0xFF
# (c) 2017 Warren Toomey, GPL3

xhi:	EQU  0
xlo:	EQU  1

        ZEROM xhi			# Initialise the X nibbles
        ZEROM xlo
loop:

# Top digit
	LMB xhi
	TBF
	LCA 3 | NzVc LCA 4 | NzVC LCA 4 | NZvc LCA 4 | NZvC LCA 4 \
					| NZVc LCA 4 | NZVC LCA 4 
	NOP   | NzVc LCB 1 | NzVC LCB 2 | NZvc LCB 3 | NZvC LCB 4 \
				        | NZVc LCB 5 | NZVC LCB 6
	DMAB xlo
# Bottom digit
	TBF
	LCA 3 | NzVc LCA 4 | NzVC LCA 4 | NZvc LCA 4 | NZvC LCA 4 \
					| NZVc LCA 4 | NZVC LCA 4 
	NOP   | NzVc LCB 1 | NzVC LCB 2 | NZvc LCB 3 | NZvC LCB 4 \
				        | NZVc LCB 5 | NZVC LCB 6
	DAB 0
# Newline
        LCB 0xA
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
