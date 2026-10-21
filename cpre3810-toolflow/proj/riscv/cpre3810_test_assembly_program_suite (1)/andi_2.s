# edge cases for the immediate, plus x0
# x1 is all ones, so each result should match the immediate after it is
# stretched to 32 bits. Only addi and andi are used

.data

.text
.globl main

main:

    addi x1, x0, -1        # x1 = 0xFFFFFFFF (every bit is 1)

    # ANDing with 0 should clear every bit, including the top 20
    andi x2, x1, 0         # expect 0x00000000

    # -1 should become all ones
    andi x3, x1, -1        # expect 0xFFFFFFFF

    # 2047 is the largest positive immediate, so the top bits should be 0
    # This catches the top bits being wrongly filled with 1s
    andi x4, x1, 2047      # expect 0x000007FF

    # -2048 is the most negative immediate, and only its sign bit is set
    # That one bit should fill the top bits with 1s
    andi x5, x1, -2048     # expect 0xFFFFF800

    # With a mask of 1, only the lowest bit should be kept
    andi x6, x1, 1         # expect 0x00000001

    # x0 always reads as 0, so the result is 0 even with an all-ones mask
    andi x7, x0, -1        # expect 0x00000000

    # Writing to x0 should do nothing; it must stay 0
    andi x0, x1, -1        # expect x0 = 0x00000000

  end:

wfi