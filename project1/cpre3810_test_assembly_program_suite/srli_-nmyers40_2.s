# Test shifting a negative int. Because we are shifting logical and not arithmatic, the result should be zero extended.
addi t0, x0, -1 # Put 0xFFF in t0
slli t0, t0, 20 # Shift left 20 bits to make 0xFFF00000, a negative int
srli t0, t0, 4 # Shift right 4 bits
# Expected Output 0x0FFF0000

wfi