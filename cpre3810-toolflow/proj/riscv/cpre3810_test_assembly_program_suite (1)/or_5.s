# OR unit test 2: sign bit and all-bit result.
# This checks bit 31 and every other bit by ORing 0x80000000 with 0x7FFFFFFF.
# Expected: x3 = 0xFFFFFFFF. The second OR also checks that x0 can be rs1
# while copying a value whose sign bit is set. Expected: x4 = 0x80000000.

.data

.text
lui  x1, 0x80000      # x1 = 0x80000000: only the sign bit is set.
addi x2, x1, -1       # x2 = 0x7FFFFFFF: every bit except the sign bit is set.
or   x3, x1, x2       # x3 = 0xFFFFFFFF: verifies the full 32-bit OR result.
or   x4, x0, x1       # x4 = 0x80000000: verifies the high bit is not lost.

wfi