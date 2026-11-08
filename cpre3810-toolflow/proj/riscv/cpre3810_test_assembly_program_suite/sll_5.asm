.text
.globl main
main:
    addi x5, x0, -1
    addi x6, x0, 1

    # -1 has all bits set, shifting adds a zero on the right
    # x10 should be 0xfffffffe
    sll x10, x5, x6

    addi x6, x0, 4
    # checks that all four new bits on the right are zero
    # x11 should be 0xfffffff0
    sll x11, x5, x6

    addi x6, x0, 31
    # only one of the original bits should be left
    # x12 should be 0x80000000
    sll x12, x5, x6

    # lui lets us set the top bit without extra instructions
    lui x5, 0x80000
    addi x6, x0, 1
    # the top bit falls off, it should not wrap around
    # x13 should be 0
    sll x13, x5, x6

    lui x5, 0x40000
    # shifting into the sign bit should still work
    # x14 should be 0x80000000, no overflow exception
    sll x14, x5, x6

    # lui and addi build an alternating bit pattern
    lui x5, 0x55555
    addi x5, x5, 0x555
    # checks individual bits move left, x15 = 0xaaaaaaaa
    sll x15, x5, x6
wfi