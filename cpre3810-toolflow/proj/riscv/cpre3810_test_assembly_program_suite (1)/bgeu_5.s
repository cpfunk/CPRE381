.data

.text
.globl main

main:
    # Zero and high bit comparisons

    addi x1, x0, 0
    addi x2, x0, 0
    addi x10, x0, 0

    # T1: 0 >= 0
    # Minimum unsigned value must compare equal to itself
    bgeu x1, x2, test2
    addi x10, x0, 1

test2:
    # T2: 1 >= 0
    # Positive value must be greater than zero
    addi x1, x0, 1
    addi x2, x0, 0
    bgeu x1, x2, test3
    addi x10, x0, 2

test3:
    # T3: 0xFFFFFFFF >= 1
    # -1 has the largest unsigned 32-bit representation
    addi x1, x0, -1
    addi x2, x0, 1
    bgeu x1, x2, test4
    addi x10, x0, 3

test4:
    # Test 4: 1 >= 0xFFFFFFFF
    # Reversed operands, no branch
    addi x1, x0, 1
    addi x2, x0, -1
    bgeu x1, x2, fail4

fail4:
    addi x10, x0, 4

wfi