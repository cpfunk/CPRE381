# Test 1: Verifies basic addition and the additive identity of zero.
# Justification: Ensures the ALU performs standard arithmetic correctly.
# and that adding zero to a register does not alter its value (edge case).

addi x1, x0, 10      # Load 10 into x1 using addi (allowed instruction).
addi x2, x0, 5       # Load 5 into x2.
add  x3, x1, x2      # Test Case: 10 + 5. Expected result in x3 = 15.

addi x4, x0, 0       # Load 0 into x4.
add  x5, x1, x4      # Test Case: 10 + 0. Expected result in x5 = 10.
wfi