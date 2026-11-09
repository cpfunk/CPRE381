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
    # Rearr moved s0, t0, t1 initializations into the 3 hazard slots between lui sp and addi sp
    addi  s0, x0, 0            
    addi  t0, x0, 10           # t0 = 10
    addi  t1, x0, 10           # t1 = 10

    # Save main frame 
    addi  sp, sp, -16
    # Rearr placed t2 initialization in the 1st hazard slot after addi sp
    addi  t2, x0, -5           # t2 = -5 (0xFFFFFFFB)
    nop
    nop
    sw    ra, 12(sp)
    sw    s0, 8(sp)

    #Branch verification 

    #BEQ 
    beq   t0, t2, br_fail      # 10 == -5 (False -> Not Taken)
    nop
    nop
    beq   t0, t1, beq_ok       # 10 == 10 (True  -> Taken)
    nop
    nop
    jal   x0, br_fail
    nop
    nop
beq_ok:
    addi  s0, s0, 1            # s0 = 1

    # BNE 
    bne   t0, t1, br_fail      # 10 != 10 (False -> Not Taken)
    nop
    nop
    bne   t0, t2, bne_ok       # 10 != -5 (True  -> Taken)
    nop
    nop
    jal   x0, br_fail
    nop
    nop
bne_ok:
    addi  s0, s0, 2            # s0 = 3

    # BLT Signed  
    blt   t0, t2, br_fail      # 10 <s -5 (False -> Not Taken)
    nop
    nop
    blt   t2, t0, blt_ok       # -5 <s 10 (True  -> Taken)
    nop
    nop
    jal   x0, br_fail
    nop
    nop
blt_ok:
    addi  s0, s0, 4            # s0 = 7

    # BGE Signed 
    bge   t2, t0, br_fail      # -5 >=s 10 (False -> Not Taken)
    nop
    nop
    bge   t0, t2, bge_ok       # 10 >=s -5 (True  -> Taken)
    nop
    nop
    jal   x0, br_fail
    nop
    nop
bge_ok:
    addi  s0, s0, 8            # s0 = 15

    # BLTU Unsigned 
    bltu  t2, t0, br_fail      # 0xFFFFFFFB <u 10 (False -> Not Taken)
    nop
    nop
    bltu  t0, t2, bltu_ok      # 10 <u 0xFFFFFFFB (True  -> Taken)
    nop
    nop
    jal   x0, br_fail
    nop
    nop
bltu_ok:
    addi  s0, s0, 16           # s0 = 31

    # BGEU Unsigned
    bgeu  t0, t2, br_fail      # 10 >=u 0xFFFFFFFB (False -> Not Taken)
    nop
    nop
    bgeu  t2, t0, bgeu_ok      # 0xFFFFFFFB >=u 10 (True  -> Taken)
    nop
    nop
    jal   x0, br_fail
    nop
    nop
bgeu_ok:
    # Rearr used lasw t3 before addi s0 so s0 update hides 1 cycle of t3 address load latency
    lasw  t3, helper_fn
    addi  s0, s0, 32           # s0 = 63 (0x3F -> all 6 branch types passed!)
    nop
    nop

	# JALR 
    jalr  ra, t3, 0            # adds 64 to s0 -> s0 = 127
    nop
    nop

    # Recursive Call
    # Returns 5 + 4 + 3 + 2 + 1 + 0 = 15 in a0
    addi  a0, x0, 5            # n = 5 
    # Rearr preloaded cf_result upper address into t4 during a0 hazard window
    lui   t4, 0x10010
    nop
    nop
    jal   ra, recurse_sum      # a0 = 15
    nop
    nop

    # branch status (127) + rec sum (15) = 142 (0x8E)
    nop
    add   s0, s0, a0           # s0 = 127 + 15 = 142
    # Rearr restored ra early during s0 writeback latency
    lw    ra, 12(sp)
    nop
    nop
    sw    s0, 0(t4)            

    # Restore main and halt
    lw    s0, 8(sp)
    addi  sp, sp, 16
    jal   x0, halt
    nop
    nop

br_fail:
    addi  s0, x0, -1           
    wfi

# indirect call and return using jalr
helper_fn:
    addi  s0, s0, 64
    nop
    jalr  x0, ra, 0
    nop
    nop

# 16-byte activation record on the stack for each call
recurse_sum:
    addi  sp, sp, -16          # activation record on stack
    # Rearr loaded data segment base 0x10010000 into t0 during sp hazard window
    lui   t0, 0x10010
    nop
    nop
    sw    ra, 12(sp)           
    sw    s1, 8(sp)            
    sw    a0, 4(sp)           

    # Track number
    lw    t1, 4(t0)
    nop
    nop
    nop
    addi  t1, t1, 1
    nop
    nop
    nop
    sw    t1, 4(t0)

    # if n <= 0 (i.e. x0 >= a0), return 0
    bge   x0, a0, recurse_base
    nop
    nop

    #return n + recurse_sum(n - 1)
    addi  s1, a0, 0            # s1 = n
    addi  a0, a0, -1           # a0 = n - 1
    nop
    nop
    jal   ra, recurse_sum      # recursive call
    nop
    nop
    add   a0, s1, a0           # a0 = n + recurse_sum(n - 1)
    jal   x0, recurse_exit
    nop
    nop

recurse_base:
    addi  a0, x0, 0            # Base case returns 0

recurse_exit:
    lw    s1, 8(sp)            # Restore 
    lw    ra, 12(sp)           
    addi  sp, sp, 16           # Deallocate activation record
    nop
    nop
    jalr  x0, ra, 0            # Return to caller
    nop
    nop
	
halt:
    wfi