# slti test 5: Upper bits of rs1 matter
# The comparison must use all 32 bits of rs1. A comparator that only looks at the low bits (or low 12
# bits, matching the immediate width) gives wrong answers when the difference is in the upper bits.
# Instructions used: slti (under test) plus addi/lui.
# x2 holds the operand; each result goes in its own register starting at x10.

# 4101 < 10: low 12 bits are 5 (<10) but full value is 4101
lui x2, 0x1
addi x2, x2, 5
slti x10, x2, 10   # expect x10 = 0

# 0x00001000 < 1: low 12 bits are 0 (<1) but full value is 4096
lui x2, 0x1
slti x11, x2, 1   # expect x11 = 0

# 0x00010000 < 1: bit 16 set, low bits zero
lui x2, 0x10
slti x12, x2, 1   # expect x12 = 0

# 0x01000000 < 2047: bit 24 set, low bits zero
lui x2, 0x1000
slti x13, x2, 2047   # expect x13 = 0

# 0x12345678 < 2047: large positive, low 12 bits 0x678 < 2047
lui x2, 0x12345
addi x2, x2, 1656
slti x14, x2, 2047   # expect x14 = 0

# 0x12345678 < -1: large positive vs negative imm
lui x2, 0x12345
addi x2, x2, 1656
slti x15, x2, -1   # expect x15 = 0

# 0xEDCBA000 < 0: large negative with low 12 bits zero
lui x2, 0xEDCBA
slti x16, x2, 0   # expect x16 = 1

# 0xEDCBA000 < -2048: large negative vs most negative imm
lui x2, 0xEDCBA
slti x17, x2, -2048   # expect x17 = 1

# 0xFFFFF000 < -1: -4096 < -1 (differs only in upper bits)
lui x2, 0xFFFFF
slti x18, x2, -1   # expect x18 = 1

# 0xFFFFEFFF < -2048: -4097 just below -4096
lui x2, 0xFFFFF
addi x2, x2, -1
slti x19, x2, -2048   # expect x19 = 1

# 0x7FFFFFFF < -1: INT_MAX vs negative imm
lui x2, 0x80000
addi x2, x2, -1
slti x20, x2, -1   # expect x20 = 0

# 0x7FFFF800 < 2047: large positive, low 12 bits = 0x800
lui x2, 0x80000
addi x2, x2, -2048
slti x21, x2, 2047   # expect x21 = 0

wfi