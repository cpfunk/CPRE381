.text
.globl main
main:
    # addi is just setting up the values for sll
    addi x5, x0, 5
    addi x6, x0, 1

    # normal shift: 5 << 1 should give 10
    sll x10, x5, x6

    addi x6, x0, 4
    # shifting by a few bits, 5 << 4 = 80
    sll x11, x5, x6

    # shift by 0 should keep the original value
    sll x12, x5, x0

    # zero should stay zero even when shifted
    sll x13, x0, x6

    addi x5, x0, 1
    addi x6, x0, 31
    # biggest shift in RV32, moves the 1 to the top bit
    # x14 should be 0x80000000
    sll x14, x5, x6
wfi