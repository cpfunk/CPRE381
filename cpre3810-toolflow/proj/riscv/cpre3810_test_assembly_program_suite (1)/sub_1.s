.data

.text
.globl main

main:

    # sub test 0: common cases, zero/identity cases, and every sign combination.

    # --- Zero and identity cases -------------------------------------------

    # 0 - 0 using x0 for both sources. 
    sub  x1, x0, x0       # expect x1 = 0x00000000

    # x - 0 = x. Subtracting zero must pass rs1 through unchanged. 
    addi x2, x0, 25
    sub  x3, x2, x0       # expect x3 = 0x00000019

    # 0 - x = -x. This is exactly what the neg pseudoinstruction expands to.
    sub  x4, x0, x2       # expect x4 = 0xFFFFFFE7

    # x - y where x == y but they sit in different registers.
    addi x5, x0, 25
    sub  x6, x2, x5       # expect x6 = 0x00000000

    # --- Positive minus positive -------------------------------------------

    # 10 - 3 = 7, while 10 + 3 = 13
    addi x7, x0, 10
    addi x8, x0, 3
    sub  x9, x7, x8       # expect x9 = 0x00000007

    # Same operands swapped
    sub  x10, x8, x7      # expect x10 = 0xFFFFFFF9

    # --- Negative minus negative -------------------------------------------

    # -5 - (-3) = -2. 
    addi x11, x0, -5
    addi x12, x0, -3
    sub  x13, x11, x12    # expect x13 = 0xFFFFFFFE

    # -3 - (-5) = 2. Two negatives can produce a positive result.
    sub  x14, x12, x11    # expect x14 = 0x00000002

    # --- Mixed signs --------------------------------------------------------

    # 5 - (-3) = 8. Subtracting a negative must act like addition.
    addi x15, x0, 5
    sub  x16, x15, x12    # expect x16 = 0x00000008

    # -3 - 5 = -8. Negative minus positive moves further negative.
    sub  x17, x12, x15    # expect x17 = 0xFFFFFFF8

    # --- Widest operands addi can load --------------------------------------

    # 2047 - (-2048) = 4095. 
    addi x18, x0, 2047
    addi x19, x0, -2048
    sub  x20, x18, x19    # expect x20 = 0x00000FFF

    # Swapped: -2048 - 2047 = -4095
    sub  x21, x19, x18    # expect x21 = 0xFFFFF001

  end:

wfi