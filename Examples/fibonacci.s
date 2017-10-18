# Calculate the Fibonacci sequence of numbers
# up to 22 decimal digits
# (c) 2017 Warren Toomey, GPL3

zero:			# Zero most of the first two nums
	ZEROM 1
	ZEROM 23
	ZEROM 2
	ZEROM 24
	ZEROM 3
	ZEROM 25
	ZEROM 4
	ZEROM 26
	ZEROM 5
	ZEROM 27
	ZEROM 6
	ZEROM 28
	ZEROM 7
	ZEROM 29
	ZEROM 8
	ZEROM 30
	ZEROM 9
	ZEROM 31
	ZEROM 10
	ZEROM 32
	ZEROM 11
	ZEROM 33
	ZEROM 12
	ZEROM 34
	ZEROM 13
	ZEROM 35
	ZEROM 14
	ZEROM 36
	ZEROM 15
	ZEROM 37
	ZEROM 16
	ZEROM 38
	ZEROM 17
	ZEROM 39
	ZEROM 18
	ZEROM 40
	ZEROM 19
	ZEROM 41
	ZEROM 20
	ZEROM 42
	ZEROM 21
	ZEROM 43
start:	LCA 1		# Initialise the first two nums
	SMA 22
	SMA 44
col22:	LMA 22		# Add the two digits together
	LMB 44
	DADDM 66
col21:	LMA 21		# Add the two digits together
	LMB 43
	DADDM 65
col20:	LMA 20		# Add the two digits together
	LMB 42
	DADDM 64
col19:	LMA 19		# Add the two digits together
	LMB 41
	DADDM 63
col18:	LMA 18		# Add the two digits together
	LMB 40
	DADDM 62
col17:	LMA 17		# Add the two digits together
	LMB 39
	DADDM 61
col16:	LMA 16		# Add the two digits together
	LMB 38
	DADDM 60
col15:	LMA 15		# Add the two digits together
	LMB 37
	DADDM 59
col14:	LMA 14		# Add the two digits together
	LMB 36
	DADDM 58
col13:	LMA 13		# Add the two digits together
	LMB 35
	DADDM 57
col12:	LMA 12		# Add the two digits together
	LMB 34
	DADDM 56
col11:	LMA 11		# Add the two digits together
	LMB 33
	DADDM 55
col10:	LMA 10		# Add the two digits together
	LMB 32
	DADDM 54
col9:	LMA 9		# Add the two digits together
	LMB 31
	DADDM 53
col8:	LMA 8		# Add the two digits together
	LMB 30
	DADDM 52
col7:	LMA 7		# Add the two digits together
	LMB 29
	DADDM 51
col6:	LMA 6		# Add the two digits together
	LMB 28
	DADDM 50
col5:	LMA 5		# Add the two digits together
	LMB 27
	DADDM 49
col4:	LMA 4		# Add the two digits together
	LMB 26
	DADDM 48
col3:	LMA 3		# Add the two digits together
	LMB 25
	DADDM 47
col2:	LMA 2		# Add the two digits together
	LMB 24
	DADDM 46
col1:	LMA 1		# Add the two digits together
	LMB 23
	DADDM 45
	JCS end		# Was a carry, so exit
	LMB 45		# Print out the sum
	LCA 3
	DAB 3
	LMB 46
	DAB 3
	LMB 47
	DAB 3
	LMB 48
	DAB 3
	LMB 49
	DAB 3
	LMB 50
	DAB 3
	LMB 51
	DAB 3
	LMB 52
	DAB 3
	LMB 53
	DAB 3
	LMB 54
	DAB 3
	LMB 55
	DAB 3
	LMB 56
	DAB 3
	LMB 57
	DAB 3
	LMB 58
	DAB 3
	LMB 59
	DAB 3
	LMB 60
	DAB 3
	LMB 61
	DAB 3
	LMB 62
	DAB 3
	LMB 63
	DAB 3
	LMB 64
	DAB 3
	LMB 65
	DAB 3
	LMB 66
	DAB 3
	LCA 10		# And a newline
	SMA 255
	LMB 255
	LCA 0
	DAB 0
ripple:	LMA 44		# Ripple digits down
	SMA 22
	LMA 66
	SMA 44
	LMA 43
	SMA 21
	LMA 65
	SMA 43
	LMA 42
	SMA 20
	LMA 64
	SMA 42
	LMA 41
	SMA 19
	LMA 63
	SMA 41
	LMA 40
	SMA 18
	LMA 62
	SMA 40
	LMA 39
	SMA 17
	LMA 61
	SMA 39
	LMA 38
	SMA 16
	LMA 60
	SMA 38
	LMA 37
	SMA 15
	LMA 59
	SMA 37
	LMA 36
	SMA 14
	LMA 58
	SMA 36
	LMA 35
	SMA 13
	LMA 57
	SMA 35
	LMA 34
	SMA 12
	LMA 56
	SMA 34
	LMA 33
	SMA 11
	LMA 55
	SMA 33
	LMA 32
	SMA 10
	LMA 54
	SMA 32
	LMA 31
	SMA 9
	LMA 53
	SMA 31
	LMA 30
	SMA 8
	LMA 52
	SMA 30
	LMA 29
	SMA 7
	LMA 51
	SMA 29
	LMA 28
	SMA 6
	LMA 50
	SMA 28
	LMA 27
	SMA 5
	LMA 49
	SMA 27
	LMA 26
	SMA 4
	LMA 48
	SMA 26
	LMA 25
	SMA 3
	LMA 47
	SMA 25
	LMA 24
	SMA 2
	LMA 46
	SMA 24
	LMA 23
	SMA 1
	LMA 45
	SMA 23
	JMP col22
end:	JMP end
