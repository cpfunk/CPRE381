
# HW04 - Question 2
# Test 2: lh
# Testing negative values, sign extension, and negative offsets

.data
.align 2
signed_data:
    .word 0xFFFF8000       # smallest negative value and -1
    .word 0xFFFE8001       # two more negative values
    .word 0x7FFFC000       # negative value and max positive

.text
.globl main
main:
    lui x5, 0x10010        # starting address of data

    lh x10, 0(x5)          # largest negative 16-bit value
    lh x11, 2(x5)          # loading -1
    lh x12, 4(x5)          # loading -32767
    lh x13, 6(x5)          # loading -2

    addi x6, x5, 8         # move address to the third word
    lh x14, -2(x6)         # test loading with a negative offset
    lh x15,  0(x6)         # load a negative number
    lh x16,  2(x6)         # largest positive 16-bit value
    lh x17, -8(x6)         # go back to the first word

wfi