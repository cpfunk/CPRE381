.data

.text
.globl main

main:

    #Positive + negative operand yielding a positive result
    addi x1, x0, 40    # +40 into x1
    addi x2, x0, -15   # -15 into x2
    add  x3, x1, x2    #  40 + (-15) = 25 (0x00000019) in x3

    #Addition of two negative operands
    addi x4, x0, -20   #  -20 into x4
    addi x5, x0, -30   # -30 into x5
    add  x6, x4, x5    #  (-20) + (-30) = -50 (0xFFFFFFCE) in x6

    #inverse yielding zero (A + (-A) = 0)
    addi x7, x0, 120   #  +120 into x7
    addi x8, x0, -120  #  -120 into x8
    add  x9, x7, x8    #  120 + (-120) = 0 and carry propagation across all bits

wfi