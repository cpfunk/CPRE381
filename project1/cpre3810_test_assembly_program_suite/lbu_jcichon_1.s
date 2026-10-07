.data
#  test address calculation with positive and negative offsets around the same base register
lbu_test_bytes_1:
    .byte 0xAA, 0xBB, 0xCC, 0xDD

.text
.globl main

main:
    # form address of the second byte so both negative and positive
    lui   x1, %hi(lbu_test_bytes_1)
    addi  x1, x1, %lo(lbu_test_bytes_1)
    addi  x1, x1, 1

    # Preload with nonzero values so a failed writeback is east to see
    addi  x5, x0, -1
    addi  x6, x0, -1
    addi  x7, x0, -1
    addi  x8, x0, -1

    # Negative offset case
    # Verifies offset sign handling and address = rs1 + imm
    # Expected x5 = 0x000000AA
    lbu   x5, -1(x1)

    # Zero offset case
    # Expected x6 = 0x000000BB
    lbu   x6, 0(x1)

    # Positive offset case
    # Expected x7 = 0x000000CC
    lbu   x7, 1(x1)

    # Larger positive offset case
    # Expected x8 = 0x000000DD
    lbu   x8, 2(x1)

end:

wfi