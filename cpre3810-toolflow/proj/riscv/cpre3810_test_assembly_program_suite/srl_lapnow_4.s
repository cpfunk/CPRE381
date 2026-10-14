.data

.text
.globl main

main:

    # Test: shift by 31 (max), and 5-bit masking of rs2 (32 & 0x1F = 0)

    addi x1, x0, -1     # x1 = 0xFFFFFFFF
    addi x2, x0, 31     # shift amount = 31
    srl  x3, x1, x2     # 0xFFFFFFFF >> 31 = 1

    addi x4, x0, 1      # x4 = 1
    srl  x5, x4, x2     # 1 >> 31 = 0

    addi x6, x0, -1     # x6 = 0xFFFFFFFF
    addi x7, x0, 32     # 32 & 0x1F = 0, acts as shift-by-0
    srl  x8, x6, x7     # must equal 0xFFFFFFFF, not 0

  end:

wfi