# Print out 0x00 to 0xFF
# (c) 2017 Warren Toomey, GPL3

xhi:	EQU  0
xlo:	EQU  1

        ZEROM xhi			# Initialise the X nibbles
        ZEROM xlo
loop:

# Top digit
        LCA  7
        LMB  xhi
        ADDMB                           # B=B+7, flags set
        LMB  xhi | xzxC NOP		# Reload the digit if 0-9
        LCA  3   | xzxC LCA  4
        DAB  7

# Bottom digit
	CLC
        LMB xlo
        ADDMB                           # B=B+7, flags set
        LMB  xlo | xzxC NOP  		# Reload the digit if 0-9
        LCA  3   | xzxC LCA  4
        DAB  0

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
