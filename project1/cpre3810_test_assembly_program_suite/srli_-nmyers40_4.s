# Test a shift when all bits are zero
addi t0, x0, 0
srli t0, t0, 4 # Shift right 4 bits
# Expected Output 0x00000000

wfi