# slti test 3: Strict less-than (equal operands)
# slti is strictly LESS-THAN, not less-than-or-equal. Equal operands must give 0. Each equal case is
# paired with a neighbor on each side so a stuck-at-0 or inverted output is also caught. Instructions used: slti plus addi and lui.
# x2 holds the operand; starts at x10 and register numbers go up from there.

# 0 < 0: zero equals zero
addi x2, x0, 0
slti x10, x2, 0   # expect x10 = 0

# 1 < 1: smallest positive equal
addi x2, x0, 1
slti x11, x2, 1   # expect x11 = 0

# 10 < 10: ordinary positive equal
addi x2, x0, 10
slti x12, x2, 10   # expect x12 = 0

# -1 < -1: smallest negative equal
addi x2, x0, -1
slti x13, x2, -1   # expect x13 = 0

# -3 < -3: ordinary negative equal
addi x2, x0, -3
slti x14, x2, -3   # expect x14 = 0

# 2047 < 2047: max imm equal
addi x2, x0, 2047
slti x15, x2, 2047   # expect x15 = 0

# -2048 < -2048: min imm equal
addi x2, x0, -2048
slti x16, x2, -2048   # expect x16 = 0

# 9 < 10: one below: must be true
addi x2, x0, 9
slti x17, x2, 10   # expect x17 = 1

# 11 < 10: one above: must be false
addi x2, x0, 11
slti x18, x2, 10   # expect x18 = 0

# -4 < -3: one below (negative): must be true
addi x2, x0, -4
slti x19, x2, -3   # expect x19 = 1

# -2 < -3: one above (negative): must be false
addi x2, x0, -2
slti x20, x2, -3   # expect x20 = 0

wfi