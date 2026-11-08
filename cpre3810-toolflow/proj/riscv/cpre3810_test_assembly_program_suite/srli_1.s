# Shift by zero preserves the original value.
addi x1, x0, 21
srli x2, x1, 0       # Expected: 0x00000015

# Ordinary shift: 21 >> 1 = 10.
# Checks that a shifted-out 1 is discarded.
srli x3, x1, 1       # Expected: 0x0000000A

# Shift by multiple positions: 21 >> 2 = 5.
srli x4, x1, 2       # Expected: 0x00000005

# Shifting past all set bits must produce zero.
srli x5, x1, 5       # Expected: 0x00000000
wfi