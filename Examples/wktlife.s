# Warren's version of the Game of Life
# (c) 2017 Warren Toomey, GPL3
#
# Run with ./csim -c 10000 (i.e 10kHz clock speed, or faster

# Memory arrangement: consider RAM to be have a square 16x16 arrangement where
# the high nibble is the y-position (row) and the low nibble is the x-position
# (col). The Game of Life is played in the innermost 14x14 cells, with the edge
# cells treated as being dead (values zero).
#
# At any point in time, we are working from left to right across a specific row.
# We have cached this row, the row above and the row below in the edge cells
# which are not being used as in-place cells.
#
# Row 0, i.e 0x00 to 0x0F holds a cache of the row above us.
# Row F, i.e 0xF0 to 0xFF holds a cache of the row we are on.
# Locations 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, brc6, 0x80
#           0x1F, 0x2F, 0x3F, 0x4F, 0x5F, 0x6F, 0x7F, 0x8F
# hold a cache of the row below us.
#
# This leaves these locations spare: 0x90, 0xA0, 0xB0, 0xC0, 0xD0, 0xE0,
#                                   0x9F, 0xAF, 0xBF, 0xCF, 0xDF, 0xEF

# Current row and column
row:	EQU 0x90
col:	EQU 0xA0

# Next row, always row+1
nextrow: EQU 0xB0

# We are using 0xFF as part of a row, so the next
# location is the explict scratch location. Must
# be used on all ALU instructions with no address.
scratch: EQU 0xC0

# As we walk along a row, we calculate the sum of the three neighbours
# to our right and store it in sum3. This is then rippled down
# to sum2 and sum1, so that sum1 is the sum of the three neighbours
# to our left.
sum1: EQU 0xD0
sum2: EQU 0xE0
sum3: EQU 0x9F

# We keep the running neighbour sum here.
sum:     EQU 0xAF

# Cached copy of this cell
thiscell: EQU 0xBF

# Mnemonic names for cached rows: top row cell X, mid row cell X etc.
trc0:	EQU 0x00
trc1:	EQU 0x01
trc2:	EQU 0x02
trc3:	EQU 0x03
trc4:	EQU 0x04
trc5:	EQU 0x05
trc6:	EQU 0x06
trc7:	EQU 0x07
trc8:	EQU 0x08
trc9:	EQU 0x09
trcA:	EQU 0x0A
trcB:	EQU 0x0B
trcC:	EQU 0x0C
trcD:	EQU 0x0D
trcE:	EQU 0x0E
trcF:	EQU 0x0F
mrc0:	EQU 0xF0
mrc1:	EQU 0xF1
mrc2:	EQU 0xF2
mrc3:	EQU 0xF3
mrc4:	EQU 0xF4
mrc5:	EQU 0xF5
mrc6:	EQU 0xF6
mrc7:	EQU 0xF7
mrc8:	EQU 0xF8
mrc9:	EQU 0xF9
mrcA:	EQU 0xFA
mrcB:	EQU 0xFB
mrcC:	EQU 0xFC
mrcD:	EQU 0xFD
mrcE:	EQU 0xFE
mrcF:	EQU 0xFF
brc0:	EQU 0x10
brc1:	EQU 0x20
brc2:	EQU 0x30
brc3:	EQU 0x40
brc4:	EQU 0x50
brc5:	EQU 0x60
brc6:	EQU 0x70
brc7:	EQU 0x80
brc8:	EQU 0x1F
brc9:	EQU 0x2F
brcA:	EQU 0x3F
brcB:	EQU 0x4F
brcC:	EQU 0x5F
brcD:	EQU 0x6F
brcE:	EQU 0x7F
brcF:	EQU 0x8F

# Test code: a glider in the top-right corner
	LCA 1
	SMA 0x1D
	SMA 0x2C
	SMA 0x3C
	SMA 0x3D
	SMA 0x3E

# Clear screen: Print out ESC [ 2 J
        LCA 0x1
        LCB 0xB
        DAB 0x5
        LCB 0xB
        DAB 0x3
        LCB 0x2
        DAB 0x4
        LCB 0xA
        DAB

start:
# Return to the top of the screen: Print out ESC [ H
        LCA 0x1
        LCB 0xB
        DAB 0x5
        LCB 0xB
        DAB 0x4
        LCB 0x8
        DAB 0x0		# Initialise B to 0 for upcoming loop

# Initialise the top row with zeroes.
	ZEROM col
