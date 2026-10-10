.data
# Test data chosen to cover the most important byte values for LBU
# 0x00  - all zeros
# 0x7F  - largest value with sign bit clear
# 0x80  - smallest value with sign bit set
# 0xFF  - all ones,  zero extension check
lbu_test_bytes_0:
    .byte 0x00, 0x7F, 0x80, 0xFF

.text
.globl main

main:
    # Load base address of test data without pseudoinstructions
    lui   x1, %hi(lbu_test_bytes_0)
    addi  x1, x1, %lo(lbu_test_bytes_0)

    # Preload destination registers with all ones
    # easy to catch a broken implementation that fails
    addi  x5, x0, -1
    addi  x6, x0, -1
    addi  x7, x0, -1
    addi  x8, x0, -1

    # Common case: load byte 0x00
    # Verifies normal byte read and that the result becomes 0x00000000
    lbu   x5, 0(x1)

    # Common case: load byte 0x7F
    # Verifies correct load when the byte's top bit is 0.
    lbu   x6, 1(x1)

    # Edge case: load byte 0x80
    # Verifies LBU zero extends rather than sign extends
    # Expected x7 = 0x00000080, not 0xFFFFFF80
    lbu   x7, 2(x1)

    # Edge case: load byte 0xFF
    # Verifies the strongest unsigned case
    # Expected x8 = 0x000000FF, not 0xFFFFFFFF
    lbu   x8, 3(x1)

end:

wfi