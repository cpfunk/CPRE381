# Test 2: Verifies addition with negative integers (Two's Complement).
# Justification: Tests if the hardware correctly handles negative operands.
# and results that cross the zero boundary.

addi x1, x0, -20     # Load -20 into x1
addi x2, x0, 15      # Load 15 into x2
add  x3, x1, x2      # Test Case: -20 + 15. Expected result in x3 = -5 (0xFFFFFFFB)

addi x4, x0, -5      # Load -5 into x4
add  x5, x1, x4      # Test Case: -20 + (-5). Expected result in x5 = -25
wfi