zerorow:
	TBF scratch
	ZEROM trc0 | ZEROM trc1 | ZEROM trc2 | ZEROM trc3 | \
	ZEROM trc4 | ZEROM trc5 | ZEROM trc6 | ZEROM trc7 | \
	ZEROM trc8 | ZEROM trc9 | ZEROM trcA | ZEROM trcB | \
	ZEROM trcC | ZEROM trcD | ZEROM trcE | ZEROM trcF
	LCA 1
	ADDMB col
	JMP zerorow | C NOP	# Drop out of loop when B is zero

# Start on row zero. On this row, we don't do any new cell calculation
# but we do load the row below us.
	SMB row
	LCA 1
	SMA nextrow

# Given nextrow has the row to fetch, peek all sixteen cell values and
# copy them into the cached locations brc0 .. brc7, brc8 .. brcF. This
# will never happen with nextrow==0, but just in case, do the same	
# as the last (empty) row, row F.
fetchrow:
	ZEROM col
	LMB nextrow
	TBF scratch
	LCB 0		# Pre-load B with column 0 before we jump
	JMP fetchrowF | JMP fetchrow1 | JMP fetchrow2 | JMP fetchrow3 | \
	JMP fetchrow4 | JMP fetchrow5 | JMP fetchrow6 | JMP fetchrow7 | \
	JMP fetchrow8 | JMP fetchrow9 | JMP fetchrowA | JMP fetchrowB | \
	JMP fetchrowC | JMP fetchrowD | JMP fetchrowE | JMP fetchrowF

# This comment applies to all fourteen useful versions. We already have
# 0 in B due to the LCB 0 above. Ensure we get back 0 on the edges. Put
# B into the flags so that we thread down through the code. Increment the
# col as we go.
fetchrow1:
	TBF scratch
	LCA    0 | LMA 0x11 | LMA 0x12 | LMA 0x13 | \
	LMA 0x14 | LMA 0x15 | LMA 0x16 | LMA 0x17 | \
	LMA 0x18 | LMA 0x19 | LMA 0x1A | LMA 0x1B | \
	LMA 0x1C | LMA 0x1D | LMA 0x1E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow1 | C JMP fetchend
fetchrow2:
	TBF scratch
	LCA    0 | LMA 0x21 | LMA 0x22 | LMA 0x23 | \
	LMA 0x24 | LMA 0x25 | LMA 0x26 | LMA 0x27 | \
	LMA 0x28 | LMA 0x29 | LMA 0x2A | LMA 0x2B | \
	LMA 0x2C | LMA 0x2D | LMA 0x2E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow2 | C JMP fetchend
fetchrow3:
	TBF scratch
	LCA    0 | LMA 0x31 | LMA 0x32 | LMA 0x33 | \
	LMA 0x34 | LMA 0x35 | LMA 0x36 | LMA 0x37 | \
	LMA 0x38 | LMA 0x39 | LMA 0x3A | LMA 0x3B | \
	LMA 0x3C | LMA 0x3D | LMA 0x3E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow3 | C JMP fetchend
fetchrow4:
	TBF scratch
	LCA    0 | LMA 0x41 | LMA 0x42 | LMA 0x43 | \
	LMA 0x44 | LMA 0x45 | LMA 0x46 | LMA 0x47 | \
	LMA 0x48 | LMA 0x49 | LMA 0x4A | LMA 0x4B | \
	LMA 0x4C | LMA 0x4D | LMA 0x4E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow4 | C JMP fetchend
fetchrow5:
	TBF scratch
	LCA    0 | LMA 0x51 | LMA 0x52 | LMA 0x53 | \
	LMA 0x54 | LMA 0x55 | LMA 0x56 | LMA 0x57 | \
	LMA 0x58 | LMA 0x59 | LMA 0x5A | LMA 0x5B | \
	LMA 0x5C | LMA 0x5D | LMA 0x5E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow5 | C JMP fetchend
fetchrow6:
	TBF scratch
	LCA    0 | LMA 0x61 | LMA 0x62 | LMA 0x63 | \
	LMA 0x64 | LMA 0x65 | LMA 0x66 | LMA 0x67 | \
	LMA 0x68 | LMA 0x69 | LMA 0x6A | LMA 0x6B | \
	LMA 0x6C | LMA 0x6D | LMA 0x6E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow6 | C JMP fetchend
