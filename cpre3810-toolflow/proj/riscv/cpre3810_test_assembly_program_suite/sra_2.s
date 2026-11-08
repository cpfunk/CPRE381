.text
.globl main

main:
    # Test 2: Testing large positive and negative numbers

    # Tests shifting a large negative number
    lui  x1, 0x80000     # Set x1 to the smallest 32-bit signed num
    addi x2, x0, 1       # Shift: 1
    sra  x3, x1, x2      # Expected x3 = -1073741824

    # Tests shifting a larger positive number
    addi x4, x0, 100     # Pos num: 100
    addi x5, x0, 2       # Shift: 2
    sra  x6, x4, x5      # Expected x6 = 25

    # Tests shifting a larger negative number
    addi x7, x0, -100    # Neg num: -100
    sra  x8, x7, x5      # Expected x8 = -25

wfi