.data

.text
.globl main

main:
    # Test 1: Positive values and common shift amounts.
    # ADDI initializes test operands; SRAI is the instruction under test.

    addi x1, x0, 64        # Source: 64 (0x00000040).
    srai x2, x1, 1         # Expected x2 = 32; common one-bit shift.
    srai x3, x1, 2         # Expected x3 = 16; checks multi-bit shift.
    srai x4, x1, 6         # Expected x4 = 1; shifts away all but one set bit.
    srai x5, x1, 7         # Expected x5 = 0; shifts away every set bit.

    addi x6, x0, 127       # Source: odd positive number.
    srai x7, x6, 1         # Expected x7 = 63; discarded low bit, round toward -infinity.
    srai x8, x6, 3         # Expected x8 = 15; checks several discarded low bits.

    srai x9, x0, 5         # Expected x9 = 0; shifting hardwired zero register.
    srai x10, x6, 0        # Expected x10 = 127; shift by zero must copy the input.

wfi