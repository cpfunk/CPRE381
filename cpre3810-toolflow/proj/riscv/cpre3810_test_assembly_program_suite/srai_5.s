.data

.text
.globl main

main:
    # Test 2: Negative values; arithmetic shift must replicate the sign bit.
    # ADDI provides small signed operands without pseudoinstructions.

    addi x1, x0, -64       # Source: -64 (0xFFFFFFC0).
    srai x2, x1, 1         # Expected x2 = -32 (0xFFFFFFE0); sign extends.
    srai x3, x1, 2         # Expected x3 = -16 (0xFFFFFFF0); sign extends.
    srai x4, x1, 6         # Expected x4 = -1 (0xFFFFFFFF); negative saturates to -1.
    srai x5, x1, 31        # Expected x5 = -1; maximum legal RV32 shift.

    addi x6, x0, -7        # Source: odd negative value.
    srai x7, x6, 1         # Expected x7 = -4; arithmetic shift rounds down, not toward zero.
    srai x8, x6, 2         # Expected x8 = -2; checks repeated sign extension.
    srai x9, x6, 3         # Expected x9 = -1; all remaining bits are sign bits.

    addi x10, x0, -1       # Source: all bits set.
    srai x11, x10, 1       # Expected x11 = -1; all-one pattern must remain all ones.
    srai x12, x10, 31      # Expected x12 = -1; maximum shift of all-one pattern.

wfi