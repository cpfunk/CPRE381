.data

.text
.globl main

main:
    # Basic unsigned comparisons

    addi x1, x0, 0
    addi x2, x0, 0
    addi x10, x0, 0

    # T1: 5 >= 5
    # Equal, branch
    addi x1, x0, 5
    addi x2, x0, 5
    bgeu x1, x2, test2
    addi x10, x0, 1

test2:
    # T2: 10 >= 5
    # Greater, branch
    addi x1, x0, 10
    addi x2, x0, 5
    bgeu x1, x2, test3
    addi x10, x0, 2

test3:
    # T3: 3 >= 8
    # Smaller, no branch
    addi x1, x0, 3
    addi x2, x0, 8
    bgeu x1, x2, fail3

fail3:
    addi x10, x0, 3

wfi