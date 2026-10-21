# bne Test 1: basic branch taken and branch not taken behavior
# Scoring convention (same for all tests):
#   x30 = PASS counter. Incremented if bne is behaving correctly
#   x31 = FAIL counter. Incremented if bne is behaving incorrectly
# Expected final state: x30 = 3, x31 = 0

# Initial register values for comparison
addi x1, x0, 5
addi x2, x0, 7

# Case 1: different values (5 != 7) -> branch should be taken. Most common case for bne.
bne  x1, x2, c1_end
addi x31, x31, 1        # FAIL if reached
c1_end:

# Case 2: operands swapped (7 != 5) -> branch should be taken. Another common case, checked to be safe
bne  x2, x1, c2_end
addi x31, x31, 1        # FAIL if reached
c2_end:

# Case 3: equal values (5 == 5) -> branch should NOT be taken. Core "false" case.
addi x3, x0, 5
bne  x1, x3, c3_end
addi x30, x30, 1        # PASS: only reached if not taken
c3_end:

# Case 4: x0 vs nonzero (0 != 5) -> branch should be taken. Tests the hardwired-zero register as an operand
bne  x0, x1, c4_end
addi x31, x31, 1        # FAIL if reached
c4_end:

# Case 5: x0 vs x0 (0 == 0) -> branch should NOT be taken. Smallest possible equal comparison.
bne  x0, x0, c5_end
addi x30, x30, 1        # PASS
c5_end:

# Case 6: same register for both operands (x1 == x1) -> branch should NOT be taken. Another variation of registers to check if bne is behaving properly
bne  x1, x1, c6_end
addi x30, x30, 1        # PASS
c6_end:
wfi