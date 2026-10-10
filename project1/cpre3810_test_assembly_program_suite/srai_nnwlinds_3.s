.text
.globl main

main:

# Test 1: Shift large positive number
# Purpose: Ensure correct behavior with larger values.

lui x1, 1            # x1 = 4096
srai x2, x1, 4       # x2 should be 256

# Test 2: Shift negative number many bits
# Purpose: Verify sign bit remains 1 after large shift.

addi x3, x0, -1      # x3 = -1 (all bits = 1)
srai x4, x3, 10      # result should still be -1

# Test 3: Shift value with mixed bits
# Purpose: Confirm arithmetic behavior on nontrivial bit patterns.

addi x5, x0, -64
srai x6, x5, 3       # x6 should be -8
wfi