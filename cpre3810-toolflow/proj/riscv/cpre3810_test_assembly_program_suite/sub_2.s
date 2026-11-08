.data

.text
.globl main

main:

    # sub test 1: signed overflow and the extremes of the 32-bit range.

    # Operands
    lui  x1, 0x80000      # x1 = 0x80000000  most negative value (INT_MIN)
    lui  x2, 0x80000
    addi x2, x2, -1       # x2 = 0x7FFFFFFF  most positive value (INT_MAX)
    addi x3, x0, 1        # x3 = 1
    addi x4, x0, -1       # x4 = 0xFFFFFFFF  (-1)

    # --- Cases that overflow (result must wrap) ----------------------------

    # INT_MIN - 1: one step below the most negative value. Wraps to INT_MAX.
    sub  x5, x1, x3       # expect x5 = 0x7FFFFFFF

    # INT_MAX - (-1): one step above the most positive value. Wraps to
    # INT_MIN. Smallest possible positive overflow.
    sub  x6, x2, x4       # expect x6 = 0x80000000

    # 0 - INT_MIN: negating the most negative number.
    sub  x7, x0, x1       # expect x7 = 0x80000000

    # INT_MAX - INT_MIN: the largest overflow possible (true answer 2^32 - 1).
    sub  x8, x2, x1       # expect x8 = 0xFFFFFFFF

    # INT_MIN - INT_MAX: the largest negative overflow possible.
    sub  x9, x1, x2       # expect x9 = 0x00000001

    # 1 - INT_MIN: small positive minus the most negative value overflows.
    sub  x10, x3, x1      # expect x10 = 0x80000001

    # --- Cases right at the edge that do NOT overflow -----------------------
    # These make sure the design is not "over-correcting" near the limits.

    # -1 - INT_MAX lands exactly on INT_MIN with no overflow.
    sub  x11, x4, x2      # expect x11 = 0x80000000

    # -1 - INT_MIN lands exactly on INT_MAX with no overflow.
    sub  x12, x4, x1      # expect x12 = 0x7FFFFFFF

    # 0 - INT_MAX: most negative result a negation can produce legally.
    sub  x13, x0, x2      # expect x13 = 0x80000001

    # INT_MAX - 1: just inside the top of the range.
    sub  x14, x2, x3      # expect x14 = 0x7FFFFFFE

    # INT_MIN - (-1): just inside the bottom of the range.
    sub  x15, x1, x4      # expect x15 = 0x80000001

    # --- Extreme values that cancel to zero --------------------------------

    # INT_MIN - INT_MIN and INT_MAX - INT_MAX must both be exactly 0
    sub  x16, x1, x1      # expect x16 = 0x00000000
    sub  x17, x2, x2      # expect x17 = 0x00000000

    # -1 - (-1): all ones minus all ones is zero.
    sub  x18, x4, x4      # expect x18 = 0x00000000

    # --- Longest borrow chain ----------------------------------------------

    # 0 - 1: the borrow has to ripple through all 32 bits to produce all ones.
    sub  x19, x0, x3      # expect x19 = 0xFFFFFFFF

    # 0 - (-1) = 1: the reverse, everything collapses back to a single 1 bit.
    sub  x20, x0, x4      # expect x20 = 0x00000001

  end:

wfi