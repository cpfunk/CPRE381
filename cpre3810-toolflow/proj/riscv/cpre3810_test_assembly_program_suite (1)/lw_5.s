
.data
    .word -1
    .word -2147483648
    .word -42
    .word 2147483647

.text
.globl main

main:
    # Initialize base address of data segment
    lui x5, 0x10010

    # Test 1: Load -1 to verify that lw preserves
    # an entire 32-bit word containing all 1 bits.
    lw x6, 0(x5)

    # Test 2: Load the minimum signed 32-bit integer.
    # Verifies that lw preserves the highest bit.
    lw x7, 4(x5)

    # Test 3: Load an ordinary negative integer.
    # Verifies that negative values retain their
    # correct two's complement representation.
    lw x8, 8(x5)

    # Test 4: Load the maximum signed 32-bit integer.
    # Verifies that lw correctly loads the upper
    # positive boundary of signed 32-bit values.
    lw x9, 12(x5)

end:

wfi