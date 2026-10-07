.data
test_bytes:
    .byte 0x00      # zero
    .byte 0x41      # positive value (65)
    .byte 0x7F      # max positive signed byte (127)
    .byte 0x80      # min negative signed byte (-128)
    .byte 0xFF      # -1 as signed byte
    .byte 0xAB      # arbitrary negative (-85)

.text
.globl main

main:

    # Test Sign Extension and Basic Value Loading

    # Setup base address of test data
    lui  x1, %hi(test_bytes)
    addi x1, x1, %lo(test_bytes)

    # Test 1: Load 0x00 basic zero case, sign ext should produce all zeros
    # Expected: x2 = 0x00000000
    lb x2, 0(x1)

    # Test 2: Load 0x41 common positive byte, no sign ext effect (MSB=0)
    # Expected: x3 = 0x00000041
    lb x3, 1(x1)

    # Test 3: Load 0x7F max positive byte, boundary before sign ext activates
    # Expected: x4 = 0x0000007F
    lb x4, 2(x1)

    # Test 4: Load 0x80 min negative byte, sign ext must set upper 24 bits
    # Expected: x5 = 0xFFFFFF80
    lb x5, 3(x1)

    # Test 5: Load 0xFF all byte bits set, sign ext should fill all 32 bits
    # Expected: x6 = 0xFFFFFFFF
    lb x6, 4(x1)

    # Test 6: Load 0xAB arbitrary negative, confirms sign ext for general case
    # Expected: x7 = 0xFFFFFFAB
    lb x7, 5(x1)

  end:

wfi