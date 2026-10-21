# Test 3:
# This test makes sure that the maximum shift properly functions

# set x6 register to 0x8124 8000
lui x6, 0x81248

addi x7, zero, 31
srl x8, x6, x7

# expected: x8 = 0x0000 0001

wfi