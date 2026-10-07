# Clear registers
addi x1, x0, 0
addi x2, x0, 0
addi x3, x0, 0

# Expected result: all 0s
ori x1, x0, 0x000      	# x1 = 0 | 0 = 0

#Expected result: all 1s
ori x1, x0, 0x7FF	# x1 = 0 | 1 = 1

# Expected result: 0x0FF
addi x2, x0, 0x0F0   # x2 = 0x0F0
ori  x3, x2, 0x00F   # x3 = 0x0F0 | 0x00F = 0x0FF  (lower bits filled and upper bits unchanged)

# Expect result: 0x0FF
ori x3, x3, 0x000    # x3 = 0x0FF | 0x000 = 0x0FF (no change)

end:
wfi
