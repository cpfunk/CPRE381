# Test a maximum shift
addi t0, x0, 1
slli t0, t0, 31
srli t0, t0, 31 # Shift right 31 bit2
# Expected Output 0x00000001

wfi