## Something of a benchmark utility for CrazySmallCPU
## (and in 22 instructions-- originally was 203..)
##
## It increments a 64-bit value in RAM from 1-16, but notices when the
## most significant digit changes-- and pings the screen when it does.
## The changes of MSD takes somewhat expotential time, making it a
## useful indicator of relative clock-speed ...maybe.
## --
## @Chris_J_Baird <chris.j.baird@gmail.com> 2017-Nov-6

HIGH:   EQU 254
TEMP:   EQU 253

init:
        LCA 1
        LCB 0
        SMB HIGH
initl:
        TBF
        ZEROM 1| ZEROM 2| ZEROM 3| ZEROM 4| ZEROM 5| ZEROM 6| ZEROM 7| ZEROM 8| ZEROM 9| ZEROM 10| ZEROM 11| ZEROM 12| ZEROM 13| ZEROM 14| ZEROM 15| ZEROM 16
        ADDMB TEMP
        JZC initl

        ##

main:
        LCA 0
        LCB 10
        DAB 0
main1:
        LCB 0
loop:
        TBF
        LMA 1| LMA 2| LMA 3| LMA 4| LMA 5| LMA 6| LMA 7| LMA 8| LMA 9| LMA 10| LMA 11| LMA 12| LMA 13| LMA 14| LMA 15| LMA 16
        SMIA 1| SMIA 2| SMIA 3| SMIA 4| SMIA 5| SMIA 6| SMIA 7| SMIA 8| SMIA 9| SMIA 10| SMIA 11| SMIA 12| SMIA 13| SMIA 14| SMIA 15| SMIA 16
        LCA 0| c JMP break
        ADDMB TEMP
        JMP loop

break:
        LMA HIGH
        SUBM TEMP
        SMB HIGH | zv JMP main1
        LCA 3
        DAB 0   # MSD
	LCA 2
	DAB 0   # space

printl:
        SMB TEMP
        TBF
        LMB 16| LMB 15| LMB 14| LMB 13| LMB 12| LMA 11| LMB 10| LMB 9| LMB 8| LMB 7| LMB 6| LMB 5| LMB 4| LMB 3| LMB 2| LMB 1
        TBF
        LCA 3 | NzV LCA 4 | NZ LCA 4
        NOP   | NzVc LCB 1 | NzVC LCB 2 | NZvc LCB 3 | NZvC LCB 4 | NZVc LCB 5 | NZVC LCB 6
        DMAB TEMP
        CLC
        LCA 1
        ADDMB TEMP
        JMP main | z JMP printl

##
