# fibminsky. Calculate some Fibonacci numbers and
# then print out a sine wave approximation.
# We start with Fibonacci. The three four-digit BCD
# numbers live at locations 1-4, 5-8 and 9-12.
# We add the 1-4 number to the 5-8 number and store
# the result in the 9-12 number.

	LCA 0		# Zero most of the first two nums
	SMA 1
	SMA 5
	SMA 2
	SMA 6
	SMA 3
	SMA 7
start:	LCA 1		# Initialise the first two nums
	SMA 4
	SMA 8
col4:	LMA 4		# Add the two digits together
	LMB 8
	DADDM 12
col3:	LMA 3		# Add the two digits together
	LMB 7
	DADDM 11
col2:	LMA 2		# Add the two digits together
	LMB 6
	DADDM 10
col1:	LMA 1		# Add the two digits together
	LMB 5
	DADDM 9
	JCS end		# Was a carry, so exit
	LMB 9		# Print out the sum
	LCA 3
	DAB 3
	LMB 10
	DAB 3
	LMB 11
	DAB 3
	LMB 12
	DAB 0
	LCB 10		# And a newline
	DAB
ripple:	LMA 8		# Ripple digits down
	SMA 4
	LMA 12
	SMA 8
	LMA 7
	SMA 3
	LMA 11
	SMA 7
	LMA 6
	SMA 2
	LMA 10
	SMA 6
	LMA 5
	SMA 1
	LMA 9
	SMA 5
	JMP col4
end:	

# Drawing a sine wave approximation
# using Minsky's circle algorithm
# Thanks to Chris Baird @Chris_J_Baird
# for the suggestion

xhi:	EQU 0
xlo:	EQU 1
yhi:	EQU 2
ylo:	EQU 3
tmplo:	EQU 4
tmphi:	EQU 5
ihi:	EQU 6
ilo:	EQU 7
spchi:  EQU 8
spclo:  EQU 9
starhi: EQU 10
starlo: EQU 11
nlhi:   EQU 12
nllo:   EQU 13

        LCA 0x2		# Initialise the ASCII characters:
        SMA spchi	# space, star, newline
        SMA starhi
        LCA 0x0
        SMA nlhi
        SMA spclo
        SMA yhi
        SMA ylo
        LCA 0xA
        SMA starlo
        SMA nllo

	LCA 0x3		# Set x to decimal 58, 0x36
	SMA xhi
	LCA 0x6
	SMA xlo		# y starts at zero

loop:	LMA xhi         # Store x>>4 into temp
        SMA tmplo
        LCA 0 | N LCA 0xf
        SMA tmphi

ok1:	CLC
	LMA ylo		# y= y - (x>>4), i.e. y= y - 1/16 * x
	LMB tmplo
	SUBM ylo
	LMA yhi
	LMB tmphi
	SUBM yhi

        LMA yhi         # Store y>>4 into temp
        SMA tmplo
        LCA 0 | N LCA 0xf
        SMA tmphi

ok2:	CLC
	LMA xlo		# x= x + (y>>4), i.e x= x + 1/16 * y
	LMB tmplo
	ADDM xlo
	LMA xhi
	LMB tmphi
	ADDM xhi

	CLC
	LCA 0xb		# Set i to x + 59, x + 0x3b
	LMB xlo
	ADDM ilo
	LCA 0x3
	LMB xhi
	ADDM ihi

ploop:  LMA spchi	# Print out a space
        LMB spclo
        DAB
	CLC
        LMA ilo		# Decrement i
	LCB 1
	SUBM ilo
        LMA ihi
        LCB 0
        SUBM ihi
        JNE ploop	# Loop back until it is zero
        LMA starhi
        LMB starlo	# Print "*\n"
        DAB
        LMA nlhi
        LMB nllo
        DAB
        JMP loop	# And loop back for the next iteration
