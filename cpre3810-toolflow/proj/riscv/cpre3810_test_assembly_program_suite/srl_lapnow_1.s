.data

.text
.globl main

main:

    # Test: srl by 0 must leave value unchanged (identity case)

    addi x1, x0, 1      # x1 = 1
    addi x2, x0, 0      # shift amount = 0
    srl  x3, x1, x2     # 1 >> 0 = 1

    addi x4, x0, -1     # x4 = 0xFFFFFFFF
    srl  x5, x4, x2     # 0xFFFFFFFF >> 0 = 0xFFFFFFFF

  end:

wfi