# Initialize all 32 bits to 1.
addi x1, x0, -1

# Checks zero fill instead of sign extension.
srli x2, x1, 1       # Expected: 0x7FFFFFFF

# Checks zero fill across several upper bits.
srli x3, x1, 4       # Expected: 0x0FFFFFFF

# Checks a shift across the half-word boundary.
srli x4, x1, 16      # Expected: 0x0000FFFF

# Maximum legal RV32 shift leaves only the original highest bit.
srli x5, x1, 31      # Expected: 0x00000001
wfi