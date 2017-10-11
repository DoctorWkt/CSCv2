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
            xxxc JMP incend | xxxC LCB 2

            LMA 2
            SMIA 2
	    xxxc JMP incend | xxxC LCB 3

            LMA 3
            SMIA 3
	    xxxc JMP incend | xxxC LCB 4

            LMA 4
            SMIA 4
	    xxxc JMP incend | xxxC LCB 5

            LMA 5
            SMIA 5
	    xxxc JMP incend | xxxC LCB 6

            LMA 6
            SMIA 6
	    xxxc JMP incend | xxxC LCB 7

            LMA 7
            SMIA 7
	    xxxc JMP incend | xxxC LCB 8

            LMA 8
            SMIA 8
	    xxxc JMP incend | xxxC LCB 9

            LMA 9
            SMIA 9
	    xxxc JMP incend | xxxC LCB 10

            LMA 10
            SMIA 10
	    xxxc JMP incend | xxxC LCB 11

            LMA 11
            SMIA 11
	    xxxc JMP incend | xxxC LCB 12

            LMA 12
            SMIA 12
	    xxxc JMP incend | xxxC LCB 13

            LMA 13
            SMIA 13
	    xxxc JMP incend | xxxC LCB 14

            LMA 14
            SMIA 14
	    xxxc JMP incend | xxxC LCB 15

            LMA 15
            SMIA 15
	    xxxc JMP incend | xxxC LCB 16

            LMA 16
            SMIA 16


incend:     LMA HIGH
            SUBM TEMP
            JMP notbumped | xZxx SMB HIGH | xxxC SMB HIGH

            LCA 3
            DAB 2       # MSD
	    LCB 0
	    DAB 0       # space


	    LMB 16
            SMB TEMP1
            xZxx JMP num16 | xzxx DADDM
            xzxx JMP num16 | xZxx LCA 7
            ADDMB
num16:      xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 15
            SMB TEMP1
            xZxx JMP num15 | xzxx DADDM
            xzxx JMP num15 | xZxx LCA 7
            ADDMB
num15:      xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 14
            SMB TEMP1
            xZxx JMP num14 | xzxx DADDM
            xzxx JMP num14 | xZxx LCA 7
            ADDMB
num14:      xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 13
            SMB TEMP1
            xZxx JMP num13 | xzxx DADDM
            xzxx JMP num13 | xZxx LCA 7
            ADDMB
num13:      xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 12
            SMB TEMP1
            xZxx JMP num12 | xzxx DADDM
            xzxx JMP num12 | xZxx LCA 7
            ADDMB
num12:      xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 11
            SMB TEMP1
            xZxx JMP num11 | xzxx DADDM
            xzxx JMP num11 | xZxx LCA 7
            ADDMB
num11:      xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 10
            SMB TEMP1
            xZxx JMP num10 | xzxx DADDM
            xzxx JMP num10 | xZxx LCA 7
            ADDMB
num10:      xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 9
            SMB TEMP1
            xZxx JMP num9 | xzxx DADDM
            xzxx JMP num9 | xZxx LCA 7
            ADDMB
num9:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 8
            SMB TEMP1
            xZxx JMP num8 | xzxx DADDM
            xzxx JMP num8 | xZxx LCA 7
            ADDMB
num8:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 7
            SMB TEMP1
            xZxx JMP num7 | xzxx DADDM
            xzxx JMP num7 | xZxx LCA 7
            ADDMB
num7:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 6
            SMB TEMP1
            xZxx JMP num6 | xzxx DADDM
            xzxx JMP num6 | xZxx LCA 7
            ADDMB
num6:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 5
            SMB TEMP1
            xZxx JMP num5 | xzxx DADDM
            xzxx JMP num5 | xZxx LCA 7
            ADDMB
num5:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 4
            SMB TEMP1
            xZxx JMP num4 | xzxx DADDM
            xzxx JMP num4 | xZxx LCA 7
            ADDMB
num4:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 3
            SMB TEMP1
            xZxx JMP num3 | xzxx DADDM
            xzxx JMP num3 | xZxx LCA 7
            ADDMB
num3:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 2
            SMB TEMP1
            xZxx JMP num2 | xzxx DADDM
            xzxx JMP num2 | xZxx LCA 7
            ADDMB
num2:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

	    LMB 1
            SMB TEMP1
            xZxx JMP num1 | xzxx DADDM
            xzxx JMP num1 | xZxx LCA 7
            ADDMB
num1:       xxxc LCA 3 | xxxC LCA 4
            DAB 0

            LCB 10
            DAB

notbumped:
            JMP loop

##
