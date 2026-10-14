.data
.text
.globl main

main:
# TEST 3: Idempotence and Register Reuse

addi x1, x0, 15      # Load 15 (0b1111) into x1
addi x3, x0, 10      # Load 10 (0b1010) into x3
addi x4, x0, 14      # Load 14 (0b1110) into x4

# Test Idempotence (Expected: 15)
and x2, x1, x1       # verify the ALU functions correctly 
                     # when reading the exact same register for both operands

# Test Destination as Source (Expected: 10)
and x3, x3, x4       # attempt writing back to a register that is also being read

# Test Cascading Data/Forwarding (Expected: 10)
and x5, x3, x2       # common case of feeding instructions into one another
wfi