.data
.text
.globl main

main:
# TEST 1: Zero and Identity Properties

# Load values using only addi (no pseudoinstructions)
addi x1, x0, -1      # verify we can load all 1s (0xFFFFFFFF) into x1
addi x2, x0, 5       # load a standard test value (5) into x2
addi x4, x0, 0       # load 0 into x4

# Test Identity Property (Expected: 5)
and x3, x2, x1       # ensure ANDing with all 1s preserves the original value


# Test Zero Property (Expected: 0)
and x5, x2, x4      # attempt masking out a register entirely
wfi