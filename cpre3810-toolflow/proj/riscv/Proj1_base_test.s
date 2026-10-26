# Proj1_base_test.s
# Jamison Bice & Christopher Funk

#    R-type 	: add, sub, and, or, xor, slt, sltu, sll, srl, sra
#    I-type 	: addi, andi, ori, xori, slti, sltiu, slli, srli, srai
#   upper imm	: lui, auipc
#   Mem			: lw, lh, lhu, lb, lbu, sw, sh, sb
#   halt 		: wfi

.data
mem_buf:
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

.text
.globl main

main:
    
    lui   t0, 0x12345          # t0 = 0x12345000
    addi  t0, t0, 0x678        # t0 = 0x12345678
    addi  t1, x0, -16          # t1 = 0xFFFFFFF0 (-16)
    addi  t2, x0, 25           # t2 = 0x00000019 (25)
    auipc t3, 0                # t3 = PC of this auipc instruction

    
    add   t4, t1, t2           # t4 = -16 + 25 = 9 (0x00000009)
    sub   t5, t2, t1           # t5 = 25 - (-16) = 41 (0x00000029)
    sub   t6, t1, t2           # t6 = -16 - 25 = -41 (0xFFFFFFD7)

    
    andi  s0, t0, 0x7FF        # s0 = 0x12345678 & 0x000007FF = 0x00000678
    ori   s1, s0, 0x105        # s1 = 0x00000678 | 0x00000105 = 0x0000077D
    xori  s2, s1, -1           # s2 = ~s1 = 0xFFFFF882 (tests sign-extended imm)
    and   s3, t0, s1           # s3 = 0x12345678 & 0x0000077D = 0x00000678
    or    s4, t0, t4           # s4 = 0x12345678 | 0x00000009 = 0x12345679
    xor   s5, s4, t0           # s5 = 0x12345679 ^ 0x12345678 = 0x00000001

    
    slt   s6, t1, t2           # s6 = (-16 <s 25) = 1
    slt   s7, t2, t1           # s7 = (25 <s -16) = 0
    sltu  s8, t1, t2           # s8 = (0xFFFFFFF0 <u 25) = 0
    sltu  s9, t2, t1           # s9 = (25 <u 0xFFFFFFF0) = 1
    slti  s10, t1, 0           # s10 = (-16 <s 0) = 1
    sltiu s11, t2, 100         # s11 = (25 <u 100) = 1
    sltiu a0, t2, -1           # a0 = (25 <u 0xFFFFFFFF) = 1

    
    addi  a1, x0, 4            # a1 = shift amount 4
    slli  a2, t4, 4            # a2 = 9 << 4 = 144 (0x00000090)
    srli  a3, a2, 2            # a3 = 144 >>u 2 = 36 (0x00000024)
    srai  a4, t1, 2            # a4 = -16 >>s 2 = -4 (0xFFFFFFFC)
    srli  a5, t1, 28           # a5 = 0xFFFFFFF0 >>u 28 = 15 (0x0000000F)
    sll   a6, a3, a1           # a6 = 36 << 4 = 576 (0x00000240)
    srl   a7, t1, a1           # a7 = 0xFFFFFFF0 >>u 4 = 0x0FFFFFFF
    sra   t4, t1, a1           # t4 = -16 >>s 4 = -1 (0xFFFFFFFF)

    
    la    tp, mem_buf          # tp = base address of mem_buf (0x10010000)

    sw    t0, 0(tp)            # mem_buf[0] = 0x12345678
    lw    s0, 0(tp)            # s0 = 0x12345678

    lb    s1, 0(tp)            # s1 = sext(0x78) = 0x00000078
    lbu   s2, 1(tp)            # s2 = zext(0x56) = 0x00000056
    lb    s3, 2(tp)            # s3 = sext(0x34) = 0x00000034
    lbu   s4, 3(tp)            # s4 = zext(0x12) = 0x00000012

    addi  t5, x0, -128         # t5 = 0xFFFFFF80 (negative byte 0x80)
    sb    t5, 4(tp)            # mem_buf[1] byte 0 = 0x80
    lb    s5, 4(tp)            # s5 = sext(0x80) = 0xFFFFFF80 (-128)
    lbu   s6, 4(tp)            # s6 = zext(0x80) = 0x00000080 (128)

    lui   t6, 0xFFFFF          # t6 = 0xFFFFF000
    addi  t6, t6, -256         # t6 = 0xFFFFEF00 (negative halfword 0xEF00)
    sh    t6, 6(tp)            # mem_buf[1] upper halfword (offset 6) = 0xEF00
    lh    s7, 6(tp)            # s7 = sext(0xEF00) = 0xFFFFEF00 (-4352)
    lhu   s8, 6(tp)            # s8 = zext(0xEF00) = 0x0000EF00 (61184)

    lw    s9, 4(tp)            # s9 = 0xEF000080
    add   s10, s0, s9          # s10 = 0x12345678 + 0xEF000080 = 0x013456F8
    sw    s10, 8(tp)           # mem_buf[2] = 0x013456F8

    wfi