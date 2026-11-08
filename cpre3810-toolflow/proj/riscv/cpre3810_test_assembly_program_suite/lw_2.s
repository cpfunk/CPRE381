.data
first:
    .word 0x11111111    # base - 2048
    .space 2040
neg4:
    .word 0x22222222    # base - 4
mid:
    .word 0x33333333    # base
pos4:
    .word 0x44444444    # base + 4
    .space 2036
last:
    .word 0x55555555    # base + 2044

.text
.globl main

main:

    # Test 2: offset edge cases (positive, negative, biggest and smallest)

    lui  x1, 0x10010    # x1 = start of data
    addi x1, x1, 2047
    addi x1, x1, 1      # x1 = 0x10010800 (mid), 0x800 is too big for one addi

    lw x2, 0(x1)        # 0x33333333, offset 0 is the common case
    lw x3, 4(x1)        # 0x44444444, small positive offset
    lw x4, -4(x1)       # 0x22222222, negative offset only works if imm is sign extended
    lw x5, 2044(x1)     # 0x55555555, biggest word aligned offset
    lw x6, -2048(x1)    # 0x11111111, most negative offset (only the sign bit set)

    addi x7, x1, -4     # x7 = 0x100107FC
    lw   x8, 4(x7)      # 0x33333333, adding 4 has to carry in the address adder
    lw   x9, 0(x1)      # 0x33333333, same address again, lw should not change memory


wfi