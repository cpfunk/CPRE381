# bne Test 2: operand-value edge cases (sign, extremes, single-bit differences)
# Scoring convention (same for all tests):
#   x30 = PASS counter. Incremented if bne is behaving correctly
#   x31 = FAIL counter. Incremented if bne is behaving incorrectly
# Expected final state: x30 = 2, x31 = 0

# Case 1: 0x80000000 vs 0x7FFFFFFF -> branch should be taken. 
# Most-negative vs most-positive: every bit differs.
lui  x1, 0x80000        # x1 = 0x80000000
addi x2, x1, -1         # x2 = 0x7FFFFFFF
bne  x1, x2, c1_end
addi x31, x31, 1        # FAIL if reached
c1_end:

# Case 2: -1 vs -1 built two different ways -> branch should NOT be taken.
# Checks that equal all-ones values (0xFFFFFFFF) compare equal, including sign extension.
addi x3, x0, -1         # x3 = 0xFFFFFFFF
addi x4, x0, -2
addi x4, x4, 1          # x4 = 0xFFFFFFFF
bne  x3, x4, c2_end
addi x30, x30, 1        # PASS
c2_end:

# Case 3: 0x80000000 vs 0x80000001 -> branch should be taken.
# Values differ ONLY in bit 0. Catches comparators that ignore the LSB.
addi x5, x1, 1          # x5 = 0x80000001
bne  x1, x5, c3_end
addi x31, x31, 1        # FAIL if reached
c3_end:

# Case 4: 0x00000000 vs 0x80000000 -> branch should be taken.
# Values differ ONLY in bit 31. Catches comparators that ignore the MSB / sign bit.
bne  x0, x1, c4_end
addi x31, x31, 1        # FAIL if reached
c4_end:

# Case 5: 0x80000000 vs 0x80000000 (built separately) -> branch should NOT be taken.
# Equal values with the sign bit set, confirms equality works for "negative" numbers.
lui  x6, 0x80000        # x6 = 0x80000000
bne  x1, x6, c5_end
addi x30, x30, 1        # PASS
c5_end:

# Case 6: -1 vs 1 -> branch should be taken.
# Same magnitude, opposite sign. Catches comparators that use absolute value.
addi x7, x0, 1
bne  x3, x7, c6_end
addi x31, x31, 1        # FAIL if reached
c6_end:

# Case 7: 0x00001000 vs 0 -> branch should be taken.
# Difference only in a middle bit (bit 12) with all other bits zero
# Catches comparators that check only part of the 32 bits.
lui  x8, 1              # x8 = 0x00001000
bne  x8, x0, c7_end
addi x31, x31, 1        # FAIL if reached
c7_end:
wfi