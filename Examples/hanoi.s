# Towers of Hanoi. (c) 2017 Warren Toomey, GPL3.
#
# The basic recursive algorithm is:
#
# movedisk(from,to)
# {
#   print("Move from ", from, " to ", to);
# }
# 
# movestack(size, from, to, spare)
# {
#   if (size==1) { movedisk(from, to); return; }
#   movestack(size-1, from, spare, to);
#   movedisk(from, to);
#   movestack(size-1, spare, to, from);
# }
# 
# and we can call it e.g. movestack(8, 1, 3, 2); for a stack of eight disks.
#
# Each movestack call requires 4 arguments. I've unrolled the recursion
# as it was hurting my brain trying to write a single function.
#
caller2: EQU 4
from2:   EQU 5
to2:     EQU 6
spare2:  EQU 7
caller3: EQU 8
from3:   EQU 9
to3:     EQU 10
spare3:  EQU 11
caller4: EQU 12
from4:   EQU 13
to4:     EQU 14
spare4:  EQU 15
caller5: EQU 16
from5:   EQU 17
to5:     EQU 18
spare5:  EQU 19
caller6: EQU 20
from6:   EQU 21
to6:     EQU 22
spare6:  EQU 23
caller7: EQU 24
from7:   EQU 25
to7:     EQU 26
spare7:  EQU 27
caller8: EQU 28
from8:   EQU 29
to8:     EQU 30
spare8:  EQU 31
caller9: EQU 32
from9:   EQU 33
to9:     EQU 34
spare9:  EQU 35

# Arguments for movedisk
diskcaller: EQU 50
fromdisk:   EQU 51
todisk:     EQU 52

# MAIN PROGRAM
	# Move everything from 1 to 3
	LCA 1
	SMA from9
	LCA 3
	SMA to9
	LCA 2
	SMA spare9
	LCA 0
	JMP movestack9
stackret10a:
stackret10b:
end: JMP end

# Caller-id in A
movedisk:
	SMA diskcaller	# Save caller
	LCA 0x4		# Print "Move "
	LCB 0xD
	DAB 0x6
	LCB 0xF
	DAB 0x7
	LCB 0x6
	DAB 0x6
	LCB 0x5
	DAB 0x2
	LCB 0x0
	DAB 0x3
	LMB fromdisk	# Print from digit
	DAB 0x2
	LCB 0x0		# Print " to "
	DAB 0x7
	LCB 0x4
	DAB 0x6
	LCB 0xf
	DAB 0x2
	LCB 0x0
	DAB 0x3
	LMB todisk	# Print to digit
	DAB 0x0
	LCB 0xA		# Newline
	DAB
	LMB diskcaller	# Return
	TBF
	JMP diskret0 | JMP diskret1 | JMP diskret2 | \
		JMP diskret3 | JMP diskret4 | JMP diskret5 | \
		JMP diskret6 | JMP diskret7 | JMP diskret8 | \
		JMP diskret9

movestack2:
	# This is effectively the base case for us.
	# Do movedisk(from, spare);
	SMA caller2
	LMA from2
	SMA fromdisk
	LMA spare2
	SMA todisk
	LCA 0
	JMP movedisk
diskret0:
	# Do movedisk(from,to);
	LMA from2
	SMA fromdisk
	LMA to2
	SMA todisk
	LCA 1
	JMP movedisk
diskret1:
	# Do movedisk(spare, to);
	LMA spare2
	SMA fromdisk
	LMA to2
	SMA todisk
	LCA 2
	JMP movedisk
diskret2:
	LMB caller2
	TBF
	JMP stackret3a | JMP stackret3b

movestack3:
	SMA caller3
	# Do movestack2(from, spare, to);
	LMA from3
	SMA from2
	LMA spare3
	SMA to2
	LMA to3
	SMA spare2
	LCA 0
	JMP movestack2
stackret3a:
	# Do movedisk(from, to);
	LMA from3
	SMA fromdisk
	LMA to3
	SMA todisk
	LCA 3
	JMP movedisk
diskret3:
	# Do movestack2(spare, to, from);
	LMA spare3
	SMA from2
	LMA to3
	SMA to2
	LMA from3
	SMA spare2
	LCA 1
	JMP movestack2
stackret3b:
	LMB caller3
	TBF
	JMP stackret4a | JMP stackret4b

