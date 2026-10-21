# each immediate bit on its own, back-to-back andi, and x31
# Checks that the hardware is wired correctly. Only addi and andi are used

.data

.text
.globl main

main:

    addi x1, x0, -1          # x1 = 0xFFFFFFFF

    # Each line turns on just one bit of the immediate
    # If a result is wrong, it shows exactly which bit is wired wrong
    andi x2,  x1, 1          # bit 0  -> 0x00000001
    andi x3,  x1, 2          # bit 1  -> 0x00000002
    andi x4,  x1, 4          # bit 2  -> 0x00000004
    andi x5,  x1, 8          # bit 3  -> 0x00000008
    andi x6,  x1, 16         # bit 4  -> 0x00000010
    andi x7,  x1, 32         # bit 5  -> 0x00000020
    andi x8,  x1, 64         # bit 6  -> 0x00000040
    andi x9,  x1, 128        # bit 7  -> 0x00000080
    andi x10, x1, 256        # bit 8  -> 0x00000100
    andi x11, x1, 512        # bit 9  -> 0x00000200
    andi x12, x1, 1024       # bit 10 -> 0x00000400
    andi x13, x1, -2048      # bit 11 is the sign bit, so the top bits also fill with 1s -> 0xFFFFF800

    # Each andi uses the result of the one right before it, in the same register
    # This checks that new values are passed along in time
    addi x14, x0, -1         # 0xFFFFFFFF
    andi x14, x14, 255       # -> 0x000000FF
    andi x14, x14, 240       # -> 0x000000F0
    andi x14, x14, 48        # -> 0x00000030
    andi x15, x14, 63        # same idea with a different destination: x15 -> 0x00000030
    andi x14, x14, 15        # x14 -> 0x00000000

    # x31 is the highest register number, which checks the top end of register selection
    # 0x5A5 mixes 1s and 0s so a partly wrong result won't pass by accident
    addi x31, x0, -1
    andi x31, x31, 1445      # mask 0x5A5, expect 0x000005A5

  end:

wfi