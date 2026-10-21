.data

.text
.globl main

main:

    # Start Test

    # Load some basic constants (zero, small positive, small negative) to make sure addi works on simple values
    addi x1, x0, 0
    addi x2, x0, 1
    addi x3, x0, 5
    addi x4, x0, -1
    addi x5, x0, -5

    # Add positive and negative immediates to registers, including ones that cancel out to zero
    addi x6, x3, 10
    addi x7, x3, -10
    addi x8, x5, 5
    addi x9, x4, 1
    addi x10, x2, -1
    addi x11, x4, -1

    # Use an immediate of 0 to copy a positive and a negative value
    addi x12, x3, 0
    addi x13, x5, 0

    # Walk across the 8-bit boundaries (127, 128, 255, 256) to check carries
    addi x14, x0, 100
    addi x15, x14, 27
    addi x16, x15, 1
    addi x17, x16, 127
    addi x18, x17, 1

    # Subtract back down to zero and then one past it to get -1
    addi x19, x14, -100
    addi x20, x14, -101

  end:

wfi