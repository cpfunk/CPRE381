# xori_kgoone_2.s  -- Test 2: extreme/patterned rs1 values and immediate sign extension

.text
    # ---- Build test operands (lui/addi only) ----
    lui  x5, 0x80000            # x5 = 0x80000000  (most negative int / sign bit only)
    lui  x6, 0x80000
    addi x6, x6, -1             # x6 = 0x7FFFFFFF  (most positive int)
    addi x7, x0, -1             # x7 = 0xFFFFFFFF  (all ones)
    lui  x8, 0xAAAAB
    addi x8, x8, -1366          # x8 = 0xAAAAAAAA  (alternating 1010...)
    lui  x9, 0x55555
    addi x9, x9, 1365           # x9 = 0x55555555  (alternating 0101...)
    lui  x18, 0x12345
    addi x18, x18, 1656         # x18 = 0x12345678 (just different values)

    # Case 1: NOT of 0x80000000 -> 0x7FFFFFFF. Tests the MSB of rs1 (sign bit)
    # flipping 1 -> 0 and every other bit flipping 0 -> 1.
    xori x10, x5, -1            # expect 0x7FFFFFFF
    lui  x30, 0x80000
    addi x30, x30, -1
    xor  x20, x10, x30          # expect 0

    # Case 2: NOT of 0x7FFFFFFF -> 0x80000000. Mirror of case 1.
    xori x11, x6, -1            # expect 0x80000000
    lui  x30, 0x80000
    xor  x21, x11, x30          # expect 0

    # Case 3: NOT of all-ones -> 0. Checks every bit flips 1 -> 0.
    xori x12, x7, -1            # expect 0x00000000
    addi x30, x0, 0
    xor  x22, x12, x30          # expect 0

    # Case 4: all-ones ^ 0x7FF -> only the low 11 bits clear, but the sign-extended
    # upper bits of imm are 0 so upper 21 bits stay 1.  Result 0xFFFFF800.
    xori x13, x7, 0x7FF         # expect 0xFFFFF800 (-2048)
    addi x30, x0, -2048
    xor  x23, x13, x30          # expect 0

    # Case 5: alternating pattern 0xAAAAAAAA ^ 0x555 (positive imm, upper bits 0).
    # Low 12 bits: 0xAAA ^ 0x555 = 0xFFF ; upper bits unchanged -> 0xAAAAAFFF.
    xori x14, x8, 0x555         # expect 0xAAAAAFFF
    lui  x30, 0xAAAAB
    addi x30, x30, -1           # 0xAAAAB000 - 1 = 0xAAAAAFFF
    xor  x24, x14, x30          # expect 0

    # Case 6: SIGN-EXTENSION check. imm -1366 is 0xAAA in 12 bits, which sign-extends
    # to 0xFFFFFAAA. 0x55555555 ^ 0xFFFFFAAA = 0xAAAAAFFF.
    # If hardware zero-extended the imm the upper half would be 0x55555 instead.
    xori x15, x9, -1366         # expect 0xAAAAAFFF
    lui  x30, 0xAAAAB
    addi x30, x30, -1
    xor  x25, x15, x30          # expect 0

    # Case 7: sign bit set in rs1 and most-negative imm (-2048 -> 0xFFFFF800).
    # 0x80000000 ^ 0xFFFFF800 = 0x7FFFF800.
    xori x16, x5, -2048         # expect 0x7FFFF800
    lui  x30, 0x80000
    addi x30, x30, -2048        # 0x80000000 - 0x800 = 0x7FFFF800
    xor  x26, x16, x30          # expect 0

    # Case 8: arbitrary "typical" value with a positive imm. Only low bits change:
    # 0x678 ^ 0x7FF = 0x187 -> 0x12345187. Catches upper bits being corrupted.
    xori x17, x18, 0x7FF        # expect 0x12345187
    lui  x30, 0x12345
    addi x30, x30, 391          # 0x187 = 391
    xor  x27, x17, x30          # expect 0

    # Case 9: rs1 = x0 with imm -1 gives all ones (sign extension from zero source).
    xori x19, x0, -1            # expect 0xFFFFFFFF
    addi x30, x0, -1
    xor  x28, x19, x30          # expect 0

    # Case 10: operands used above were not modified (xori only writes rd).
    # x18 must still be 0x12345678.
    lui  x30, 0x12345
    addi x30, x30, 1656
    xor  x29, x18, x30          # expect 0

wfi