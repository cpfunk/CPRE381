.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, 1
    addi t0, x0, 1
    sll x1, x1, t0 # 0x00000001 << 1
    sll x1, x1, t0 # 0x00000002 << 1
    sll x1, x1, t0 # 0x00000004 << 1
    sll x1, x1, t0 # 0x00000008 << 1
    sll x1, x1, t0 # 0x00000010 << 1
    sll x1, x1, t0 # 0x00000020 << 1
    sll x1, x1, t0 # 0x00000040 << 1
    sll x1, x1, t0 # 0x00000080 << 1
    sll x1, x1, t0 # 0x00000100 << 1
    sll x1, x1, t0 # 0x00000200 << 1
    sll x1, x1, t0 # 0x00000400 << 1
    sll x1, x1, t0 # 0x00000800 << 1
    sll x1, x1, t0 # 0x00001000 << 1
    sll x1, x1, t0 # 0x00002000 << 1
    sll x1, x1, t0 # 0x00004000 << 1
    sll x1, x1, t0 # 0x00008000 << 1
    sll x1, x1, t0 # 0x00010000 << 1
    sll x1, x1, t0 # 0x00020000 << 1
    sll x1, x1, t0 # 0x00040000 << 1
    sll x1, x1, t0 # 0x00080000 << 1
    sll x1, x1, t0 # 0x00100000 << 1
    sll x1, x1, t0 # 0x00200000 << 1
    sll x1, x1, t0 # 0x00400000 << 1
    sll x1, x1, t0 # 0x00800000 << 1
    sll x1, x1, t0 # 0x01000000 << 1
    sll x1, x1, t0 # 0x02000000 << 1
    sll x1, x1, t0 # 0x04000000 << 1
    sll x1, x1, t0 # 0x08000000 << 1
    sll x1, x1, t0 # 0x10000000 << 1
    sll x1, x1, t0 # 0x20000000 << 1
    sll x1, x1, t0 # 0x40000000 << 1
    sll x1, x1, t0 # 0x80000000 << 1
    sll x1, x1, t0 # 0x00000000 << 1

  end:

wfi