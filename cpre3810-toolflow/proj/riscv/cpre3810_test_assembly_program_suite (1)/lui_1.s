.data

.text
.globl main

main:

    # Start Test
    # lui test 0: edge values of the immediate and overwriting rd
    # Uses only lui and addi

    # Edge values of the 20 bit immediate
    lui x1, 0x00000    # x1 = 0x00000000: smallest immediate, result must be zero
    lui x2, 0x00001    # x2 = 0x00001000: smallest nonzero immediate, checks the shift is 12
    lui x3, 0xFFFFF    # x3 = 0xFFFFF000: largest immediate, low 12 bits must stay zero
    lui x4, 0x80000    # x4 = 0x80000000: only the sign bit set
    lui x5, 0x7FFFF    # x5 = 0x7FFFF000: every bit but the sign bit
    lui x6, 0xAAAAA    # x6 = 0xAAAAA000: alternating bits, catches shorted neighbors
    lui x7, 0x55555    # x7 = 0x55555000: opposite alternating bits
    lui x8, 0x12345    # x8 = 0x12345000: common case, catches swapped nibbles

    # lui must replace the whole register and not merge with the old value
    addi x9, x0, -1    # x9 = 0xFFFFFFFF: fill with ones so old bits would show
    lui x9, 0x12345    # x9 = 0x12345000: low 12 bits must be cleared
    addi x10, x0, -1   # x10 = 0xFFFFFFFF: fill with ones again
    lui x10, 0x00000   # x10 = 0x00000000: zero immediate must clear every bit
    addi x11, x0, 2047 # x11 = 0x000007FF: set only the low 12 bits
    lui x11, 0xFFFFF   # x11 = 0xFFFFF000: old low bits must not remain

    # Repeated writes to the same register
    lui x12, 0xFFFFF   # x12 = 0xFFFFF000: set all upper bits
    lui x12, 0x00000   # x12 = 0x00000000: clear them on the next instruction
    lui x12, 0x80000   # x12 = 0x80000000: third write in a row still correct

  end:

wfi