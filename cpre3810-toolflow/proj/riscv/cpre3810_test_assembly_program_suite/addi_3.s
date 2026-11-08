.data

.text
.globl main

main:

    # Start Test

    # Try writing to x0 and make sure it always stays zero
    addi x0, x0, 5
    addi x1, x0, 7
    addi x0, x1, 3
    addi x2, x0, 0

    # Wrap around at 0xFFFFFFFF and 0 (signed overflow at 0x7FFFFFFF can't be reached with only addi)
    addi x3, x0, -1
    addi x4, x3, 1
    addi x5, x4, -1

    # Use the same register as source and destination over and over to check back-to-back dependencies
    addi x7, x0, 1
    addi x7, x7, 1
    addi x7, x7, 2
    addi x7, x7, 4
    addi x7, x7, 8
    addi x7, x7, 16

    # Chain results through different registers, each one using the one right before it
    addi x8, x0, 10
    addi x9, x8, 10
    addi x10, x9, 10
    addi x11, x10, 10

    # Source and destination the same with an immediate that cancels it back to zero
    addi x12, x0, 123
    addi x12, x12, -123

    # Use x31 to make sure the highest register number works
    addi x31, x0, -2048
    addi x31, x31, 2047
    addi x31, x31, 1

  end:

wfi