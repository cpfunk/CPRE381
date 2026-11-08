# Crystal Gonzalez
# Cybersecurity Engineering
#
# xori test 2
#
# test negative and sign extentsion 

.text

# ------------------------------------------------------------
# Test 1: xori with -1
# Expected: x1 = 0xFFFFFFFF

addi x1, x0, 0
xori x1, x1, -1

# ------------------------------------------------------------
# Test 2: XOR a positive value with -1
# Expected: x2 = bitwise NOT of 5
#            x2 = 0xFFFFFFFA

addi x2, x0, 5
xori x2, x2, -1

# ------------------------------------------------------------
# Test 3: XOR zero with -2048
# Expected: x3 = 0xFFFFF800

addi x3, x0, 0
xori x3, x3, -2048

# ------------------------------------------------------------
# Test 4: XOR zero with -1 using a different destination
# Expected: x4 = 0xFFFFFFFF

addi x4, x0, 0
xori x4, x4, -1

# ------------------------------------------------------------
# Test 5: XOR 1 with -1
# Expected: x5 = 0xFFFFFFFE

addi x5, x0, 1
xori x5, x5, -1
wfi