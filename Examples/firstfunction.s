# First attempt at getting functions to work.
# And it does work!
#

caller:	EQU 0	# Id of the function caller

# Print digit 2 and newline
	LCA 0	# Caller id
	LCB 2
	JMP printdigit
enddigit2:

# Print digit 4 and newline
	LCA 1	# Caller id
	LCB 4
	JMP printdigit
enddigit4:

# Print digit 6 and newline
	LCA 2	# Caller id
	LCB 6
	JMP printdigit
enddigit6:

# Print digit 8 and newline
	LCA 3	# Caller id
	LCB 8
	JMP printdigit
enddigit8: JMP enddigit8

# Function to print digit and newline
printdigit: SMA caller	# Save caller id
	LCA 3
	DAB 0		# Print the digit
	LCB 10
	DMAB caller	# Print newline, get caller
	TBF		# Transfer caller to flags
			# Jump based on flags value
	JMP enddigit2 | JMP enddigit4 | \
		JMP enddigit6 | JMP enddigit8
