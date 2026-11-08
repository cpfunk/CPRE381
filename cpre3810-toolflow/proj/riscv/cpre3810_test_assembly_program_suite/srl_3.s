# srl test 1: shift amount edge cases

.data

.text
.globl main

main:

    lui  x1, 0x80000           # x1 = 0x80000000
    addi x1, x1, 1             # x1 = 0x80000001, top and bottom bits set

    addi x2, x0, 0
    srl  x3, x1, x2            # expect x3 = 0x80000001, verify shift by 0 changes nothing
    addi x4, x0, 1
    srl  x5, x1, x4            # expect x5 = 0x40000000, verify basic shift by 1
    addi x6, x0, 4
    srl  x7, x1, x6            # expect x7 = 0x08000000, verify mid-range shift
    addi x8, x0, 16
    srl  x9, x1, x8            # expect x9 = 0x00008000, verify half-word boundary
    addi x10, x0, 31
    srl  x11, x1, x10          # expect x11 = 0x00000001, verify max shift
    addi x12, x0, 32
    srl  x13, x1, x12          # expect x13 = 0x80000001, verify only low 5 bits used (32 -> 0)
    addi x14, x0, 33
    srl  x15, x1, x14          # expect x15 = 0x40000000, verify upper bits ignored (33 -> 1)
    addi x16, x0, -1
    srl  x17, x1, x16          # expect x17 = 0x00000001, verify negative amount uses low 5 bits (-1 -> 31)
    addi x18, x0, 64
    srl  x19, x1, x18          # expect x19 = 0x80000001, verify 6-bit masking not used (64 -> 0)

  end:

wfi