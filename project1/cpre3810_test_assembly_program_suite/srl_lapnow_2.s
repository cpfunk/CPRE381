.data

.text
.globl main

main:

    # Test: srl by 1 halves value; odd numbers lose LSB (not rounded)

    addi x1, x0, 8      # x1 = 8
    addi x2, x0, 1      # shift amount = 1
    srl  x3, x1, x2     # 8 >> 1 = 4

    addi x4, x0, 7      # x4 = 7 (odd, LSB = 1)
    srl  x5, x4, x2     # 7 >> 1 = 3, LSB dropped

  end:

wfi