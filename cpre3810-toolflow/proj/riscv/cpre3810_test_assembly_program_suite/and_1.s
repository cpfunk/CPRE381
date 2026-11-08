#
# and_bboldog_1.s
# Unit test for AND -- basic / common cases and the x0 register
#
# Instructions used: and (under test), addi, lui (both above "and" in the list)
# There are no branches available above "and", so this test is not self-checking.
# After running, compare the register file to the EXPECTED values in the comments.
# Every result goes to its own register so all results can be inspected at the end.
#

.data

.text
.globl main

main:

    # Start Test

    # Case 1: 0 & 0 = 0
    # Most basic case. Confirms the ALU produces 0 and that the result is written
    # back (x3 starts nonzero in RARS, gp = 0x10008000, so a missing write shows up).
    addi x1, x0, 0          # x1 = 0x00000000
    addi x2, x0, 0          # x2 = 0x00000000
    and  x3, x1, x2         # EXPECTED x3 = 0x00000000

    # Case 2: 12 & 10 = 8   (1100 & 1010 = 1000)
    # Common case chosen so AND, OR, XOR and ADD all give DIFFERENT answers
    # (OR = 14, XOR = 6, ADD = 22). Catches a wrong ALU control / funct3 decode.
    addi x4, x0, 12         # x4 = 0x0000000C
    addi x5, x0, 10         # x5 = 0x0000000A
    and  x6, x4, x5         # EXPECTED x6 = 0x00000008

    # Case 3: all ones & all ones = all ones
    # Every bit position must produce a 1. Catches stuck-at-0 bits in the AND logic.
    addi x7, x0, -1         # x7 = 0xFFFFFFFF
    and  x8, x7, x7         # EXPECTED x8 = 0xFFFFFFFF

    # Case 4: value & x0 = 0  (x0 as rs2)
    # Reading x0 through the rs2 port must always give 0.
    and  x9, x7, x0         # EXPECTED x9 = 0x00000000

    # Case 5: x0 & value = 0  (x0 as rs1)
    # Same as case 4 but through the rs1 port.
    and  x10, x0, x7        # EXPECTED x10 = 0x00000000

    # Case 6: value & all ones = value  (identity)
    # A mixed, non-symmetric bit pattern must pass through unchanged.
    # Catches swapped/crossed bit lines.
    lui  x11, 0x12345       # x11 = 0x12345000
    addi x11, x11, 0x678    # x11 = 0x12345678
    and  x12, x11, x7       # EXPECTED x12 = 0x12345678

    # Case 7: all ones & value = value  (commutativity)
    # Same as case 6 with the operands swapped, so both operand paths into the
    # ALU are checked with a non-trivial value.
    and  x13, x7, x11       # EXPECTED x13 = 0x12345678

    # Case 8: writing x0 must be ignored
    # and x0 with all ones would make x0 = 0xFFFFFFFF if the register file lets
    # x0 be written. x14 then reads x0 back to expose that.
    and  x0, x7, x7         # x0 must stay 0x00000000
    and  x14, x0, x7        # EXPECTED x14 = 0x00000000 (would be 0xFFFFFFFF if x0 was written)

  end:

wfi