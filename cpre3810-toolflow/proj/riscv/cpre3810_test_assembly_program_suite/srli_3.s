# Set only bit 31 to isolate movement of the highest bit.
lui  x1, 0x80000
srli x2, x1, 31      # Expected: 0x00000001

# Checks that source and destination can be the same register.
srli x1, x1, 1       # Expected: 0x40000000

# Start with a nonzero destination so a missing write is detectable.
addi x3, x0, 7

# Reading x0 must supply zero and overwrite the previous destination.
srli x3, x0, 8       # Expected: 0x00000000

# Attempt to write a nonzero result to x0; the write must be ignored.
srli x0, x1, 1       # Expected: x0 remains 0

# Observe x0 after the attempted write.
addi x4, x0, 0      # Expected: 0x00000000
wfi