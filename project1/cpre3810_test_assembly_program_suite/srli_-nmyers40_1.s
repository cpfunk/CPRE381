# Test shifting multiple bits
addi t0, x0, 0x123
srli t0, t0, 4 # Shift right 4 bits
# Expected Output 0x00000012

wfi