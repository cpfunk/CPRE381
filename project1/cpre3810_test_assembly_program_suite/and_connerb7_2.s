# NET-ID: connerb7
# Stress testing "and"
# and_connerb7_2.s
# this file tests and involving pass throughs

# Case 1: make sure only selected bits get passed through

addi x5, x0, -1

lui  x6, 0x55555
addi x6, x6, 0x555

and x10, x6, x5 	# x10 = 0xFFFFFFFF and 0x5555555, should be all 5's

# Case 2: pass through only one bit

addi x7, x0, 8
and x11, x5, x7 	# x11 = 0x00000008 and 0xFFFFFFFF, should be = 0x00000008

# Case 3: pass through lower 8 bits

lui x28, 0x12345
addi x28, x28, 0x678
addi x29, x0, 0x0FF
and x12, x28, x29 	# x12 = 0x000000FF and 0x12345678, should be = 0x00000078
wfi