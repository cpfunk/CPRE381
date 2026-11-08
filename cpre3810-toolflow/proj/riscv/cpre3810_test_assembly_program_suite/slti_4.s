# slti test 4: Immediate range boundaries
# The immediate is 12 bits, so it ranges from -2048 to 2047. Off-by-one errors in the immediate decode
# or comparator show up right at these limts. rs1 is a full 32-bit register and can be outside that range.
# Instructions used: slti plus addi and lui

# x2 holds the operand; each result goes in its own register starting at x10.

# 2046 < 2047: just below max imm
addi x2, x0, 2046
slti x10, x2, 2047   # expect x10 = 1

# 2047 < 2047: equal to max imm
addi x2, x0, 2047
slti x11, x2, 2047   # expect x11 = 0

# 2048 < 2047: rs1 just above the imm range
lui x2, 0x1
addi x2, x2, -2048
slti x12, x2, 2047   # expect x12 = 0

# 2049 < 2047: rs1 further above the range
lui x2, 0x1
addi x2, x2, -2047
slti x13, x2, 2047   # expect x13 = 0

# -2048 < 2047: min imm value vs max imm
addi x2, x0, -2048
slti x14, x2, 2047   # expect x14 = 1

# 2047 < -2048: max vs min imm, reversed
addi x2, x0, 2047
slti x15, x2, -2048   # expect x15 = 0

# 2048 < -2048: just outside the range vs min imm
lui x2, 0x1
addi x2, x2, -2048
slti x16, x2, -2048   # expect x16 = 0

# -2049 < -2048: rs1 just below min imm
lui x2, 0xFFFFF
addi x2, x2, 2047
slti x17, x2, -2048   # expect x17 = 1

# -2048 < -2048: equal to min imm
addi x2, x0, -2048
slti x18, x2, -2048   # expect x18 = 0

# -2047 < -2048: just above min imm
addi x2, x0, -2047
slti x19, x2, -2048   # expect x19 = 0

# -2049 < 2047: rs1 below the range vs max imm
lui x2, 0xFFFFF
addi x2, x2, 2047
slti x20, x2, 2047   # expect x20 = 1

wfi