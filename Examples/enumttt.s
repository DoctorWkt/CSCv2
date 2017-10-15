# Enumerate all possible winning tic tac toe boards
# where X moves first. (c) 2017 Warren Toomey, GPL3.

# We store the current board configuration in locations
# b1 to b9. 0 is empty, 1 is an X, 8 is an O. We use these
# values so that we can AND three positions to find a
# winning move.
#
# Unfortunately, there are not enough instructions to convert
# 0, 1, 8 into space, X, O, so the code prints out the board
# using ASCII 0, 1, 8 characters.

b1:	EQU 0
b2:	EQU 1
b3:	EQU 2
b4:	EQU 3
b5:	EQU 4
b6:	EQU 5
b7:	EQU 6
b8:	EQU 7
b9:	EQU 8

NUL:	EQU 0		# Empty, cross and nought constants
X:	EQU 1
O:	EQU 8

# Players take turns, and m1 to m9 store the latest move for that turn.
# Values are 0 to 8.
m1:	EQU 9
m2:	EQU 10
m3:	EQU 11
m4:	EQU 12
m5:	EQU 13
m6:	EQU 14
m7:	EQU 15
m8:	EQU 16
m9:	EQU 17

caller: EQU 18		# Id of winboard caller
temp:   EQU 255

# Initialise the board and the current moves
	ZEROM b1
	ZEROM b2
	ZEROM b3
	ZEROM b4
	ZEROM b5
	ZEROM b6
	ZEROM b7
	ZEROM b8
	ZEROM b9
	ZEROM m1
	ZEROM m2
	ZEROM m3
	ZEROM m4
	ZEROM m5
	ZEROM m6
	ZEROM m7
	ZEROM m8
	ZEROM m9

m1loop:
	LCA X		# Store a X on the board at position m1
	LMB m1
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9

m2loop:
	LMB m2		# Get the possible m2 position
	TBF
			# Skip if already occupied
	JMP m1clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA O | nzvC JMP m2inc | Nzvc JMP m2inc
	LMB m2
	TBF		# Store an O on the board at position m1
	JMP m1clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9

m3loop:
	LMB m3		# Get the possible m3 position
	TBF
			# Skip if already occupied
	JMP m2clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA X | nzvC JMP m3inc | Nzvc JMP m3inc
	LMB m3
	TBF		# Store an X on the board at position m3
	JMP m2clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9

m4loop:
	LMB m4		# Get the possible m4 position
	TBF
			# Skip if already occupied
	JMP m3clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA O | nzvC JMP m4inc | Nzvc JMP m4inc
	LMB m4
	TBF		# Store an O on the board at position m4
	JMP m3clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
	nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | Nzvc SMA b9

m5loop:
	LMB m5		# Get the possible m5 position
	TBF
			# Skip if already occupied
	JMP m4clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA X | nzvC JMP m5inc | Nzvc JMP m5inc
	LMB m5
	TBF		# Store an X on the board at position m5
	JMP m4clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
	LCA 0
	JMP winboard	# See if there is a winner
m5nowin:

m6loop:
	LMB m6		# Get the possible m6 position
	TBF
			# Skip if already occupied
	JMP m5clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA O | nzvC JMP m6inc | Nzvc JMP m6inc
	LMB m6
	TBF		# Store an O on the board at position m6
	JMP m5clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
	LCA 1
	JMP winboard	# See if there is a winner
m6nowin:

m7loop:
	LMB m7		# Get the possible m7 position
	TBF
			# Skip if already occupied
	JMP m6clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA X | nzvC JMP m7inc | Nzvc JMP m7inc
	LMB m7
	TBF		# Store an X on the board at position m7
	JMP m6clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
	LCA 2
	JMP winboard	# See if there is a winner
m7nowin:

m8loop:
	LMB m8		# Get the possible m8 position
	TBF
			# Skip if already occupied
	JMP m7clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA O | nzvC JMP m8inc | Nzvc JMP m8inc
	LMB m8
	TBF		# Store an O on the board at position m8
	JMP m7clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
	LCA 3
	JMP winboard	# See if there is a winner
m8nowin:

m9loop:
	LMB m9		# Get the possible m9 position
	TBF
			# Skip if already occupied
	JMP m8clr | nzvc LMB b1 | nzvC LMB b2 | nzVc LMB b3 | nzVC LMB b4 | \
		nZvc LMB b5 | nZvC LMB b6 | nZVc LMB b7 | nZVC LMB b8 | \
		Nzvc LMB b9
	TBF
	LCA X | nzvC JMP m9inc | Nzvc JMP m9inc
	LMB m9
	TBF		# Store an X on the board at position m9
	JMP m8clr | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
	LCA 4
	JMP winboard
m9nowin:
m9win:
m9clr:
	LCA NUL		# Clear the board at position m9
	LMB m9
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m9inc:
	LMA m9		# Move up to next m9 position
	SMIA m9
	JMP m9loop
