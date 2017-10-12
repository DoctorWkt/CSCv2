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
            nzvc LMA stack1 | nzvC LMA stack2 | nzVc LMA stack3 | nzVC LMA stack4 | nZvc LMA stack5 | nZvC LMA stack6 | nZVc LMA stack7 | nZVC LMA stack8 | Nzvc LMA stack9 | NzvC LMA stackA |	NzVc LMA stackB | NzVC LMA stackC | NZvc LMA stackD | NZvC LMA stackE | NZVc LMA stackF | NZVC LMA TEMP1
            TBF
            nzvc SMA stack0 | nzvC SMA stack1 | nzVc SMA stack2 | nzVC SMA stack3 | nZvc SMA stack4 | nZvC SMA stack5 | nZVc SMA stack6 | nZVC SMA stack7 | Nzvc SMA stack8 | NzvC SMA stack9 |	NzVc SMA stackA | NzVC SMA stackB | NZvc SMA stackC | NZvC SMA stackD | NZVc SMA stackE | NZVC SMA stackF
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
            nzvc LMA stackF | nzvC LMA stackE | nzVc LMA stackD | nzVC LMA stackC | nZvc LMA stackB | nZvC LMA stackA | nZVc LMA stack9 | nZVC LMA stack8 | Nzvc LMA stack7 | NzvC LMA stack6 | NzVc LMA stack5 | NzVC LMA stack4 | NZvc LMA stack3 | NZvC LMA stack2 | NZVc LMA stack1 | NZVC LMA stack0
            TBF
            nzvc SMA TEMP1  | nzvC SMA stackF | nzVc SMA stackE | nzVC SMA stackD | nZvc SMA stackC | nZvC SMA stackB | nZVc SMA stackA | nZVC SMA stack9 | Nzvc SMA stack8 | NzvC SMA stack7 | NzVc SMA stack6 | NzVC SMA stack5 | NZvc SMA stack4 | NZvC SMA stack3 | NZVc SMA stack2 | NZVC SMA stack1
            CLC
            LCA 1
            ADDMB
            JZC poploop
            LMA TEMP1

            LMB caller
            TBF
            JMP panic | nzvc JMP ret2

###
