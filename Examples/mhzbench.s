# for testing how fast the board can be clocked..
# @ 1MHz completes a line in about 3.5 seconds
# @ 1.84 Mhz, ~2 seconds..
# --
# Chris Baird,, <cjb@brushtail.apana.org.au> 2017 Oct 30

VAL:    EQU 1
TIM0:   EQU 254
TIM1:   EQU 253
TIM2:   EQU 252

start:
        LCA 0
        SMA VAL
        LCB 10
        DAB

loop:
        LCA 4
        LMB VAL
        DMAB VAL

        TBF
        LCA 1    | LCA 2  | LCA 3  | LCA 4 \
        | LCA 5  | LCA 6  | LCA 7  | LCA 8 \
        | LCA 9  | LCA 10 | LCA 11 | LCA 12 \
        | LCA 13 | LCA 14 | LCA 15 | JMP start
        SMA VAL

loopz:  LCB 0

loop0:  TBF
        LCB 1    | LCB 2  | LCB 3  | LCB 4 \
        | LCB 5  | LCB 6  | LCB 7  | LCB 8 \
        | LCB 9  | LCB 10 | LCB 11 | LCB 12 \
        | LCB 13 | LCB 14 | LCB 15 | JMP loop1
        JMP loop0

loop1:  LMB TIM0
        TBF
        LCB 1    | LCB 2  | LCB 3  | LCB 4 \
        | LCB 5  | LCB 6  | LCB 7  | LCB 8 \
        | LCB 9  | LCB 10 | LCB 11 | LCB 12 \
        | LCB 13 | LCB 14 | LCB 15 | JMP loop2
        SMB TIM0
        JMP loopz

loop2:  ZEROM TIM0
        LMB TIM1
        TBF
        LCB 1    | LCB 2  | LCB 3  | LCB 4 \
        | LCB 5  | LCB 6  | LCB 7  | LCB 8 \
        | LCB 9  | LCB 10 | LCB 11 | LCB 12 \
        | LCB 13 | LCB 14 | LCB 15 | JMP loop3
        SMB TIM1
        JMP loopz

loop3:  ZEROM TIM1
        LMB TIM2
        TBF
        LCB 1    | LCB 2  | LCB 3  | LCB 4 \
        | LCB 5  | LCB 6  | LCB 7  | LCB 8 \
        | LCB 9  | LCB 10 | LCB 11 | LCB 12 \
        | LCB 13 | LCB 14 | LCB 15 | JMP loop4
        SMB TIM2
        JMP loopz

loop4:  ZEROM TIM2


        JMP loop

###
