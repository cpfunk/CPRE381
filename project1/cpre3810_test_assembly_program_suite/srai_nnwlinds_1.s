.text
.globl main

main:

# Test 1: Basic arithmetic shift with a positive number
# Purpose: Verify that shifting a positive value fills with 0s.

addi x1, x0, 64      # x1 = 64
srai x2, x1, 2       # x2 should be 16

# Test 2: Shift by 1
# Purpose: Verify common case shift by one bit.

addi x3, x0, 10      # x3 = 10
srai x4, x3, 1       # x4 should be 5

# Test 3: Shift by 0
# Purpose: Edge case; value should remain unchanged.

addi x5, x0, 25      # x5 = 25
srai x6, x5, 0       # x6 should remain 25
wfi