# xori_kgoone_1.s  -- Test 1: basic behavior and register-usage corner cases


.text
    addi x5, x0, 240            # x5 = 0x000000F0, source value used by several cases

    # Case 1: xori with imm 0 is the identity (x ^ 0 = x). Basic sanity check
    xori x10, x5, 0             # expect 0x000000F0 (240)
    addi x30, x0, 240
    xor  x20, x10, x30          # expect 0

    # Case 2: xori with -1 (all-ones imm after sign extension) is bitwise NOT.
    xori x11, x5, -1            # expect 0xFFFFFF0F (-241)
    addi x30, x0, -241
    xor  x21, x11, x30          # expect 0

    # Case 3: x ^ x = 0. Imm 0xF0 equals the source low bits and upper bits are 0.
    xori x12, x5, 240           # expect 0x00000000
    addi x30, x0, 0
    xor  x22, x12, x30          # expect 0

    # Case 4: rs1 = x0. Checks that x0 is read as 0 and result = sign-extended imm.
    xori x13, x0, 0x123         # expect 0x00000123 (291)
    addi x30, x0, 291
    xor  x23, x13, x30          # expect 0

    # Case 5: partial overlap of bits (mixed 0/1 in both operands).
    xori x14, x5, 0x0FF         # 0xF0 ^ 0xFF = 0x0F (15)
    addi x30, x0, 15
    xor  x24, x14, x30          # expect 0

    # Case 6: rd == rs1 (destination same as source register).
    # Catches datapath bugs where write-back/read ordering is wrong.
    addi x15, x0, 240           # x15 = 0xF0
    xori x15, x15, 0x0FF        # expect 0x0F (15)
    addi x30, x0, 15
    xor  x25, x15, x30          # expect 0

    # Case 7: rd = x0 must be discarded. Writes to x0 must NOT change x0.
    xori x0, x5, -1             # would be 0xFFFFFF0F if (wrongly) written
    add  x16, x0, x0            # x16 = x0 + x0 ; expect 0
    xor  x26, x16, x0           # expect 0

    # Case 8: largest positive 12-bit immediate (0x7FF). Upper 21 bits of the
    # sign-extended imm are 0, so only the low 11 bits flip.
    xori x17, x5, 0x7FF         # 0x0F0 ^ 0x7FF = 0x70F (1807)
    addi x30, x0, 1807
    xor  x27, x17, x30          # expect 0

    # Case 9: most negative 12-bit immediate (-2048 = 0x800). Sign extends to
    # 0xFFFFF800, so upper 21 bits are flipped to 1s. Catches zero-extension bugs.
    xori x18, x5, -2048         # 0xFFFFF800 ^ 0xF0 = 0xFFFFF8F0 (-1808)
    addi x30, x0, -1808
    xor  x28, x18, x30          # expect 0

    # Case 10: source register must be unchanged by xori (only rd is written).
    addi x30, x0, 240
    xor  x29, x5, x30           # x5 should still be 0xF0 ; expect 0

wfi