
# HW04 - Question 2
# Test 3: lh
# Testing large offsets and special registers

.data
.align 2
edge_buffer:
    .half 0x8000          # smallest signed 16-bit value
    .space 2044           # leave space for testing large offsets
    .half 0x7FFF          # largest signed 16-bit value

.text
.globl main
main:
    lui x5, 0x10010       # starting address of data

    lh x6, 2046(x5)       # test largest positive aligned offset
    addi x7, x5, 2047     # move address forward 2047 bytes
    addi x7, x7, 1        # move forward 1 more byte
    lh x8, -2048(x7)      # test largest negative offset
    lh x9, -2(x7)         # go back 2 bytes

    addi x10, x5, 0       # copy starting address into x10
    lh x10, 0(x10)        # check if same register works for base and result
    lh x0, 2046(x5)       # x0 should always stay zero
    lh x31, 0(x5)         # test loading into the last register

wfi