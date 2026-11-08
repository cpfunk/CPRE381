# Crystal Gonzalez
# Cybersecurity Engineering
#
# xori test 3
#
# bit pattern and edge cases
.text

# ------------------------------------------------------------
# Test 1: Largest positive immediate
# Expected: x1 = 2047 = 0x000007FF

addi x1, x0, 0
xori x1, x1, 2047

# ------------------------------------------------------------
# Test 2: Smallest negative immediate
# Expected: x2 = 0xFFFFF800
addi x2, x0, 0
xori x2, x2, -2048

# ------------------------------------------------------------
# Test 3: XOR only the least significant bit
# Expected: x3 = 8
#
# 9 = 1001
# 1 = 0001
#
# 1001 XOR 0001 = 1000

addi x3, x0, 9
xori x3, x3, 1

# ------------------------------------------------------------
# Test 4: XOR multiple low-order bits
# Expected: x4 = 3
#
# 12 = 1100
# 15 = 1111
#
# 1100 XOR 1111 = 0011

addi x4, x0, 12
xori x4, x4, 15

# ------------------------------------------------------------
# Test 5: XOR with zero
# Expected: x5 = 123

addi x5, x0, 123
xori x5, x5, 0
wfi