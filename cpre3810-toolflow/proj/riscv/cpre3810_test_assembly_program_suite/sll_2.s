.data

.text
.globl main

main:

    # Start Test

    lui x1, 0x12345
    addi x1, x1, 0x678
    addi t0, x0, 0
    sll x1, x1, t0 # x1 = 0x12345678 << 0 = 0x12345678
    addi t0, x0, 0x00000020
    sll x1, x1, t0 # x1 = 0x12345678 << 0 = 0x12345678
    addi t0, x0, 0xFFFFFFE0
    sll x1, x1, t0 # x1 = 0x12345678 << 0 = 0x12345678
    addi t0, x0, 0x0000001F
    sll x1, x1, t0 # x1 = 0x12345678 << 31 = 0x0000000

  end:

wfi