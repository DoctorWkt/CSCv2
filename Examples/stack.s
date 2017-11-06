# Attempt stack operations...
# All going correctly, should output "ONMLKJIHGFEDCBA@"
# --
# Chris Baird,, <cjb@brushtail.apana.org.au> 20171013

TEMP:       EQU 254

start:
            LCB 0

initstack:
            SMB TEMP
            TBA
            LCB 0
            JMP push
ret1:
            CLC
            LCA 1
            LMB TEMP
            ADDMB TEMP
            JZC initstack


            LCB 0
retrieve:
            SMB TEMP
            TBA
            LCB 0
            JMP pop
ret2:
            TAB
            LCA 4
            DAB

            CLC
            LCA 1
            LMB TEMP
            ADDMB TEMP
            JZC retrieve

end:        JMP end

###

stack0:     EQU 0
stack1:     EQU 1
stack2:     EQU 2
stack3:     EQU 3
stack4:     EQU 4
stack5:     EQU 5
stack6:     EQU 6
stack7:     EQU 7
stack8:     EQU 8
stack9:     EQU 9
stackA:     EQU 10
stackB:     EQU 11
stackC:     EQU 12
stackD:     EQU 13
stackE:     EQU 14
stackF:     EQU 15
TEMP1:      EQU 16
caller:     EQU 17

###

push:
            SMB caller
            SMA TEMP1

            # roll stack down
            LCB 0
pushloop:   SMB
            TBF
            LMA stack1 | LMA stack2 | LMA stack3 | \
		LMA stack4 | LMA stack5 | LMA stack6 | \
		LMA stack7 | LMA stack8 | LMA stack9 | \
		LMA stackA | LMA stackB | LMA stackC | \
		LMA stackD | LMA stackE | LMA stackF | \
		LMA TEMP1
            TBF
            SMA stack0 | SMA stack1 | SMA stack2 | \
		SMA stack3 | SMA stack4 | SMA stack5 | \
		SMA stack6 | SMA stack7 | SMA stack8 | \
		SMA stack9 | SMA stackA | SMA stackB | \
		SMA stackC | SMA stackD | SMA stackE | \
		SMA stackF
            CLC
            LCA 1
            ADDMB
            JZC pushloop

            LMB caller
            TBF
            JMP panic | nzvc JMP ret1

###

panic:      LCA 5
            LCB 0
            DAB
            JMP panic

###

pop:
            SMB caller

            # roll stack up...
            LCB 0
poploop:    SMB
            TBF
            LMA stackF | LMA stackE | LMA stackD | \
		LMA stackC | LMA stackB | LMA stackA | \
		LMA stack9 | LMA stack8 | LMA stack7 | \
		LMA stack6 | LMA stack5 | LMA stack4 | \
		LMA stack3 | LMA stack2 | LMA stack1 | \
		LMA stack0
            TBF
            SMA TEMP1  | SMA stackF | SMA stackE | \
		SMA stackD | SMA stackC | SMA stackB | \
		SMA stackA | SMA stack9 | SMA stack8 | \
		SMA stack7 | SMA stack6 | SMA stack5 | \
		SMA stack4 | SMA stack3 | SMA stack2 | \
		SMA stack1
            CLC
            LCA 1
            ADDMB
            JZC poploop
            LMA TEMP1

            LMB caller
            TBF
            JMP panic | nzvc JMP ret2

###
