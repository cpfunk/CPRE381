.data
edge_values:
    .half 0x0000 # All zeros
    .half 0x0001 # Minimum positive
    .half 0x7FFF # Maximum positive signed halfword

.text
.globl main
main:

lui x1, 0x10010

# Test 1: Load all zeros - boundary case
lhu x2, 0(x1) # x2 = 0x00000000

# Test 2: Load minimum positive value - single LSB set
lhu x3, 2(x1) # x3 = 0x00000001

# Test 3: Load and use in arithmetic - verify zero-extension allows proper math
# 0x7FFF + 1 = 0x00008000 (if zero-extended correctly)
lhu x4, 4(x1) # x4 = 0x00007FFF
addi x5, x4, 1 # x5 = 0x00008000

end:

wfi