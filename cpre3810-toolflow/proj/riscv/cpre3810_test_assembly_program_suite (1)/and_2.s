#
# and_bboldog_2.s
# Unit test for AND -- bit patterns and edge values
#
# Instructions used: and (under test), addi, lui (both above "and" in the list)
# There are no branches available above "and", so this test is not self-checking.
# After running, compare the register file to the EXPECTED values in the comments.
# Note: when the low 12 bits of a constant have bit 11 set, addi sign-extends,
# so lui is given (upper + 1) and addi a negative value to build the constant.
#

.data

.text
.globl main

main:

    # Start Test

    # Case 1: alternating bits 0xAAAAAAAA & 0x55555555 = 0
    # No bit position is 1 in both operands, so every bit must AND to 0.
    # Catches an AND that leaks bits from neighbouring positions.
    lui  x1, 0xAAAAB        # x1 = 0xAAAAB000
    addi x1, x1, -0x556     # x1 = 0xAAAAAAAA
    lui  x2, 0x55555        # x2 = 0x55555000
    addi x2, x2, 0x555      # x2 = 0x55555555
    and  x3, x1, x2         # EXPECTED x3 = 0x00000000

    # Case 2: alternating pattern ANDed with itself
    # Every other bit must stay set. Pairs with case 1 to check each bit
    # independently (case 1 checks 1&0 / 0&1, this checks 1&1 / 0&0).
    and  x4, x1, x1         # EXPECTED x4 = 0xAAAAAAAA

    # Case 3: partial overlap 0xF0F0F0F0 & 0xFF00FF00 = 0xF000F000
    # Nibble and byte patterns overlap in only some places, mixing all four
    # input combinations (1&1, 1&0, 0&1, 0&0) across the word.
    lui  x5, 0xF0F0F        # x5 = 0xF0F0F000
    addi x5, x5, 0x0F0      # x5 = 0xF0F0F0F0
    lui  x6, 0xFF010        # x6 = 0xFF010000
    addi x6, x6, -0x100     # x6 = 0xFF00FF00
    and  x7, x5, x6         # EXPECTED x7 = 0xF000F000

    # Case 4: MSB only, 0x80000000 & 0xFFFFFFFF = 0x80000000
    # The sign bit is the edge most likely to be mishandled (sign/overflow
    # logic shared with add). AND must keep it and nothing else.
    lui  x8, 0x80000        # x8 = 0x80000000 (most negative number)
    addi x9, x0, -1         # x9 = 0xFFFFFFFF
    and  x10, x8, x9        # EXPECTED x10 = 0x80000000

    # Case 5: 0x80000000 & 0x7FFFFFFF = 0
    # Most negative & most positive number share no bits. Unlike ADD, AND has
    # no overflow, so the result must be exactly 0.
    lui  x11, 0x80000       # x11 = 0x80000000
    addi x11, x11, -1       # x11 = 0x7FFFFFFF (most positive number)
    and  x12, x8, x11       # EXPECTED x12 = 0x00000000

    # Case 6: LSB, 1 & 0xFFFFFFFF = 1 and 1 & 0xFFFFFFFE = 0
    # Checks bit 0 alone, the other end of the word from case 4.
    addi x13, x0, 1         # x13 = 0x00000001
    addi x14, x0, -2        # x14 = 0xFFFFFFFE
    and  x15, x13, x9       # EXPECTED x15 = 0x00000001
    and  x16, x13, x14      # EXPECTED x16 = 0x00000000

    # Case 7: masking the low byte, 0x12345678 & 0xFF = 0x78
    # Very common real use of AND (extracting a field).
    lui  x17, 0x12345       # x17 = 0x12345000
    addi x17, x17, 0x678    # x17 = 0x12345678
    addi x18, x0, 0xFF      # x18 = 0x000000FF
    and  x19, x17, x18      # EXPECTED x19 = 0x00000078

    # Case 8: masking the upper 20 bits, 0x12345678 & 0xFFFFF000 = 0x12345000
    # Common mask (clearing the low 12 bits, e.g. page alignment).
    lui  x20, 0xFFFFF       # x20 = 0xFFFFF000
    and  x21, x17, x20      # EXPECTED x21 = 0x12345000

    # Case 9: two negative numbers, -8 & -12 = -16
    # 0xFFFFFFF8 & 0xFFFFFFF4 = 0xFFFFFFF0. Checks AND treats signed values as
    # plain bits (no sign handling should change the result).
    addi x22, x0, -8        # x22 = 0xFFFFFFF8
    addi x23, x0, -12       # x23 = 0xFFFFFFF4
    and  x24, x22, x23      # EXPECTED x24 = 0xFFFFFFF0

    # Case 10: upper half vs lower half
    # 0xFFFF0000 & 0x0000FFFF = 0 and 0xFFFF0000 & 0xFFFFFFFF = 0xFFFF0000.
    # Catches an ALU where one 16-bit half is wired wrong or missing.
    lui  x25, 0xFFFF0       # x25 = 0xFFFF0000
    lui  x26, 0x10          # x26 = 0x00010000
    addi x26, x26, -1       # x26 = 0x0000FFFF
    and  x27, x25, x26      # EXPECTED x27 = 0x00000000
    and  x28, x25, x9       # EXPECTED x28 = 0xFFFF0000

  end:

wfi