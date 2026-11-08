# srl test 2: data value edge cases

.data

.text
.globl main

main:

    addi x2, x0, 1             # x2 = 1
    addi x3, x0, 4             # x3 = 4
    addi x4, x0, 16            # x4 = 16
    addi x5, x0, 31            # x5 = 31

    addi x6, x0, -1            # x6 = 0xffffffff
    srl  x7, x6, x2            # expect x7 = 0x7fffffff, verify zero fill, not sign fill (sra gives 0xffffffff)
    srl  x8, x6, x4            # expect x8 = 0x0000ffff, verify zero fill across upper half
    srl  x9, x6, x5            # expect x9 = 0x00000001, verify zero fill at max shift

    lui  x10, 0x80000
    addi x10, x10, -1          # x10 = 0x7fffffff
    srl  x11, x10, x2          # expect x11 = 0x3fffffff, verify max positive value

    addi x12, x0, 0
    srl  x13, x12, x3          # expect x13 = 0x00000000, verify zero stays zero

    addi x14, x0, 2047         # x14 = 0x7ff
    srl  x15, x14, x3          # expect x15 = 0x0000007f, verify common small positive case

    lui  x16, 0xaaaab          # 0xaaaab, not 0xaaaaa, since addi sign-extends
    addi x16, x16, -1366       # x16 = 0xaaaaaaaa
    srl  x17, x16, x2          # expect x17 = 0x55555555, verify every bit moves exactly one place

  end:

wfi