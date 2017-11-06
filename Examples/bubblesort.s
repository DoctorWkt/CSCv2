# Sort 16 memory locations into order using
# Bubblesort. (c) 2017 Warren Toomey, GPL3

index:	 EQU 16		# Index into the list, 0 to 14
didswap: EQU 17		# Set to 1 if we did a swap
caller:  EQU 18		# Caller of the hex print code
prnib:	 EQU 19		# Temp storage of digit to print
temp: 	 EQU 254	# Temp location used in swaps

			# Put some values into the first 16
			# locations to make the list
	LCA 5
	SMA 	0
	LCA 4
	SMA 	1
	LCA 0
	SMA 	2
	LCA 3
	SMA 	3
	LCA 13
	SMA 	4
	LCA 1
	SMA 	5
	LCA 10
	SMA 	6
	LCA 7
	SMA 	7
	LCA 15
	SMA 	8
	LCA 11
	SMA 	9
	LCA 14
	SMA 	10
	LCA 12
	SMA 	11
	LCA 8
	SMA 	12
	LCA 9
	SMA 	13
	LCA 2
	SMA 	14
	LCA 6
	SMA 	15

sortinit:
	LCA 0
	SMA didswap	# Start with no swaps performed
	LCB 0		# at index 0
	SMB index
sortstart:
	TBF
			# See if adjacent elements
			# are out of order
	LMA 0 | LMA 1 | LMA 2 | LMA 3 | 		\
	  LMA 4 | LMA 5 | LMA 6 | LMA 7 | 		\
	  LMA 8 | LMA 9 | LMA 10 | LMA 11 | 		\
	  LMA 12 | LMA 13 | LMA 14 | JMP prdigits
	LMB 1 | LMB 2 | LMB 3 | LMB 4 | 		\
	  LMB 5 | LMB 6 | LMB 7 | LMB 8 | 		\
	  LMB 9 | LMB 10 | LMB 11 | LMB 12 | 		\
	  LMB 13 | LMB 14 | LMB 15 | NOP
	CLC
	SUBM
	JCS inorder	# They are in order,
			# otherwise swap them
	LMB index
	TBF
	LMA 0 | LMA 1 | LMA 2 | LMA 3 | 		\
	  LMA 4 | LMA 5 | LMA 6 | LMA 7 | 		\
	  LMA 8 | LMA 9 | LMA 10 | LMA 11 | 		\
	  LMA 12 | LMA 13 | LMA 14 | NOP
	SMA temp
	LMB index
	TBF
	LMA 1 | LMA 2 | LMA 3 | LMA 4 | 		\
	  LMA 5 | LMA 6 | LMA 7 | LMA 8 |		\
	  LMA 9 | LMA 10 | LMA 11 | LMA 12 | 		\
	  LMA 13 | LMA 14 | LMA 15 | NOP
	SMA 0 | SMA 1 | SMA 2 | SMA 3 | 		\
	  SMA 4 | SMA 5 | SMA 6 | SMA 7 |		\
	  SMA 8 | SMA 9 | SMA 10 | SMA 11 |		\
	  SMA 12 | SMA 13 | SMA 14 | NOP
	LMB index
	TBF
	LMA temp
	SMA 1 | SMA 2 | SMA 3 | SMA 4 |			\
	  SMA 5 | SMA 6 | SMA 7 | SMA 8 | 		\
	  SMA 9 | SMA 10 | SMA 11 | SMA 12 | 		\
	  SMA 13 | SMA 14 | SMA 15 | NOP
			# Set that there was a swap
	LCA 1
	SMA didswap
# Debug
#	LCA 0x2
#	LCB 0xE
#	DAB

inorder:
	LMA index	# Move up to the next digit pair
        LCB 1		# Add 1 to index
        CLC
        ADDMB index
	JMP sortstart

prdigits:
			# Print out all 16 digits
	LCA 0
	LMB 0
	JMP prhex
ret0:
	LCA 1
	LMB 1
	JMP prhex
ret1:
	LCA 2
	LMB 2
	JMP prhex
ret2:
	LCA 3
	LMB 3
	JMP prhex
ret3:
	LCA 4
	LMB 4
	JMP prhex
ret4:
	LCA 5
	LMB 5
	JMP prhex
ret5:
	LCA 6
	LMB 6
	JMP prhex
ret6:
	LCA 7
	LMB 7
	JMP prhex
ret7:
	LCA 8
	LMB 8
	JMP prhex
ret8:
	LCA 9
	LMB 9
	JMP prhex
ret9:
	LCA 10
	LMB 10
	JMP prhex
ret10:
	LCA 11
	LMB 11
	JMP prhex
ret11:
	LCA 12
	LMB 12
	JMP prhex
ret12:
	LCA 13
	LMB 13
	JMP prhex
ret13:
	LCA 14
	LMB 14
	JMP prhex
ret14:
	LCA 15
	LMB 15
	JMP prhex
ret15:
			# Print a newline
	LCA 0
	LCB 0xA
	DAB
			# See if we need to repeat the loop
	LMB didswap
	TBF
	NOP | JMP sortinit	# Yes, as we did a swap
end:	JMP end

# Function to print out a nibble in hex followed
# by a space. A holds the caller id. B holds the value
prhex:
	SMA caller			# Save the caller
	SMB prnib			# Temp copy of nibble
	CLC
        LCA 7
        ADDMB                           # B=B+7, flags set
        LMB prnib | zC NOP           	# Reload the digit if 0-9
        LCA 3  | zC LCA  4
	DAB 2				# Print the digit
	LCB 0
        DMAB caller			# Print space, get caller
	TBF
	JMP ret0 | JMP ret1 | JMP ret2 | JMP ret3 |    \
	 JMP ret4 | JMP ret5 | JMP ret6 | JMP ret7 |   \
	 JMP ret8 | JMP ret9 | JMP ret10 | JMP ret11 | \
	 JMP ret12 | JMP ret13 | JMP ret14 | JMP ret15
