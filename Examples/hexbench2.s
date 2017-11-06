## Something of a benchmark utility for CrazySmallCPU
## (requires -bcd option to csim)
##
## It increments a 64-bit value in RAM from 1-16, but notices when the
## Most Significant Digit (MSNybble?) changes-- and pings the screen
## when it does. The changes of MSD takes somewhat expotential time,
## making it a useful indicator of relative clock-speed ...maybe.
## --
## @Chris_J_Baird <chris.j.baird@gmail.com> Oct 2017

HIGH:       EQU 254
TEMP:       EQU 255
TEMP1:	    EQU 253
TEMP2:      EQU 252

init:       LCA 0
            SMA 1
            SMA 2
            SMA 3
            SMA 4
            SMA 5
            SMA 6
            SMA 7
            SMA 8
            SMA 9
            SMA 10
            SMA 11
            SMA 12
            SMA 13
            SMA 14
            SMA 15
            SMA 16
            SMA HIGH

loop:       LCB 1
            LMA 1
            SMIA 1
            JMP incend | C LCB 2

            LMA 2
            SMIA 2
	    JMP incend | C LCB 3

            LMA 3
            SMIA 3
	    JMP incend | C LCB 4

            LMA 4
            SMIA 4
	    JMP incend | C LCB 5

            LMA 5
            SMIA 5
	    JMP incend | C LCB 6

            LMA 6
            SMIA 6
	    JMP incend | C LCB 7

            LMA 7
            SMIA 7
	    JMP incend | C LCB 8

            LMA 8
            SMIA 8
	    JMP incend | C LCB 9

            LMA 9
            SMIA 9
	    JMP incend | C LCB 10

            LMA 10
            SMIA 10
	    JMP incend | C LCB 11

            LMA 11
            SMIA 11
	    JMP incend | C LCB 12

            LMA 12
            SMIA 12
	    JMP incend | C LCB 13

            LMA 13
            SMIA 13
	    JMP incend | C LCB 14

            LMA 14
            SMIA 14
	    JMP incend | C LCB 15

            LMA 15
            SMIA 15
	    JMP incend | C LCB 16

            LMA 16
            SMIA 16


incend:     LMA HIGH
            SUBM TEMP
            JMP notbumped | Z SMB HIGH | C SMB HIGH

            LCA 3
            DAB 2       # MSD
	    LCB 0
	    DAB 0       # space


	    LMB 16
            SMB TEMP1
            Z JMP num16 | z DADDM
            z JMP num16 | Z LCA 7
            ADDMB
num16:      LCA 3 | C LCA 4
            DAB 0

	    LMB 15
            SMB TEMP1
            Z JMP num15 | z DADDM
            z JMP num15 | Z LCA 7
            ADDMB
num15:      LCA 3 | C LCA 4
            DAB 0

	    LMB 14
            SMB TEMP1
            Z JMP num14 | z DADDM
            z JMP num14 | Z LCA 7
            ADDMB
num14:      LCA 3 | C LCA 4
            DAB 0

	    LMB 13
            SMB TEMP1
            Z JMP num13 | z DADDM
            z JMP num13 | Z LCA 7
            ADDMB
num13:      LCA 3 | C LCA 4
            DAB 0

	    LMB 12
            SMB TEMP1
            Z JMP num12 | z DADDM
            z JMP num12 | Z LCA 7
            ADDMB
num12:      LCA 3 | C LCA 4
            DAB 0

	    LMB 11
            SMB TEMP1
            Z JMP num11 | z DADDM
            z JMP num11 | Z LCA 7
            ADDMB
num11:      LCA 3 | C LCA 4
            DAB 0

	    LMB 10
            SMB TEMP1
            Z JMP num10 | z DADDM
            z JMP num10 | Z LCA 7
            ADDMB
num10:      LCA 3 | C LCA 4
            DAB 0

	    LMB 9
            SMB TEMP1
            Z JMP num9 | z DADDM
            z JMP num9 | Z LCA 7
            ADDMB
num9:       LCA 3 | C LCA 4
            DAB 0

	    LMB 8
            SMB TEMP1
            Z JMP num8 | z DADDM
            z JMP num8 | Z LCA 7
            ADDMB
num8:       LCA 3 | C LCA 4
            DAB 0

	    LMB 7
            SMB TEMP1
            Z JMP num7 | z DADDM
            z JMP num7 | Z LCA 7
            ADDMB
num7:       LCA 3 | C LCA 4
            DAB 0

	    LMB 6
            SMB TEMP1
            Z JMP num6 | z DADDM
            z JMP num6 | Z LCA 7
            ADDMB
num6:       LCA 3 | C LCA 4
            DAB 0

	    LMB 5
            SMB TEMP1
            Z JMP num5 | z DADDM
            z JMP num5 | Z LCA 7
            ADDMB
num5:       LCA 3 | C LCA 4
            DAB 0

	    LMB 4
            SMB TEMP1
            Z JMP num4 | z DADDM
            z JMP num4 | Z LCA 7
            ADDMB
num4:       LCA 3 | C LCA 4
            DAB 0

	    LMB 3
            SMB TEMP1
            Z JMP num3 | z DADDM
            z JMP num3 | Z LCA 7
            ADDMB
num3:       LCA 3 | C LCA 4
            DAB 0

	    LMB 2
            SMB TEMP1
            Z JMP num2 | z DADDM
            z JMP num2 | Z LCA 7
            ADDMB
num2:       LCA 3 | C LCA 4
            DAB 0

	    LMB 1
            SMB TEMP1
            Z JMP num1 | z DADDM
            z JMP num1 | Z LCA 7
            ADDMB
num1:       LCA 3 | C LCA 4
            DAB 0

            LCB 10
            DAB

notbumped:
            JMP loop

##
