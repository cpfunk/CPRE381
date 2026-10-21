# Crystal Gonzalez
# Cybersecurity Engineering
#
# xori test 1
#
# xori using zero, small positive 
# immediates, and an immediate of zero.

.text

# ------------------------------------------------------------
# Test 1: XOR zero with zero
# Expected: x1 = 0

addi x1, x0, 0
xori x1, x1, 0

# ------------------------------------------------------------
# Test 2: XOR zero with 1
# Expected: x2 = 1

addi x2, x0, 0
xori x2, x2, 1

# ------------------------------------------------------------
# Test 3: XOR zero with 7
# Expected: x3 = 7
addi x3, x0, 0
xori x3, x3, 7

# ------------------------------------------------------------
# Test 4: XOR a value with zero
# Expected: x4 = 15

addi x4, x0, 15
xori x4, x4, 0

# ------------------------------------------------------------
# Test 5: XOR a value with itself
# Expected: x5 = 0

addi x5, x0, 15
xori x5, x5, 15
wfi