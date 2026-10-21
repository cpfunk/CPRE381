
.data
    .word 42
    .word 0x12345678
    .word 0

.text
.globl main

main:
    # Set x5 to the starting address of the data segment
    lui x5, 0x10010

    # Test 1: Verify lw correctly loads a positive integer
    # from a word-aligned memory address.
    lw x6, 0(x5)

    # Test 2: Verify lw preserves all 32 bits when
    # loading a hexadecimal value from memory.
    lw x7, 4(x5)

    # Test 3: Initialize x8 to a nonzero value, then
    # verify lw correctly overwrites it with zero.
    addi x8, x0, 99
    lw x8, 8(x5)

end:

wfi