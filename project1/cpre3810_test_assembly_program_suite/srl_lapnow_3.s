.data

.text
.globl main

main:

    # Test: srl fills with 0s even when MSB=1 (logical, not arithmetic)
    # Catches implementations that wrongly do sign-extension on shift

    addi x1, x0, -1     # x1 = 0xFFFFFFFF (sign bit = 1)
    addi x2, x0, 1      # shift amount = 1
    srl  x3, x1, x2     # 0xFFFFFFFF >> 1 = 0x7FFFFFFF, MSB must be 0

    addi x4, x0, -1     # x4 = 0xFFFFFFFF
    addi x5, x0, 4      # shift amount = 4
    srl  x6, x4, x5     # 0xFFFFFFFF >> 4 = 0x0FFFFFFF, top 4 bits = 0

  end:

wfi