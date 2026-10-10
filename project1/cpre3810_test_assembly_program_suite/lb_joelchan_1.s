.data
# 0xDEADBEEF little-endian: offset 0=0xEF, 1=0xBE, 2=0xAD, 3=0xDE
test_word:
    .word 0xDEADBEEF

# 0x12345678 little-endian: offset 0=0x78, 1=0x56, 2=0x34, 3=0x12
test_word2:
    .word 0x12345678

padding:
    .byte 0x00, 0x00, 0x00, 0x00
neg_target:
    .byte 0x55
    .byte 0xAA

.text
.globl main

main:

    # Test Byte Alignment, Offsets, and Address Computation

    # Setup base address of test_word
    lui  x1, %hi(test_word)
    addi x1, x1, %lo(test_word)

    # Test 1: Offset 0 of 0xDEADBEEF LSB in little-endian (0xEF)
    # Expected: x2 = 0xFFFFFFEF
    lb x2, 0(x1)

    # Test 2: Offset 1 non-aligned byte access (0xBE)
    # Expected: x3 = 0xFFFFFFBE
    lb x3, 1(x1)

    # Test 3: Offset 2 third byte of word (0xAD)
    # Expected: x4 = 0xFFFFFFAD
    lb x4, 2(x1)

    # Test 4: Offset 3 MSB of word (0xDE)
    # Expected: x5 = 0xFFFFFFDE
    lb x5, 3(x1)

    # Setup base address of test_word2
    lui  x6, %hi(test_word2)
    addi x6, x6, %lo(test_word2)

    # Test 5: Offset 0 of 0x12345678 positive byte (0x78, MSB=0)
    # Expected: x7 = 0x00000078
    lb x7, 0(x6)

    # Test 6: Offset 3 of 0x12345678 positive MSB byte (0x12)
    # Expected: x8 = 0x00000012
    lb x8, 3(x6)

    # Test 7: Larger positive offset cross from test_word to test_word2
    # Expected: x9 = 0x00000078 (same as test_word2 byte 0)
    lb x9, 4(x1)

    # Test 8: Negative offset tests base + negative immediate addressing
    lui  x10, %hi(neg_target)
    addi x10, x10, %lo(neg_target)
    # Load byte at -1 offset (last padding byte, 0x00)
    # Expected: x11 = 0x00000000
    lb x11, -1(x10)

    # Test 9: Adjacent bytes from same base 0x55 (pos) and 0xAA (neg)
    # Expected: x12 = 0x00000055, x13 = 0xFFFFFFAA
    lb x12, 0(x10)
    lb x13, 1(x10)

  end:

wfi