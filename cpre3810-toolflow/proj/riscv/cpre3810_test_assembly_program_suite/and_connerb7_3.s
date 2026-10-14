# NET-ID: connerb7
# Stress testing "and"
# and_connerb7_3.s
# this file tests and involving bit masking

# Case 1: Fill x1 with x12345678, and wipe the register
lui x5, 0x12345		# x5 = 0x12345678
addi x5, x5, 0x678

and x10, x0, x5		# x10 should = 0

# Case 2: Ommit lower 16 bits

lui x6, 0xFFFF0		# x6 = 0xFFFF0000

and x11, x6, x5		# x11 = 0x12340000

# Case 3: Alternate every 4 bits

lui x7, 0xF0F0F		# x7 = 0xFFFF0000
addi x7, x7, 0x0F0

and x12, x7, x5		# x12 = 0x10305070
wfi