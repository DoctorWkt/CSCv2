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
	LMA 0 | nzvC LMA 1 | nzVc LMA 2 | nzVC LMA 3 | 			\
	 nZvc LMA 4 | nZvC LMA 5 | nZVc LMA 6 | nZVC LMA 7 | 		\
	 Nzvc LMA 8 | NzvC LMA 9 | NzVc LMA 10 | NzVC LMA 11 | 		\
	 NZvc LMA 12 | NZvC LMA 13 | NZVc LMA 14 | NZVC JMP prdigits
	LMB 1 | nzvC LMB 2 | nzVc LMB 3 | nzVC LMB 4 | 			\
	 nZvc LMB 5 | nZvC LMB 6 | nZVc LMB 7 | nZVC LMB 8 | 		\
	 Nzvc LMB 9 | NzvC LMB 10 | NzVc LMB 11 | NzVC LMB 12 | 	\
	 NZvc LMB 13 | NZvC LMB 14 | NZVc LMB 15 | NZVC NOP
	CLC
	SUBM
	JCS inorder	# They are in order,
			# otherwise swap them
	LMB index
	TBF
	LMA 0 | nzvC LMA 1 | nzVc LMA 2 | nzVC LMA 3 | 			\
	 nZvc LMA 4 | nZvC LMA 5 | nZVc LMA 6 | nZVC LMA 7 | 		\
	 Nzvc LMA 8 | NzvC LMA 9 | NzVc LMA 10 | NzVC LMA 11 | 		\
	 NZvc LMA 12 | NZvC LMA 13 | NZVc LMA 14 | NZVC NOP
	SMA temp
	LMB index
	TBF
	LMA 1 | nzvC LMA 2 | nzVc LMA 3 | nzVC LMA 4 | 			\
	 nZvc LMA 5 | nZvC LMA 6 | nZVc LMA 7 | nZVC LMA 8 |		\
	 Nzvc LMA 9 | NzvC LMA 10 | NzVc LMA 11 | NzVC LMA 12 | 	\
	 NZvc LMA 13 | NZvC LMA 14 | NZVc LMA 15 | NZVC NOP
	SMA 0 | nzvC SMA 1 | nzVc SMA 2 | nzVC SMA 3 | 			\
	 nZvc SMA 4 | nZvC SMA 5 | nZVc SMA 6 | nZVC SMA 7 |		\
	 Nzvc SMA 8 | NzvC SMA 9 | NzVc SMA 10 | NzVC SMA 11 |		\
	 NZvc SMA 12 | NZvC SMA 13 | NZVc SMA 14 | NZVC NOP
	LMB index
	TBF
	LMA temp
	SMA 1 | nzvC SMA 2 | nzVc SMA 3 | nzVC SMA 4 | 			\
	 nZvc SMA 5 | nZvC SMA 6 | nZVc SMA 7 | nZVC SMA 8 | 		\
	 Nzvc SMA 9 | NzvC SMA 10 | NzVc SMA 11 | NzVC SMA 12 | 	\
	 NZvc SMA 13 | NZvC SMA 14 | NZVc SMA 15 | NZVC NOP
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
	NOP | nzvC JMP sortinit	# Yes, as we did a swap
end:	JMP end

# Function to print out a nibble in hex followed
# by a space. A holds the caller id. B holds the value
prhex:
	SMA caller			# Save the caller
	SMB prnib			# Temp copy of nibble
	CLC
        LCA 7
        ADDMB                           # B=B+7, flags set
        LMB prnib | xzxC NOP           	# Reload the digit if 0-9
        LCA 3  | xzxC LCA  4
	DAB 2				# Print the digit
	LCB 0
        DMAB caller			# Print space, get caller
	TBF
	nzvc JMP ret0 | nzvC JMP ret1 | nzVc JMP ret2 | nzVC JMP ret3 |    \
	 nZvc JMP ret4 | nZvC JMP ret5 | nZVc JMP ret6 | nZVC JMP ret7 |   \
	 Nzvc JMP ret8 | NzvC JMP ret9 | NzVc JMP ret10 | NzVC JMP ret11 | \
	 NZvc JMP ret12 | NZvC JMP ret13 | NZVc JMP ret14 | NZVC JMP ret15
