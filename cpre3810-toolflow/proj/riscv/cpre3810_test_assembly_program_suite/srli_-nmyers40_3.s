# Test a shift of zero
addi t0, x0, 0x123
srli t0, t0, 0 # Shift right 0 bit
# Expected Output 0x00000123

wfi