fetchrow7:
	TBF scratch
	LCA    0 | LMA 0x71 | LMA 0x72 | LMA 0x73 | \
	LMA 0x74 | LMA 0x75 | LMA 0x76 | LMA 0x77 | \
	LMA 0x78 | LMA 0x79 | LMA 0x7A | LMA 0x7B | \
	LMA 0x7C | LMA 0x7D | LMA 0x7E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow7 | C JMP fetchend
fetchrow8:
	TBF scratch
	LCA    0 | LMA 0x81 | LMA 0x82 | LMA 0x83 | \
	LMA 0x84 | LMA 0x85 | LMA 0x86 | LMA 0x87 | \
	LMA 0x88 | LMA 0x89 | LMA 0x8A | LMA 0x8B | \
	LMA 0x8C | LMA 0x8D | LMA 0x8E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow8 | C JMP fetchend
fetchrow9:
	TBF scratch
	LCA    0 | LMA 0x91 | LMA 0x92 | LMA 0x93 | \
	LMA 0x94 | LMA 0x95 | LMA 0x96 | LMA 0x97 | \
	LMA 0x98 | LMA 0x99 | LMA 0x9A | LMA 0x9B | \
	LMA 0x9C | LMA 0x9D | LMA 0x9E | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrow9 | C JMP fetchend
fetchrowA:
	TBF scratch
	LCA    0 | LMA 0xA1 | LMA 0xA2 | LMA 0xA3 | \
	LMA 0xA4 | LMA 0xA5 | LMA 0xA6 | LMA 0xA7 | \
	LMA 0xA8 | LMA 0xA9 | LMA 0xAA | LMA 0xAB | \
	LMA 0xAC | LMA 0xAD | LMA 0xAE | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrowA | C JMP fetchend
fetchrowB:
	TBF scratch
	LCA    0 | LMA 0xB1 | LMA 0xB2 | LMA 0xB3 | \
	LMA 0xB4 | LMA 0xB5 | LMA 0xB6 | LMA 0xB7 | \
	LMA 0xB8 | LMA 0xB9 | LMA 0xBA | LMA 0xBB | \
	LMA 0xBC | LMA 0xBD | LMA 0xBE | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrowB | C JMP fetchend
fetchrowC:
	TBF scratch
	LCA    0 | LMA 0xC1 | LMA 0xC2 | LMA 0xC3 | \
	LMA 0xC4 | LMA 0xC5 | LMA 0xC6 | LMA 0xC7 | \
	LMA 0xC8 | LMA 0xC9 | LMA 0xCA | LMA 0xCB | \
	LMA 0xCC | LMA 0xCD | LMA 0xCE | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrowC | C JMP fetchend
fetchrowD:
	TBF scratch
	LCA    0 | LMA 0xD1 | LMA 0xD2 | LMA 0xD3 | \
	LMA 0xD4 | LMA 0xD5 | LMA 0xD6 | LMA 0xD7 | \
	LMA 0xD8 | LMA 0xD9 | LMA 0xDA | LMA 0xDB | \
	LMA 0xDC | LMA 0xDD | LMA 0xDE | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrowD | C JMP fetchend
fetchrowE:
	TBF scratch
	LCA    0 | LMA 0xE1 | LMA 0xE2 | LMA 0xE3 | \
	LMA 0xE4 | LMA 0xE5 | LMA 0xE6 | LMA 0xE7 | \
	LMA 0xE8 | LMA 0xE9 | LMA 0xEA | LMA 0xEB | \
	LMA 0xEC | LMA 0xED | LMA 0xEE | LCA 0
	SMA brc0 | SMA brc1 | SMA brc2 | SMA brc3 | \
	SMA brc4 | SMA brc5 | SMA brc6 | SMA brc7 | \
	SMA brc8 | SMA brc9 | SMA brcA | SMA brcB | \
	SMA brcC | SMA brcD | SMA brcE | SMA brcF
	LCA 1
	ADDMB col
	JMP fetchrowE | C JMP fetchend
fetchrowF:
	TBF scratch
	ZEROM brc0 | ZEROM brc1 | ZEROM brc2 | ZEROM brc3 | \
	ZEROM brc4 | ZEROM brc5 | ZEROM brc6 | ZEROM brc7 | \
	ZEROM brc8 | ZEROM brc9 | ZEROM brcA | ZEROM brcB | \
	ZEROM brcC | ZEROM brcD | ZEROM brcE | ZEROM brcF
	LCA 1
	ADDMB col
	JMP fetchrow1 | C JMP fetchend

fetchend:

# Skip the new cell calculations if we are row 0. Otherwise,
# set sum1 to zero.
	LMB row
	TBF scratch
	ZEROM sum1 | nzvc JMP copybotmid

