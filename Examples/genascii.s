# Generate all printable ASCII characters.
# (c) 2017 Warren Toomey, GPL3.
#

# The character nibbles:
lo: 	EQU 0
hi: 	EQU 1

start:	LCA 2		# Put 0x20 (space) into the character
	SMA hi
	ZEROM lo
looptop:
	LMA hi
	LMB lo		# Print out one character
	DMAB lo
	SMIA lo		# Increment the low nibble
	JZC nothi
	LMA hi
	SMIA hi		# Increment the high nibble
nothi:	LMB hi
	TBF		# Do special things based on the high nibble
	JMP looptop | nZvc JMP 46check | nZVc JMP 46check | nZVC JMP sevencheck

46check:
	LMB lo		# On a high 4 or 6 nibble, loop back if low not zero
	TBF
	JMP looptop | nzvc NOP
			# On 0x40 or 0x60, print a newline first
	LCA 0
	LCB 10
	DAB
	JMP looptop

sevencheck:
	LMB lo		# On a high 7 nibble, loop back if low not 0xF
	TBF
	JMP looptop | NZVC NOP
			# On character Ox7F, print a newline
			# and start all over again
	LCA 0
	LCB 10
	DAB
	JMP start
