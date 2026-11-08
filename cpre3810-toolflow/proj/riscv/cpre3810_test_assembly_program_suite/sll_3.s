.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, 1
    sll x1, x1, x1 # x1 = 0x00000001 << 1 = 0x00000002

    addi x1, x0, 1
    addi t0, x0, 31
    sll x1, x1, t0 # x1 = 0x00000001 << 31 = 0x80000000
    addi x1, x0, -1
    addi t0, x0, 1
    sll x1, x1, t0 # x1 = 0xFFFFFFFF << 1 = 0xFFFFFFFE
    addi t0, x0, 30
    sll x1, x1, t0 # x1 = 0xFFFFFFFE << 30 = 0x80000000

  end:

wfi