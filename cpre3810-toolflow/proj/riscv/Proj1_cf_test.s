# Proj1_cf_test.s
# Jamison Bice & Christopher Funk (Group D_01)
#	This program exercises every required control-flow instruction 
#	(beq, bne, blt, bge, bltu, bgeu, jal, jalr, and wfi) 
#	under both not-taken and taken conditions, 
#	and then executes a recursive function recurse_sum(5) 
#	that reaches a call depth of 6

.data
cf_result:
    .word 0
depth_reached:
    .word 0

.text
.globl main

main:
    # Init
    lui   sp, 0x10011

    # Save main frame 
    addi  sp, sp, -16
    sw    ra, 12(sp)
    sw    s0, 8(sp)
    addi  s0, x0, 0            

    #Branch verification 
    addi  t0, x0, 10           # t0 = 10
    addi  t1, x0, 10           # t1 = 10
    addi  t2, x0, -5           # t2 = -5 (0xFFFFFFFB)

    #BEQ 
    beq   t0, t2, br_fail      # 10 == -5 (False -> Not Taken)
    beq   t0, t1, beq_ok       # 10 == 10 (True  -> Taken)
    jal   x0, br_fail
beq_ok:
    addi  s0, s0, 1            # s0 = 1

    # BNE 
    bne   t0, t1, br_fail      # 10 != 10 (False -> Not Taken)
    bne   t0, t2, bne_ok       # 10 != -5 (True  -> Taken)
    jal   x0, br_fail
bne_ok:
    addi  s0, s0, 2            # s0 = 3

    # BLT Signed  
    blt   t0, t2, br_fail      # 10 <s -5 (False -> Not Taken)
    blt   t2, t0, blt_ok       # -5 <s 10 (True  -> Taken)
    jal   x0, br_fail
blt_ok:
    addi  s0, s0, 4            # s0 = 7

    # BGE Signed 
    bge   t2, t0, br_fail      # -5 >=s 10 (False -> Not Taken)
    bge   t0, t2, bge_ok       # 10 >=s -5 (True  -> Taken)
    jal   x0, br_fail
bge_ok:
    addi  s0, s0, 8            # s0 = 15

    # BLTU Unsigned 
    bltu  t2, t0, br_fail      # 0xFFFFFFFB <u 10 (False -> Not Taken)
    bltu  t0, t2, bltu_ok      # 10 <u 0xFFFFFFFB (True  -> Taken)
    jal   x0, br_fail
bltu_ok:
    addi  s0, s0, 16           # s0 = 31

    # BGEU Unsigned
    bgeu  t0, t2, br_fail      # 10 >=u 0xFFFFFFFB (False -> Not Taken)
    bgeu  t2, t0, bgeu_ok      # 0xFFFFFFFB >=u 10 (True  -> Taken)
    jal   x0, br_fail
bgeu_ok:
    addi  s0, s0, 32           # s0 = 63 (0x3F -> all 6 branch types passed!)

	# JALR 
    la    t3, helper_fn
    jalr  ra, t3, 0            # adds 64 to s0 -> s0 = 127

    # Recursive Call
    # Returns 5 + 4 + 3 + 2 + 1 + 0 = 15 in a0
    addi  a0, x0, 5            # n = 5 
    jal   ra, recurse_sum      # a0 = 15

    # branch status (127) + rec sum (15) = 142 (0x8E)
    add   s0, s0, a0           # s0 = 127 + 15 = 142
    la    t4, cf_result
    sw    s0, 0(t4)            

    # Restore main and halt
    lw    s0, 8(sp)
    lw    ra, 12(sp)
    addi  sp, sp, 16
    jal   x0, halt

br_fail:
    addi  s0, x0, -1           
    wfi

# indirect call and return using jalr
helper_fn:
    addi  s0, s0, 64
    jalr  x0, ra, 0

# 16-byte activation record on the stack for each call
recurse_sum:
    addi  sp, sp, -16          # activation record on stack
    sw    ra, 12(sp)           
    sw    s1, 8(sp)            
    sw    a0, 4(sp)           

    # Track number
    la    t0, depth_reached
    lw    t1, 0(t0)
    addi  t1, t1, 1
    sw    t1, 0(t0)

    # if n <= 0 (i.e. x0 >= a0), return 0
    bge   x0, a0, recurse_base

    #return n + recurse_sum(n - 1)
    addi  s1, a0, 0            # s1 = n
    addi  a0, a0, -1           # a0 = n - 1
    jal   ra, recurse_sum      # recursive call
    add   a0, s1, a0           # a0 = n + recurse_sum(n - 1)
    jal   x0, recurse_exit

recurse_base:
    addi  a0, x0, 0            # Base case returns 0

recurse_exit:
    lw    s1, 8(sp)            # Restore 
    lw    ra, 12(sp)           
    addi  sp, sp, 16           # Deallocate activation record
    jalr  x0, ra, 0            # Return to caller
	
halt:
    wfi