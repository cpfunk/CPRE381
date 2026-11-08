.data

.text
.globl main

main:

    # Start Test
    # Test 1: basic xor cases with zero and identical operands

    addi x1, x0, 0      # x1 = 0
    addi x2, x0, 5      # x2 = 5 (0b0101)
    addi x3, x0, 3      # x3 = 3 (0b0011)

    xor x4, x0, x0      # expect x4 = 0, 0 ^ 0 = 0, simplest case for the ALU
    xor x5, x2, x1      # expect x5 = 5, x ^ 0 = x, zero should not change the value
    xor x6, x1, x2      # expect x6 = 5, same as above with operands swapped, checks rs1/rs2 order does not matter
    xor x7, x2, x2      # expect x7 = 0, x ^ x = 0, same register used for both operands
    xor x8, x2, x3      # expect x8 = 6, 0101 ^ 0011 = 0110, common case with mixed bits
    xor x0, x2, x3      # expect x0 = 0, writing to x0 must have no effect

  end:

wfi