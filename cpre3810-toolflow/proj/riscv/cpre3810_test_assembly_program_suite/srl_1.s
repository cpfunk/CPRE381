# Test 2:
# This test makes sure that only the 5 least significant bits are considered.

# set x4 register to 0x0000 0041

addi x4, zero, 0x041

srl x5, x4, x4

# expected x5 = 0x0000 0020


wfi