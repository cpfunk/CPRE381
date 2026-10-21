.data
vals:
    .word 0x00000000
    .word 0x00000001
    .word 0xFFFFFFFF
    .word 0x7FFFFFFF
    .word 0x80000000
    .word 0xAAAAAAAA
    .word 0x55555555
    .word 0x12345678

.text
.globl main

main:

    # Test 1: load different data values to make sure all 32 bits come through

    lui x1, 0x10010     # x1 = start of data (used lui so I don't need la)

    lw x2, 0(x1)        # 0x00000000, basic case with offset 0
    lw x3, 4(x1)        # 0x00000001, checks the lowest bit and a small offset
    lw x4, 8(x1)        # 0xFFFFFFFF, all 1s so a bit stuck at 0 would show
    lw x5, 12(x1)       # 0x7FFFFFFF, biggest positive, top bit should stay 0
    lw x6, 16(x1)       # 0x80000000, most negative, only the top bit is 1
    lw x7, 20(x1)       # 0xAAAAAAAA, alternating bits to catch swapped bits
    lw x8, 24(x1)       # 0x55555555, opposite pattern so every bit is tested as 0 and 1
    lw x9, 28(x1)       # 0x12345678, every byte different to check byte order


wfi