# At this point in the proceedings, we have three rows of cell data
# cached, and we know what middle row we need to write back to. We can
# now do the cell calculations. Start in column 0.
	LCB 0
	SMB col
calcstart:
	TBF scratch

# First up, calculate the sum of three neighbours to our right.
# For column 14, the sum is zero. If in column 15, go to rowsend.
	LMA trc1 | LMA trc2 | LMA trc3 | LMA trc4 | LMA trc5 | \
		   LMA trc6 | LMA trc7 | LMA trc8 | LMA trc9 | \
		   LMA trcA | LMA trcB | LMA trcC | LMA trcD | \
		   LMA trcE |   LCA 0  | JMP rowsend
	LMB mrc1 | LMB mrc2 | LMB mrc3 | LMB mrc4 | LMB mrc5 | LMB mrc6 | \
	           LMB mrc7 | LMB mrc8 | LMB mrc9 | LMB mrcA | LMB mrcB | \
	           LMB mrcC | LMB mrcD | LMB mrcE | LCB 0 | NOP
	CLC			# Must reset C due to flags above
	ADDMA sum3
	LMB col
	TBF scratch
	LMB brc1 | LMB brc2 | LMB brc3 | LMB brc4 | LMB brc5 | LMB brc6 | \
	           LMB brc7 | LMB brc8 | LMB brc9 | LMB brcA | LMB brcB | \
	           LMB brcC | LMB brcD | LMB brcE | LCB 0 | NOP
	CLC			# Must reset C due to flags above
	ADDMA sum3

# Don't got any further in column 0, but skip so that we can copy sum3
# down to sum2
	LMB col
	TBF scratch
	NOP | nzvc JMP ripplesums

# Add sum1 and sum3 together. If the sum is 4 or more, kill this cell
# and jump to savecell. Otherwise, continue on with the rest of the code.

	LMB sum1
	CLC			# Must reset C due to flags above
	ADDMB sum
	TBF scratch
	NOP | NOP | NOP | NOP | LCA 0 | LCA 0 | LCA 0 | LCA 0 | LCA 0 | \
	      LCA 0 | LCA 0 | LCA 0 | LCA 0 | LCA 0 | LCA 0 | LCA 0 | LCA 0
	NOP | NOP | NOP | NOP | JMP savecell | \
	      JMP savecell | JMP savecell | JMP savecell | JMP savecell | \
	      JMP savecell | JMP savecell | JMP savecell | JMP savecell | \
	      JMP savecell | JMP savecell | JMP savecell | JMP savecell

# Copy our cell to a known location.
	LMB col
	TBF scratch
	NOP | LMA mrc1 | LMA mrc2 | LMA mrc3 | LMA mrc4 | \
	      LMA mrc5 | LMA mrc6 | LMA mrc7 | LMA mrc8 | \
	      LMA mrc9 | LMA mrcA | LMA mrcB | LMA mrcC | \
	      LMA mrcD | LMA mrcE | NOP
	SMA thiscell

# Add the cell above and below us to the sum.
	LMB col
	TBF scratch
	LMA sum
	NOP | LMB trc1 | LMB trc2 | LMB trc3 | LMB trc4 | \
	      LMB trc5 | LMB trc6 | LMB trc7 | LMB trc8 | \
	      LMB trc9 | LMB trcA | LMB trcB | LMB trcC | \
	      LMB trcD | LMB trcE | NOP
	CLC			# Must reset C due to flags above
	ADDMA sum
	LMB col
	TBF scratch
	NOP | LMB brc1 | LMB brc2 | LMB brc3 | LMB brc4 | LMB brc5 | \
	      LMB brc6 | LMB brc7 | LMB brc8 | LMB brc9 | LMB brcA | \
	      LMB brcB | LMB brcC | LMB brcD | LMB brcE | NOP
	CLC			# Must reset C due to flags above
	ADDMB sum

# We now have the full neighbour sum. If the sum is 0, 1, 4 or more, kill
# this cell. Luckily 8==0! If the answer is 3, make the cell live. If the
# sum is 2, load the existing value of the cell.
	TBF scratch
	LCA 0 | LCA 0 | LMA thiscell | LCA 1 | \
	        LCA 0 | LCA 0 | LCA 0 | LCA 0 | \
	        LCA 0 | LCA 0 | LCA 0 | LCA 0 | \
	        LCA 0 | LCA 0 | LCA 0 | LCA 0

