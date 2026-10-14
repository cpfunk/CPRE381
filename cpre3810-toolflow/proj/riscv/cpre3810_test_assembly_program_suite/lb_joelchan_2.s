.data
test_data:
    .byte 0x01      # simple positive (1)
    .byte 0xFE      # negative (-2 signed)
    .byte 0x00      # zero
    .byte 0x7F      # max positive byte (127)

.text
.globl main

main:

    # Test: Destination Registers, x0 Behavior, and Edge Cases

    # Setup base address
    lui  x1, %hi(test_data)
    addi x1, x1, %lo(test_data)

    # Test 1: Load into x0 — must not change hardwired zero register
    # Expected: x0 = 0x00000000
    lb x0, 0(x1)

    # Test 2: Verify x0 is still zero after write attempt
    # Expected: x2 = 0x00000000
    addi x2, x0, 0

    # Test 3: Same byte into two registers — verifies register file write-back
    # Expected: x3 = 0x00000001, x4 = 0x00000001
    lb x3, 0(x1)
    lb x4, 0(x1)

    # Test 4: Load into high register x20 — tests upper register indices
    # Expected: x20 = 0xFFFFFFFE (0xFE sign-extended)
    lb x20, 1(x1)

    # Test 5: Load into x31 — highest register, exercises all 5 rd bits
    # Expected: x31 = 0x0000007F
    lb x31, 3(x1)

    # Test 6: Load into x30 — another high register near boundary
    # Expected: x30 = 0x00000000
    lb x30, 2(x1)

    # Test 7: Use loaded value in arithmetic — confirms sign-extended result is correct
    # x20 = -2, adding 3 should give 1
    # Expected: x21 = 0x00000001
    addi x21, x20, 3

    # Test 8: Different base register — ensures lb works with any GPR as base
    # Expected: x11 = 0x00000001
    add  x10, x1, x0
    lb x11, 0(x10)

    # Test 9: Overwrite register — old value must be fully replaced
    # x3 was 0x00000001 from Test 3, now loading 0xFE
    # Expected: x3 = 0xFFFFFFFE
    lb x3, 1(x1)

  end:

wfi