movestack4:
	SMA caller4
	# Do movestack3(from, spare, to);
	LMA from4
	SMA from3
	LMA spare4
	SMA to3
	LMA to4
	SMA spare3
	LCA 0
	JMP movestack3
stackret4a:
	# Do movedisk(from, to);
	LMA from4
	SMA fromdisk
	LMA to4
	SMA todisk
	LCA 4
	JMP movedisk
diskret4:
	# Do movestack3(spare, to, from);
	LMA spare4
	SMA from3
	LMA to4
	SMA to3
	LMA from4
	SMA spare3
	LCA 1
	JMP movestack3
stackret4b:
	LMB caller4
	TBF
	JMP stackret5a | JMP stackret5b

movestack5:
	SMA caller5
	# Do movestack4(from, spare, to);
	LMA from5
	SMA from4
	LMA spare5
	SMA to4
	LMA to5
	SMA spare4
	LCA 0
	JMP movestack4
stackret5a:
	# Do movedisk(from, to);
	LMA from5
	SMA fromdisk
	LMA to5
	SMA todisk
	LCA 5
	JMP movedisk
diskret5:
	# Do movestack4(spare, to, from);
	LMA spare5
	SMA from4
	LMA to5
	SMA to4
	LMA from5
	SMA spare4
	LCA 1
	JMP movestack4
stackret5b:
	LMB caller5
	TBF
	JMP stackret6a | JMP stackret6b

movestack6:
	SMA caller6
	# Do movestack5(from, spare, to);
	LMA from6
	SMA from5
	LMA spare6
	SMA to5
	LMA to6
	SMA spare5
	LCA 0
	JMP movestack5
stackret6a:
	# Do movedisk(from, to);
	LMA from6
	SMA fromdisk
	LMA to6
	SMA todisk
	LCA 6
	JMP movedisk
diskret6:
	# Do movestack5(spare, to, from);
	LMA spare6
	SMA from5
	LMA to6
	SMA to5
	LMA from6
	SMA spare5
	LCA 1
	JMP movestack5
stackret6b:
	LMB caller6
	TBF
	JMP stackret7a | JMP stackret7b

movestack7:
	SMA caller7
	# Do movestack6(from, spare, to);
	LMA from7
	SMA from6
	LMA spare7
	SMA to6
	LMA to7
	SMA spare6
	LCA 0
	JMP movestack6
stackret7a:
	# Do movedisk(from, to);
	LMA from7
	SMA fromdisk
	LMA to7
	SMA todisk
	LCA 7
	JMP movedisk
diskret7:
	# Do movestack6(spare, to, from);
	LMA spare7
	SMA from6
	LMA to7
	SMA to6
	LMA from7
	SMA spare6
	LCA 1
	JMP movestack6
stackret7b:
	LMB caller7
	TBF
	JMP stackret8a | JMP stackret8b

movestack8:
	SMA caller8
	# Do movestack7(from, spare, to);
	LMA from8
	SMA from7
	LMA spare8
	SMA to7
	LMA to8
	SMA spare7
	LCA 0
	JMP movestack7
stackret8a:
	# Do movedisk(from, to);
	LMA from8
	SMA fromdisk
	LMA to8
	SMA todisk
	LCA 8
	JMP movedisk
diskret8:
	# Do movestack7(spare, to, from);
	LMA spare8
	SMA from7
	LMA to8
	SMA to7
	LMA from8
	SMA spare7
	LCA 1
	JMP movestack7
stackret8b:
	LMB caller8
	TBF
	JMP stackret9a | JMP stackret9b

movestack9:
	SMA caller9
	# Do movestack8(from, spare, to);
	LMA from9
	SMA from8
	LMA spare9
	SMA to8
	LMA to9
	SMA spare8
	LCA 0
	JMP movestack8
stackret9a:
	# Do movedisk(from, to);
	LMA from9
	SMA fromdisk
	LMA to9
	SMA todisk
	LCA 9
	JMP movedisk
diskret9:
	# Do movestack8(spare, to, from);
	LMA spare9
	SMA from8
	LMA to9
	SMA to8
	LMA from9
	SMA spare8
	LCA 1
	JMP movestack8
stackret9b:
	LMB caller9
	TBF
	JMP stackret10a | JMP stackret10b
