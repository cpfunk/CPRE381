# srl test 3: register edge cases

.data

.text
.globl main

main:

    addi x1, x0, 256           # x1 = 0x100
    addi x2, x0, 4             # x2 = 4

    srl  x0, x1, x2            # expect x0 = 0, verify writes to x0 are ignored

    addi x3, x0, 5             # preload so a missing write is visible
    srl  x3, x0, x2            # expect x3 = 0, verify x0 reads as 0 for rs1

    srl  x4, x1, x0            # expect x4 = 0x100, verify x0 reads as 0 for rs2

    addi x5, x0, 256
    srl  x5, x5, x2            # expect x5 = 0x10, verify rs1 read before rd overwrite

    addi x6, x0, 4
    srl  x6, x1, x6            # expect x6 = 0x10, verify rs2 read before rd overwrite

    addi x7, x0, 1028          # x7 = 0x404, low 5 bits = 4
    srl  x8, x7, x7            # expect x8 = 0x40, verify same register for rs1 and rs2

    addi x9, x0, 1028          # x9 = 0x404
    srl  x9, x9, x9            # expect x9 = 0x40, verify same register for rd, rs1, rs2

    srl  x31, x1, x2           # expect x31 = 0x10, verify highest register writes

  end:

wfi