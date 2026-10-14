.data
# Bytes chosen specifically to compare signed vs unsigned byte loads
# Yes this technically uses LB too, but the goal is to prove LBU zero-extends and does not behave like LB
lbu_test_bytes_2:
    .byte 0x80, 0xFF

.text
.globl main

main:
    # Load base address of test data 
    lui   x1, %hi(lbu_test_bytes_2)
    addi  x1, x1, %lo(lbu_test_bytes_2)

    # Preload destination registers 
    addi  x5, x0, -1
    addi  x6, x0, -1
    addi  x7, x0, -1
    addi  x8, x0, -1

    # LBU of 0x80.
    # Verifies unsigned load behavior
    # Expected x5 = 0x00000080
    lbu   x5, 0(x1)

    # LB of 0x80
    # Expected x7 = 0xFFFFFF80
    lb    x7, 0(x1)

    # LBU of 0xFF
    # Expected x6 = 0x000000FF
    lbu   x6, 1(x1)

    # LB of 0xFF
    # Expected x8 = 0xFFFFFFFF
    lb    x8, 1(x1)

end:

wfi