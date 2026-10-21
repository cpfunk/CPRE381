.data

.text
.globl main

main:

    # sub test 2: bit patterns, borrow propagation, and register addressing.

    # --- Alternating bit patterns ------------------------------------------
    lui  x1, 0xAAAAB
    addi x1, x1, -1366    # x1 = 0xAAAAAAAA  (1010...1010)
    lui  x2, 0x55555
    addi x2, x2, 1365     # x2 = 0x55555555  (0101...0101)
    addi x3, x0, -1       # x3 = 0xFFFFFFFF

    # 0xAAAAAAAA - 0x55555555. Neighboring bits always differ
    sub  x4, x1, x2       # expect x4 = 0x55555555

    # Swapped: every other bit position needs a borrow from its neighbor.
    sub  x5, x2, x1       # expect x5 = 0xAAAAAAAB

    # All ones minus a pattern is the bitwise NOT of that pattern, with no borrow in any column
    sub  x6, x3, x1       # expect x6 = 0x55555555
    sub  x7, x3, x2       # expect x7 = 0xAAAAAAAA

    # --- Borrows that start and stop in the middle -------------------------
    addi x8, x0, 1        # x8 = 1

    # 0x00001000 - 1: borrow ripples through the low 12 bits and stops.
    lui  x9, 0x1          # x9 = 0x00001000
    sub  x10, x9, x8      # expect x10 = 0x00000FFF

    # 0x00010000 - 1: borrow ripples through the whole lower half and stops.
    lui  x11, 0x10        # x11 = 0x00010000
    sub  x12, x11, x8     # expect x12 = 0x0000FFFF

    # 0xFFFF0000 - 0x0000FFFF: lower half borrows from the upper hal
    lui  x13, 0xFFFF0     # x13 = 0xFFFF0000
    sub  x14, x13, x12    # expect x14 = 0xFFFE0001

    # --- Destination overlaps a source -------------------------------------

    # rd = rs1, repeated: a countdown 100 -> 75 -> 50 -> 25 -> 0. Each sub reads the value the previous sub just wrote
    addi x15, x0, 100
    addi x16, x0, 25
    sub  x15, x15, x16    # expect x15 = 0x0000004B
    sub  x15, x15, x16    # expect x15 = 0x00000032
    sub  x15, x15, x16    # expect x15 = 0x00000019
    sub  x15, x15, x16    # expect x15 = 0x00000000

    # rd = rs2: 9 - 4 = 5, written over the subtrahend.
    addi x17, x0, 9
    addi x18, x0, 4
    sub  x18, x17, x18    # expect x18 = 0x00000005

    # rd = rs1 = rs2: a register minus itself is always 0, whatever it held.
    addi x19, x0, 77
    sub  x19, x19, x19    # expect x19 = 0x00000000

    # --- x0 as the destination ---------------------------------------------

    # Writing a nonzero result (9 - 25 = -16) to x0 must be ignored.
    sub  x0, x17, x16     # expect x0 = 0x00000000

    # Proof x0 is still zero: 9 - x0 must still be 9. If the write above went through, this would give 9 - (-16) = 25 instead.
    sub  x20, x17, x0     # expect x20 = 0x00000009

    # --- Highest-numbered registers ----------------------------------------

    # x28-x31 have the upper bits of the 5-bit register number set
    addi x30, x0, 12
    addi x31, x0, 5
    sub  x29, x30, x31    # expect x29 = 0x00000007
    sub  x28, x31, x30    # expect x28 = 0xFFFFFFF9

  end:

wfi