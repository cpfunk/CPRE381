.text
.globl main

main:

# Test 1: Negative number shift
# Purpose: Verify arithmetic shift preserves the sign bit (fills with 1s).

addi x1, x0, -8      # x1 = -8
srai x2, x1, 1       # x2 should be -4

# Test 2: Larger shift on negative number
# Purpose: Check sign extension with larger shifts.

addi x3, x0, -32     # x3 = -32
srai x4, x3, 3       # x4 should be -4

# Test 3: Shift negative number by 0
# Purpose: Ensure no change occurs.

addi x5, x0, -15
srai x6, x5, 0       # x6 should remain -15
wfi