# Print out 2E from locations 10 and 11
# (c) 2017 Warren Toomey, GPL3

        LCA  0x2			# Set up these locations
        SMA  10
        LCA  0xE
        SMA  11

# First digit
        LCA  7
        LMB  10
        ADDMB                           # B=B+7, flags set
        LMB  10 | zC NOP              # Reload the digit if 0-9
        LCA  3  | zC LCA  4
        DAB  7

# Second digit
	CLC				# Clear carry before the ADD
        LMB  11
        ADDMB                           # B=B+7, flags set
        LMB  11 | zC NOP              # Reload the digit if 0-9
        LCA  3  | zC LCA  4
        DAB  0

# Newline
        LCB 0xA
        DAB
end:    JMP end
