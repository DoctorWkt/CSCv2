# Given two 8-bit numbers stored in xhi/xlo and yhi/ylo,
# perform an 8-bit multiply and store the 16-bit result
# in out3/out2/out1/out0.
# (C) 2017 Warren Toomey, GPL3

# The algorithm works but it probably could be optimised
# to avoid some of the loads when values are already in
# the registers, or could be made so with ADDMA or ADDMB.
#
# Effectively, we are doing:
#
# a= lmul(xlo,ylo)		# Note, hmuls cannot result in
# b= hmul(xlo,ylo)		# an 0xF result, so we can ++
# c= lmul(xhi,ylo)		# a hmul value with no carry
# d= hmul(xhi,ylo)
# e= lmul(xlo,yhi)
# f= hmul(xlo,yhi)
# g= lmul(xhi,yhi)
# h= hmul(xhi,yhi)
#
#       xhi xlo
#       yhi ylo
# =============
# c2 c1				# c2 and c1 are carries
#        b   a			# a, b, c, d, e, f, g, h are
#     d  c			# temp storage locations
#     f  e
#  h  g
# =============
#  ou ou ou  ou			# out3/out2/out1/out0 is
#  t3 t2 t1  t0			# the final result

xhi:	EQU 0
xlo:	EQU 1
yhi:	EQU 2
ylo:	EQU 3
out3:	EQU 4
out2:	EQU 5
out1:	EQU 6
out0:	EQU 7
c:	EQU 8
e:	EQU 9
f:	EQU 10
g:	EQU 11
caller: EQU 253
prnib:  EQU 254

			# Let's do F1 x 8B => 82DB
	LCA 0xf
	SMA xhi
	LCA 0x1
	SMA xlo
	LCA 0x8
	SMA yhi
	LCA 0xB
	SMA ylo

	LMA   xlo	# Do the eight 4-bit multiplies
	LMB   ylo
	LMULM out0	# out0= lmul(xlo, ylo)
	HMULM out1	# out1= hmul(xlo, ylo)
	LMA   xhi
	LMULM c		# c=    lmul(xhi, ylo)
	HMULM out2	# out2= hmul(xhi, ylo)
	LMA   xlo
	LMB   yhi
	LMULM e		# e=    lmul(xlo, yhi)
	HMULM f		# f=    hmul(xlo, yhi)
	LMA   xhi
	LMULM g		# g=    lmul(xhi, yhi)
	HMULM out3	# out3= hmul(xhi, yhi)

			# Start adding things up
	CLC
	LMA  out1
	LMB  c
	ADDM out1	# out1= out1 + c
			# Increment out2 if a carry
	NOP | C LMA  out2
	NOP | C SMIA out2

	CLC
	LMA  out1
	LMB  e
	ADDM out1	# out1= out1 + e
			# Increment f if a carry
	NOP | C LMA  f
	NOP | C SMIA f

	CLC
	LMA  out2
	LMB  f
	ADDM out2	# out2= out2 + f
			# Increment out3 if a carry
	NOP | C LMA  out3
	NOP | C SMIA out3

	CLC
	LMA  out2
	LMB  g
	ADDM out2	# out2= out2 + g
			# Increment out3 if a carry
	NOP | C LMA  out3
	NOP | C SMIA out3

			# out3/out2/out1/out0 are now done

			# Print out xhi/xlo
	LCA 0
	LMB xhi
	JMP prhex
ret0:
	LCA 1
	LMB xlo
	JMP prhex
ret1:
	LCA 2		# Print space
	LCB 0
	DAB
			# Print out yhi/ylo
	LCA 2
	LMB yhi
	JMP prhex
ret2:
	LCA 3
	LMB ylo
	JMP prhex
ret3:
	LCA 2		# Print space
	LCB 0
	DAB

	LCA 4		# Print out3
	LMB out3
	JMP prhex
ret4:
	LCA 5		# Print out2
	LMB out2
	JMP prhex
ret5:
	LCA 6		# Print out1
	LMB out1
	JMP prhex
ret6:
	LCA 7		# Print out0
	LMB out0
	JMP prhex
ret7:

	LCA 0		# Print newline
	LCB 10
	DAB

end:	JMP end

ret8:			# These labels never used
ret9:
ret10:
ret11:
ret12:
ret13:
ret14:
ret15:


# Function to print out a nibble in hex followed
# by a space. A holds the caller id. B holds the value
prhex:
        SMA caller                      # Save the caller
        SMB prnib                       # Temp copy of nibble
        CLC
        LCA 7
        ADDMB                           # B=B+7, flags set
        LMB prnib | C NOP               # Reload the digit if 0-9
        LCA 3  | C LCA  4
        DMAB caller                     # Print the digit, get caller
        TBF
        JMP ret0 | JMP ret1 | JMP ret2 | JMP ret3 |    \
         JMP ret4 | JMP ret5 | JMP ret6 | JMP ret7 |   \
         JMP ret8 | JMP ret9 | JMP ret10 | JMP ret11 | \
         JMP ret12 | JMP ret13 | JMP ret14 | JMP ret15
