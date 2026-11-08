.data

.text
.globl main

main:

    # Start Test
    # Test 3: sign bit, negative numbers, and rd = rs register reuse

    lui  x1, 0x80000    # x1 = 0x80000000 (only the sign bit set, most negative number)
    lui  x2, 0x80000
    addi x2, x2, -1     # x2 = 0x7FFFFFFF (largest positive number)
    addi x3, x0, -1     # x3 = 0xFFFFFFFF (-1)
    addi x4, x0, 1      # x4 = 0x00000001

    xor x5, x1, x2      # expect x5 = 0xFFFFFFFF, top bit and lower 31 bits combine with no overlap
    xor x6, x1, x1      # expect x6 = 0x00000000, sign bit cancels out, checks bit 31 is handled
    xor x7, x3, x4      # expect x7 = 0xFFFFFFFE, only bit 0 flips, checks the lowest bit
    xor x8, x3, x1      # expect x8 = 0x7FFFFFFF, flips only the sign bit, no carry/overflow like add would have
    xor x4, x4, x3      # expect x4 = 0xFFFFFFFE, rd is the same as rs1, checks it reads before writing
    xor x31, x3, x0     # expect x31 = 0xFFFFFFFF, checks writing to the last register

  end:

wfi