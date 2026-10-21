.data

.text
.globl main

main:

    # Start Test

    # Load the largest and smallest 12-bit immediates and -1 to check sign extension
    addi x1, x0, 2047
    addi x2, x0, -2048
    addi x3, x0, -1

    # Go just past the immediate range by adding or subtracting 1 from the extremes
    addi x4, x1, 1
    addi x5, x2, -1

    # Combine the max and min immediates with registers that already hold large values
    addi x6, x1, 2047
    addi x7, x2, -2048
    addi x8, x1, -2048
    addi x9, x2, 2047
    addi x10, x4, -2048

    # Keep adding the max immediate to build a value much bigger than 12 bits
    addi x11, x6, 2047
    addi x12, x11, 2047
    addi x13, x12, 2047
    addi x14, x13, 2047
    addi x15, x14, 2047
    addi x16, x15, 2047
    addi x17, x16, 8

    # Keep subtracting the min immediate to make sure the upper bits stay all ones
    addi x18, x7, -2048
    addi x19, x18, -2048

  end:

wfi