# We now have the cell's new value in the A register.
# Save it into the real cell in RAM.
savecell:
	LMB row
	TBF scratch
	LMB col
	JMP printcell | JMP poke1 | JMP poke2 | JMP poke3 | \
	JMP poke4     | JMP poke5 | JMP poke6 | JMP poke7 | \
	JMP poke8     | JMP poke9 | JMP pokeA | JMP pokeB | \
	JMP pokeC     | JMP pokeD | JMP pokeE | JMP printcell

poke1:  TBF scratch
	NOP | SMA 0x11 | SMA 0x12 | SMA 0x13 | SMA 0x14 | SMA 0x15 | \
	      SMA 0x16 | SMA 0x17 | SMA 0x18 | SMA 0x19 | SMA 0x1A | \
	      SMA 0x1B | SMA 0x1C | SMA 0x1D | SMA 0x1E | NOP
	JMP printcell

poke2:  TBF scratch
	NOP | SMA 0x21 | SMA 0x22 | SMA 0x23 | SMA 0x24 | SMA 0x25 | \
	      SMA 0x26 | SMA 0x27 | SMA 0x28 | SMA 0x29 | SMA 0x2A | \
	      SMA 0x2B | SMA 0x2C | SMA 0x2D | SMA 0x2E | NOP
	JMP printcell

poke3:  TBF scratch
	NOP | SMA 0x31 | SMA 0x32 | SMA 0x33 | SMA 0x34 | SMA 0x35 | \
	      SMA 0x36 | SMA 0x37 | SMA 0x38 | SMA 0x39 | SMA 0x3A | \
	      SMA 0x3B | SMA 0x3C | SMA 0x3D | SMA 0x3E | NOP
	JMP printcell

poke4:  TBF scratch
	NOP | SMA 0x41 | SMA 0x42 | SMA 0x43 | SMA 0x44 | SMA 0x45 | \
	      SMA 0x46 | SMA 0x47 | SMA 0x48 | SMA 0x49 | SMA 0x4A | \
	      SMA 0x4B | SMA 0x4C | SMA 0x4D | SMA 0x4E | NOP
	JMP printcell

poke5:  TBF scratch
	NOP | SMA 0x51 | SMA 0x52 | SMA 0x53 | SMA 0x54 | SMA 0x55 | \
	      SMA 0x56 | SMA 0x57 | SMA 0x58 | SMA 0x59 | SMA 0x5A | \
	      SMA 0x5B | SMA 0x5C | SMA 0x5D | SMA 0x5E | NOP
	JMP printcell

poke6:  TBF scratch
	NOP | SMA 0x61 | SMA 0x62 | SMA 0x63 | SMA 0x64 | SMA 0x65 | \
	      SMA 0x66 | SMA 0x67 | SMA 0x68 | SMA 0x69 | SMA 0x6A | \
	      SMA 0x6B | SMA 0x6C | SMA 0x6D | SMA 0x6E | NOP
	JMP printcell

poke7:  TBF scratch
	NOP | SMA 0x71 | SMA 0x72 | SMA 0x73 | SMA 0x74 | SMA 0x75 | \
	      SMA 0x76 | SMA 0x77 | SMA 0x78 | SMA 0x79 | SMA 0x7A | \
	      SMA 0x7B | SMA 0x7C | SMA 0x7D | SMA 0x7E | NOP
	JMP printcell

poke8:  TBF scratch
	NOP | SMA 0x81 | SMA 0x82 | SMA 0x83 | SMA 0x84 | SMA 0x85 | \
	      SMA 0x86 | SMA 0x87 | SMA 0x88 | SMA 0x89 | SMA 0x8A | \
	      SMA 0x8B | SMA 0x8C | SMA 0x8D | SMA 0x8E | NOP
	JMP printcell

poke9:  TBF scratch
	NOP | SMA 0x91 | SMA 0x92 | SMA 0x93 | SMA 0x94 | SMA 0x95 | \
	      SMA 0x96 | SMA 0x97 | SMA 0x98 | SMA 0x99 | SMA 0x9A | \
	      SMA 0x9B | SMA 0x9C | SMA 0x9D | SMA 0x9E | NOP
	JMP printcell

pokeA:  TBF scratch
	NOP | SMA 0xA1 | SMA 0xA2 | SMA 0xA3 | SMA 0xA4 | SMA 0xA5 | \
	      SMA 0xA6 | SMA 0xA7 | SMA 0xA8 | SMA 0xA9 | SMA 0xAA | \
	      SMA 0xAB | SMA 0xAC | SMA 0xAD | SMA 0xAE | NOP
	JMP printcell

