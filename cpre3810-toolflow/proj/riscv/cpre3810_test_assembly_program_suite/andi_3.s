# Only lui, addi and andi are used

.data

.text
.globl main

main:

    # alternate 1s and 0s, so a bit that is stuck or in the wrong place shows up
    # The lui value is one higher (0xAAAAB) because the addi after it adds a negative number
    lui  x1, 0xAAAAB
    addi x1, x1, -1366       # x1 = 0xAAAAAAAA
    lui  x2, 0x55555
    addi x2, x2, 1365        # x2 = 0x55555555

    # The low bits never line up and the mask's top bits are 0, so everything clears
    andi x3, x1, 1365        # expect 0x00000000

    # The mask's top bits are 1s and its low bits match x1, so x1 comes through unchanged
    andi x4, x1, -1366       # expect 0xAAAAAAAA

    # The low bits match, but a positive mask should clear the top bits
    andi x5, x2, 1365        # expect 0x00000555

    # The top bits are kept and the low bits clear because they don't line up
    # This checks that the top and bottom parts are each handled correctly
    andi x6, x2, -1366       # expect 0x55555000

    lui  x7, 0x80000         # x7 = 0x80000000 (only the highest bit is set)

    # The highest bit should be kept when the mask is all ones
    andi x8, x7, -1          # expect 0x80000000

    # A positive mask should clear the highest bit like any other bit
    andi x9, x7, 2047        # expect 0x00000000

    lui  x10, 0x80000
    addi x10, x10, -1        # x10 = 0x7FFFFFFF (largest positive number)

    # Only the lowest 11 bits should clear
    andi x11, x10, -2048     # expect 0x7FFFF800

    # Only the lowest 11 bits should be kept
    andi x12, x10, 2047      # expect 0x000007FF

    lui  x13, 0x12345
    addi x13, x13, 1656      # x13 = 0x12345678 (an ordinary value)

    # Typical use: pull out one hex digit with a mask
    andi x14, x13, 240       # mask 0x0F0, expect 0x00000070

    # Typical use: round down to a multiple of 16, as you would with an address
    andi x15, x13, -16       # mask 0xFFFFFFF0, expect 0x12345670

  end:

wfi