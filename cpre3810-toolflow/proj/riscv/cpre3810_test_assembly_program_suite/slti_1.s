# slti test 1: Sign extension of immediate
# slti must SIGN-extend its 12-bit immediate. A design that zero-extends turns -1 into 4095 and
# gets every comparison against a negative immediate wrong typically returning 1 not 0.
# Instructions used: slti, addi and lui.
# x2 hold operand; each result goes in its own register starting at x10.

# x0 < -1: rs1 = x0 (0) vs -1; zero-extended imm (4095) would wrongly give 1
slti x10, x0, -1   # expect x10 = 0

# 1 < -1: small positive vs -1; zero-extended imm would give 1
addi x2, x0, 1
slti x11, x2, -1   # expect x11 = 0

# 5 < -1: another positive vs negative imm
addi x2, x0, 5
slti x12, x2, -1   # expect x12 = 0

# -1 < -1: equal negatives (also strict less-than)
addi x2, x0, -1
slti x13, x2, -1   # expect x13 = 0

# -2 < -1: negative below a negative imm must be true
addi x2, x0, -2
slti x14, x2, -1   # expect x14 = 1

# -100 < -1: larger negative magnitude, still true
addi x2, x0, -100
slti x15, x2, -1   # expect x15 = 1

# -1 < -2048: most negative imm; zero-extended 2048 would give 1
addi x2, x0, -1
slti x16, x2, -2048   # expect x16 = 0

# -2049 < -2048: just below the most negative imm
lui x2, 0xFFFFF
addi x2, x2, 2047
slti x17, x2, -2048   # expect x17 = 1

# x0 < 2047: largest positive imm must NOT be sign-flipped (bit 11 = 0)
slti x18, x0, 2047   # expect x18 = 1

# x0 < -2048: bit 11 set, all upper bits must become 1
slti x19, x0, -2048   # expect x19 = 0

wfi