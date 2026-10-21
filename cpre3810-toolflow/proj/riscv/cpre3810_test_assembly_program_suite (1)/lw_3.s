.data
ptr:
    .word target        # address of target
val:
    .word 0xDEADBEEF
target:
    .word 0x0BADF00D

.text
.globl main

main:

    # Test 3: register edge cases (x0, rs1 same as rd, x31)

    lui x1, 0x10010     # x1 = start of data

    lw   x0, 4(x1)      # try to load into x0, it should stay 0
    addi x2, x0, 0      # x2 = 0, copies x0 so I can see it did not change

    lw   x3, 0(x1)      # x3 = address of target, loading a pointer
    lw   x4, 0(x3)      # 0x0BADF00D, uses the value just loaded as the base

    addi x5, x1, 0      # x5 = start of data
    lw   x5, 0(x5)      # x5 = address of target, base and destination are the same register
    lw   x5, 0(x5)      # 0x0BADF00D, shows the line above wrote x5 correctly

    lw   x31, 4(x1)     # 0xDEADBEEF, x31 is the last register
    lw   x30, 4(x1)     # 0xDEADBEEF, same address into a different register
    lw   x31, 8(x1)     # 0x0BADF00D, overwrites a register that already has a value


wfi