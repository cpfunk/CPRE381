.data
test_values:
    .half 0x1234 # Normal positive value
    .half 0xFFFF # All bits set
    .half 0x8000 # Sign bit set

.text
.globl main
main:

lui x1, 0x10010

# Test 1: Load normal positive value - basic functionality test
lhu x2, 0(x1) # x2 = 0x00001234

# Test 2: Load 0xFFFF - CRITICAL: must zero-extend to 0x0000FFFF not 0xFFFFFFFF
# This is the key difference between lhu (unsigned) and lh (signed)
lhu x3, 2(x1) # x3 = 0x0000FFFF

# Test 3: Load 0x8000 - sign bit set, must zero-extend to 0x00008000
# lh would sign-extend to 0xFFFF8000, proving lhu treats as unsigned
lhu x4, 4(x1) # x4 = 0x00008000

end:

wfi