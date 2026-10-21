# OR unit test 1: ordinary overlapping bit patterns and zero operands.
# This checks that OR preserves bits set in either source, including a source
# register containing zero. Expected: x3 = 0x0000001F, x4 = 0x00000015,
# x5 = 0x0000000A.

.data

.text
addi x1, x0, 21       # x1 = 0x00000015: alternating low-order bits.
addi x2, x0, 10       # x2 = 0x0000000A: the complementary low-order bits.
or   x3, x1, x2       # x3 = 0x0000001F: bits from both sources must appear.
or   x4, x1, x0       # x4 = 0x00000015: zero as rs2 must leave rs1 unchanged.
or   x5, x0, x2       # x5 = 0x0000000A: zero as rs1 must leave rs2 unchanged.

wfi