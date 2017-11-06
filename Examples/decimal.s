# CSCv2 decimal output
# --
# Chris Baird,, <cjb@brushtail.apana.org.au> 2017-10-12

binlo:      EQU 1
binhi:      EQU 2
digitO:     EQU 3
digitT:     EQU 4
digitH:     EQU 5
chomp:      EQU 7

countlo:    EQU 254
counthi:    EQU 253

#
#
#

start:
	    ZEROM countlo
	    ZEROM counthi
            LCA 0
            SMA countlo
            SMA counthi

loop:
	    LMA countlo
	    SMA binlo
	    LMA counthi
	    SMA binhi
	    JMP decimal

ret1:
	    LCA 3
	    LMB digitH
	    DAB 3
	    LMB digitT
	    DAB 3
	    LMB digitO
	    DAB 0
	    LCB 10
	    DAB

            LMA countlo
            LCB 1
	    ADDM countlo
	    LCB 0
	    LMA counthi
	    ADDMB counthi

	    LMA countlo
	    ORM
            NOP | z JMP loop
halt:       JMP halt

#
##
#

decimal:
	    ZEROM digitO
	    ZEROM digitT
	    ZEROM digitH

decloop:
	    LMA binlo	# test if binlo,hi == 0
	    LMB binhi
	    ORM
	    JMP ret1 | z JMP chompcheck

chompcheck:
	    LMB binlo
	    TBF
            # decide on how much to add/sub without making things
            # complicated with the BCD arith
            nzv LCA 1 | nzVc LCA 2 | nzVC LCA 3 | nZvc LCA 4 | nZvC LCA 5 | \
		nZVc LCA 6 | nZVC LCA 7 | Nzvc LCA 8 | NzvC LCA 9 | \
		NzVc LCA 9 | NzVC LCA 9 | NZ LCA 9
            # would also work, and keep things O(ln N)
            #LCA 1 | Vc LCA 2 | Zvc LCA 4 | zvc LCA 8

	    SMA chomp

	    # add chomp to output, as BCD
            LMB digitO
	    DADDM digitO
	    c JMP br1 | C LCA 0
	    LMB digitT
	    DADDM digitT
	    c JMP br1 | C LCA 0
	    LMB digitH
	    DADDM digitH

br1:
            # subtract chomp from bin
	    LMA binlo
	    LMB chomp
	    SUBM binlo
	    LMA binhi
	    LCB 0
	    SUBM binhi

	    JMP decloop


###
###
###

