# This test looks at the extremes of both operands: shamt = 0 and shamt = 31 (the
# smallest and largest legal shift amounts), source values at the edges of
# the 32-bit range (0, 1, all ones, sign bit only), and register x0.
#
# Why this has value: shamt = 0 and 31 are off-by-one boundaries; hardware that
# special-cases zero or decodes too few shamt bits fails here. slli has no
# overflow detection, so bits shifted past bit 31 must simply be discarded,
# with no sign preservation. Vacated low bits must be filled
# with zeros, and x0 must always read 0 and ignore writes.

.data

.text
.globl main

main:

    # Start Test

    # Build source values
    addi x1, x0, -1        # x1 = 0xFFFFFFFF: all ones
    lui  x2, 0x80000       # x2 = 0x80000000: only the sign bit set
    addi x3, x0, 1         # x3 = 0x00000001: single low bit
    lui  x4, 0x40000       # x4 = 0x40000000: largest power of two that is still a positive signed number
    addi x5, x0, -8        # x5 = 0xFFFFFFF8: small negative number (-8)

    # shamt = 0 (lower boundary of the shift amount)
    slli x6, x3, 0         # expect 0x00000001  shift by 0 should return the source unchanged
    slli x7, x1, 0         # expect 0xFFFFFFFF  each bit shouldn't change

    # shamt = 31 (upper boundary of the shift amount)
    slli x8, x3, 31        # expect 0x80000000  max shift: bit 0 moves to the sign position (bit 31)
    slli x9, x1, 31        # expect 0x80000000  max shift of all ones: only bit 0 survives, 31 bits must be zero-filled

    # Zero fill of the vacated low bits
    slli x10, x1, 1        # expect 0xFFFFFFFE  lowest bit must become 0, not 1
    slli x11, x1, 16       # expect 0xFFFF0000  whole low halfword must be zero-filled

    # Overflow: bits shifted out of bit 31 are discarded, no trap
    slli x12, x2, 1        # expect 0x00000000  sign bit shifted out: result is 0
    slli x13, x2, 31       # expect 0x00000000  sign bit shifted far out with max shamt: still 0
    slli x14, x4, 1        # expect 0x80000000  positive value becomes negative

    # Negative source
    slli x15, x5, 2        # expect 0xFFFFFFE0  -8 << 2 = -32: two's complement multiply works when no overflow occurs

    # x0 as source and destination
    slli x16, x0, 31       # expect 0x00000000  rs1 = x0 must always read as 0, whatever the shift amount
    slli x0,  x1, 5        # expect x0 = 0      write to x0 must be discarded (would give 0xFFFFFFE0)

  end:

wfi