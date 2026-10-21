.data

.text
.globl main

main:

    # Start Test
    # Test 2: full 32-bit patterns, checks every bit of the xor works

    lui  x1, 0xAAAAB
    addi x1, x1, -1366  # x1 = 0xAAAAAAAA (alternating 1010...)
    lui  x2, 0x55555
    addi x2, x2, 1365   # x2 = 0x55555555 (alternating 0101...)
    addi x3, x0, -1     # x3 = 0xFFFFFFFF (all ones)

    xor x4, x1, x2      # expect x4 = 0xFFFFFFFF, every bit differs so every bit should be 1
    xor x5, x1, x1      # expect x5 = 0x00000000, every bit matches so every bit should be 0
    xor x6, x3, x3      # expect x6 = 0x00000000, all ones ^ all ones clears every bit
    xor x7, x1, x3      # expect x7 = 0x55555555, xor with all ones flips every bit (acts like NOT)
    xor x8, x2, x3      # expect x8 = 0xAAAAAAAA, same as above for the other pattern

  end:

wfi