pokeB:  TBF scratch
	NOP | SMA 0xB1 | SMA 0xB2 | SMA 0xB3 | SMA 0xB4 | SMA 0xB5 | \
	      SMA 0xB6 | SMA 0xB7 | SMA 0xB8 | SMA 0xB9 | SMA 0xBA | \
	      SMA 0xBB | SMA 0xBC | SMA 0xBD | SMA 0xBE | NOP
	JMP printcell

pokeC:  TBF scratch
	NOP | SMA 0xC1 | SMA 0xC2 | SMA 0xC3 | SMA 0xC4 | SMA 0xC5 | \
	      SMA 0xC6 | SMA 0xC7 | SMA 0xC8 | SMA 0xC9 | SMA 0xCA | \
	      SMA 0xCB | SMA 0xCC | SMA 0xCD | SMA 0xCE | NOP
	JMP printcell

pokeD:  TBF scratch
	NOP | SMA 0xD1 | SMA 0xD2 | SMA 0xD3 | SMA 0xD4 | SMA 0xD5 | \
	      SMA 0xD6 | SMA 0xD7 | SMA 0xD8 | SMA 0xD9 | SMA 0xDA | \
	      SMA 0xDB | SMA 0xDC | SMA 0xDD | SMA 0xDE | NOP
	JMP printcell

pokeE:  TBF scratch
	NOP | SMA 0xE1 | SMA 0xE2 | SMA 0xE3 | SMA 0xE4 | SMA 0xE5 | \
	      SMA 0xE6 | SMA 0xE7 | SMA 0xE8 | SMA 0xE9 | SMA 0xEA | \
	      SMA 0xEB | SMA 0xEC | SMA 0xED | SMA 0xEE | NOP

# Print out the cell on the UART
printcell:
	TAB scratch
	TBF scratch
	LCA 0x6 | LCA 0x3	# Print ` or 0 for 0 or 1
	LCB 0
	DAB 0
	LCA 2			# and a space
	DAB

# Ripple sum2 to sum1, sum3 to sum2. Move up to the next column.
ripplesums:
	LMA sum2
	SMA sum1
	LMA sum3
	SMA sum2
	LMA col
	SMIA col
	LMB col
	JMP calcstart

# At this point, we have completed the current row, printed out the
# results and stored the new values back into RAM. Send a newline.
rowsend:
	LCA 0
	LCB 10
	DAB 0
# Copy middle row to the top row
	SMB col
copymidtop:
	TBF scratch
	LMA mrc0 | LMA mrc1 | LMA mrc2 | LMA mrc3 | \
	LMA mrc4 | LMA mrc5 | LMA mrc6 | LMA mrc7 | \
	LMA mrc8 | LMA mrc9 | LMA mrcA | LMA mrcB | \
	LMA mrcC | LMA mrcD | LMA mrcE | LMA mrcF
	SMA trc0 | SMA trc1 | SMA trc2 | SMA trc3 | \
	SMA trc4 | SMA trc5 | SMA trc6 | SMA trc7 | \
	SMA trc8 | SMA trc9 | SMA trcA | SMA trcB | \
	SMA trcC | SMA trcD | SMA trcE | SMA trcF
	LCA 1
	ADDMB col
	JMP copymidtop | C NOP

# Copy the bottom row into the middle row
	LCB 0
	SMB col
copybotmid:
	TBF scratch
	LMA brc0 | LMA brc1 | LMA brc2 | LMA brc3 | \
	LMA brc4 | LMA brc5 | LMA brc6 | LMA brc7 | \
	LMA brc8 | LMA brc9 | LMA brcA | LMA brcB | \
	LMA brcC | LMA brcD | LMA brcE | LMA brcF
	SMA mrc0 | SMA mrc1 | SMA mrc2 | SMA mrc3 | \
	SMA mrc4 | SMA mrc5 | SMA mrc6 | SMA mrc7 | \
	SMA mrc8 | SMA mrc9 | SMA mrcA | SMA mrcB | \
	SMA mrcC | SMA mrcD | SMA mrcE | SMA mrcF
	LCA 1
	ADDMB col
	JMP copybotmid | C NOP

# Increment the rows and loop back
	LMA nextrow
	SMA row
	SMIA nextrow
	JNE fetchrow	# Start the next row of calculations if nextrow != 0
	LCA 0		# Else print out a blank line
	LCB 10
	DAB
	JMP start	# and start all over again
end:	JMP end

