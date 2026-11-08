# slti test 2: Signed vs. unsigned comparison
# slti is a SIGNED comparison. A comparator that treats operands as unsigned gets every case where the sign bit of rs1 or the immediate is set backwards.
# Instructions used: slti addi and lui


# x2 holds the operand; x10 is first register.

# -1 < 1: 0xFFFFFFFF is -1 (signed); unsigned compare would give 0
addi x2, x0, -1
slti x10, x2, 1   # expect x10 = 1

# 0xFFFFFFFF < 0: all ones is negative, so less than zero
addi x2, x0, -1
slti x11, x2, 0   # expect x11 = 1

# -2048 < 0: 0xFFFFF800 is negative; unsigned compare would give 0
addi x2, x0, -2048
slti x12, x2, 0   # expect x12 = 1

# 0x80000000 < 0: INT_MIN is less than 0 (signed)
lui x2, 0x80000
slti x13, x2, 0   # expect x13 = 1

# 0x80000000 < -2048: INT_MIN vs most negative imm
lui x2, 0x80000
slti x14, x2, -2048   # expect x14 = 1

# 0x80000001 < 1: negative value with only bits 31 and 0 set
lui x2, 0x80000
addi x2, x2, 1
slti x15, x2, 1   # expect x15 = 1

# 1 < -1: positive vs negative imm (imm is 0xFFFFFFFF); unsigned compare would give 1
addi x2, x0, 1
slti x16, x2, -1   # expect x16 = 0

# 0x7FFFFFFF < -1: INT_MAX is not less than -1; unsigned compare would give 1
lui x2, 0x80000
addi x2, x2, -1
slti x17, x2, -1   # expect x17 = 0

# 0x7FFFFFFF < 2047: INT_MAX vs largest positive imm
lui x2, 0x80000
addi x2, x2, -1
slti x18, x2, 2047   # expect x18 = 0

# 0x7FFFFFFF < 0: INT_MAX vs zero
lui x2, 0x80000
addi x2, x2, -1
slti x19, x2, 0   # expect x19 = 0

wfi