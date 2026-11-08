.text
.globl main

main:
    # Test 3: Testing different shift amounts

    addi x1, x0, -8      # Neg num: -8

    # Tests shifting a neg num by 1
    addi x2, x0, 1       # Shift: 1
    sra  x3, x1, x2      # Expected x3 = -4

    # Tests shifting by a large num
    addi x4, x0, 31      # Shift: 31
    sra  x5, x1, x4      # Expected x5 = -1

    # Tests shifting by 32
    addi x6, x0, 32      # Shift: 32
    sra  x7, x1, x6      # Expected x7 = -8


wfi