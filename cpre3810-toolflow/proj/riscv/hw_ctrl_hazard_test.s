# hw_ctrl_hazard_test.s
# Jamison Bice & Christopher Funk

.data
test_val:
    .word 42
result_out:
    .word 0

.text
.globl main

main:
    lui   tp, 0x10010          # tp = 0x10010000
    addi  s0, x0, 0            # 
    addi  t0, x0, 10           # t0 = 10
    addi  t1, x0, 10           # t1 = 10 
    addi  t2, x0, -5           # t2 = -5 (0xFFFFFFFB)

    beq   t0, t2, exit         # Not taken (10 == -5 False)
    beq   t0, t1, beq_pass     # Taken (10 == 10 True)
    addi  s0, s0, 1000         # FLUSHED (IF/DE)
    addi  s0, s0, 1000         # FLUSHED (DE/EX)
beq_pass:
    addi  s0, s0, 1            # s0 = 1

    addi  t3, x0, 20           # t3 = 20 
    bne   t0, t1, exit         # Not taken
    bne   t0, t3, bne_pass     # Taken 
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED
bne_pass:
    addi  s0, s0, 2            # s0 = 3

    blt   t0, t2, exit         # Not taken (10 <s -5 False)
    blt   t2, t0, blt_pass     # Taken (-5 <s 10 True)
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED
blt_pass:
    addi  s0, s0, 4            # s0 = 7

    bge   t2, t0, exit         # Not taken (-5 >=s 10 False)
    bge   t0, t2, bge_pass     # Taken (10 >=s -5 True)
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED
bge_pass:
    addi  s0, s0, 8            # s0 = 15

    bltu  t2, t0, exit         # Not taken (0xFFFFFFFB <u 10 False)
    bltu  t0, t2, bltu_pass    # Taken (10 <u 0xFFFFFFFB True)
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED
bltu_pass:
    addi  s0, s0, 16           # s0 = 31

    bgeu  t0, t2, exit         # Not taken (10 >=u 0xFFFFFFFB False)
    bgeu  t2, t0, bgeu_pass    # Taken (0xFFFFFFFB >=u 10 True)
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED
bgeu_pass:
    addi  s0, s0, 32           # s0 = 63

    lw    t4, 0(tp)            # Loads 42 from test_val
    addi  t5, x0, 42           # t5 = 42 
    lw    t6, 0(tp)            # Loads 42 from test_val
    beq   t6, t5, lu_br_pass   # Stalls 1 cycle then takes branch
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED
lu_br_pass:
    addi  s0, s0, 64           # s0 = 127

    jal   ra, sub_test         # Calls sub_test
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED

    # After return from sub_test, s0 should be 127 + 128 = 255 (0xFF)
    sw    s0, 4(tp)            # Store 255 into result_out
    j exit

sub_test:
    addi  s0, s0, 128          # s0 = 255
    jalr  x0, ra, 0            # Return via JALR
    addi  s0, s0, 1000         # FLUSHED
    addi  s0, s0, 1000         # FLUSHED

#exit:
    #addi  s0, x0, -1
    #sw    s0, 4(tp)
exit:
    wfi