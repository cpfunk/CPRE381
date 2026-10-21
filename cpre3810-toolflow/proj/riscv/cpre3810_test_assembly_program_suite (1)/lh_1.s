
# HW04 - Question 2
# Test 1: lh
# Testing basic loads, positive values, and different offsets

.data
.align 2
halfword_data:
    .word 0x00010000       # contains 0 and 1
    .word 0x7FFF1234       # regular value and max positive
    .word 0x00017F00       # two different halfwords

.text
.globl main
main:
    lui x5, 0x10010        # starting address of data

    lh x10,  0(x5)         # loading zero, should stay 0
    lh x11,  2(x5)         # loading 1
    lh x12,  4(x5)         # normal positive value (0x1234)
    lh x13,  6(x5)         # largest positive 16-bit value
    lh x14,  8(x5)         # checks lower half of the word
    lh x15, 10(x5)         # checks upper half of the word

wfi