m8win:
m8clr:
	ZEROM m9	# Reset the m9 loop
	LCA NUL		# Clear the board at position m8
	LMB m8
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m8inc:
	LMA m8		# Move up to next m8 position
	SMIA m8
	JMP m8loop
m7win:
m7clr:
	ZEROM m8	# Reset the m8 loop
	LCA NUL		# Clear the board at position m7
	LMB m7
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m7inc:
	LMA m7		# Move up to next m7 position
	SMIA m7
	JMP m7loop
m6win:
m6clr:
	ZEROM m7	# Reset the m7 loop
	LCA NUL		# Clear the board at position m6
	LMB m6
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m6inc:
	LMA m6		# Move up to next m6 position
	SMIA m6
	JMP m6loop
m5win:
m5clr:
	ZEROM m6	# Reset the m6 loop
	LCA NUL		# Clear the board at position m5
	LMB m5
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m5inc:
	LMA m5		# Move up to next m5 position
	SMIA m5
	JMP m5loop
m4clr:
	ZEROM m5	# Reset the m5 loop
	LCA NUL		# Clear the board at position m4
	LMB m4
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m4inc:
	LMA m4		# Move up to next m4 position
	SMIA m4
	JMP m4loop
m3clr:
	ZEROM m4	# Reset the m4 loop
	LCA NUL		# Clear the board at position m3
	LMB m3
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m3inc:
	LMA m3		# Move up to next m3 position
	SMIA m3
	JMP m3loop
m2clr:
	ZEROM m3	# Reset the m3 loop
	LCA NUL		# Clear the board at position m2
	LMB m2
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m2inc:
	LMA m2		# Move up to next m2 position
	SMIA m2
	JMP m2loop
m1clr:
	ZEROM m2	# Reset the m2 loop
	LCA NUL		# Clear the board at position m1
	LMB m1
	TBF
	JMP end | nzvc SMA b1 | nzvC SMA b2 | nzVc SMA b3 | nzVC SMA b4 | \
		nZvc SMA b5 | nZvC SMA b6 | nZVc SMA b7 | nZVC SMA b8 | \
		Nzvc SMA b9
m1inc:
	LMA m1		# Move up to next m1 position
	SMIA m1
	JMP m1loop
end:	JMP end

# Subroutine to test if the board has a winning move.
# If a winning move, prints the board.
winboard:
	SMA caller	# Save caller id
	LMA b1 		# Test b1 b2 b3
	LMB b2
	ANDM temp
	LMA temp
	LMB b3
	ANDM
	JZC prboard	# Winning, print, B still has b3
	LMA b5 		# Test b3 b5 b7
	ANDM temp
	LMA temp
	LMB b7
	ANDM
	JZC prboard	# Winning, print, B still has b7
	LMA b4 		# Test b7 b4 b1
	ANDM temp
	LMA temp
	LMB b1
	ANDM
	JZC prboard	# Winning, print, B still has b1
	LMA b5 		# Test b1 b4 b9
	ANDM temp
	LMA temp
	LMB b9
	ANDM
	JZC prboard	# Winning, print, B still has b9
	LMA b7 		# Test b9 b7 b8
	ANDM temp
	LMA temp
	LMB b8
	ANDM
	JZC prboard	# Winning, print, B still has b8
	LMA b2 		# Test b8 b2 b5
	ANDM temp
	LMA temp
	LMB b5
	ANDM
	JZC prboard	# Winning, print, B still has b5
	LMA b4 		# Test b5 b4 b6
	ANDM temp
	LMA temp
	LMB b6
	ANDM
	JZC prboard	# Winning, print, B still has b6
	LMA b3 		# Test b6 b3 b9
	ANDM temp
	LMA temp
	LMB b9
	ANDM
	JZS nowinret	# Not winning, don't print

prboard:
	LCA 3
	LMB b1
	DAB 3
	LMB b2
	DAB 3
	LMB b3
	DAB 0
	LCB 10		# Newline
	DAB 3
	LMB b4
	DAB 3
	LMB b5
	DAB 3
	LMB b6
	DAB 0
	LCB 10		# Newline
	DAB 3
	LMB b7
	DAB 3
	LMB b8
	DAB 3
	LMB b9
	DAB 0
	LCB 10		# Newline
	DAB 0
	LCB 10		# Newline
        DAB
yeswinret:
	LMB caller	# Load caller id
        TBF             # Transfer caller to flags
                        # Jump based on flags value
end:    JMP end | nzvc JMP m5win | nzvC JMP m6win | nzVc JMP m7win | \
		nzVC JMP m8win | nZvc JMP m9win
nowinret:
	LMB caller	# Load caller id
        TBF             # Transfer caller to flags
                        # Jump based on flags value
end:    JMP end | nzvc JMP m5nowin | nzvC JMP m6nowin | nzVc JMP m7nowin | \
		nzVC JMP m8nowin | nZvc JMP m9nowin
