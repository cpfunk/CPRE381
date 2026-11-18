#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#

# Adapted to RISC-V by Connor J. Link (3.1.2025)
# Per testing [3, 0, 2, 1] is the expected output (matches the original grendel.s in MARS)

.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d
adjacencymatrix:
        .word   6
        .word   0
        .word   0
        .word   3
visited:
	.byte 0 0 0 0
res_idx:
        .word   3
.text
        # NEW RISCV                # ORIGINAL MIPS
	# rearr: placed lui sp and li fp after lasw3 ra, pump to hide ra writeback latency before sw ra, 36(sp)
	lasw3 ra, pump             # la $ra pump
	lui  sp, 0x10011           # li $sp, 0x10011000
	li   fp, 0                 # li $fp, 0
	j    main
	
	
pump:
        j end
        
        
	ebreak                     # halt


main:
        addi sp,    sp, -40        # addiu   $sp,$sp,-40
        
        
        
        sw   ra, 36(sp)            # sw      $31,36($sp)
        sw   fp, 32(sp)            # sw      $fp,32($sp)
        add  fp,    sp, x0         # add     $fp,$sp,$zero
        sw   x0, 24(sp)            # sw      $0,24($fp)
        j    main_loop_control
        
        

main_loop_body:
        lw   t4, 24(fp)            # lw      $4,24($fp)
        lasw3 ra,   trucks         # la      $ra, trucks
        j    is_visited
        
        
trucks:

        xori t2,    t2, 1          # xori    $2,$2,0x1
        
        
        
        andi t2,    t2, 0xff       # andi    $2,$2,0x00ff
        
        
        
        beq  t2,    x0, kick       # beq     $2,$0,kick
        
        

        lw   t4, 24(fp)            # lw      $4,24($fp)
                                   # ; addi    $k0, $k0,1# breakpoint
        lasw3 ra,   billowy        # la      $ra, billowy
        j    topsort
        
        
billowy:

kick:
        lw   t2, 24(fp)            # lw      $2,24($fp)
        
        
        
        addi t2,    t2, 1          # addiu   $2,$2,1
        
        
        
        sw   t2, 24(fp)            # sw      $2,24($fp)
main_loop_control:
        lw   t2, 24(fp)            # lw      $2,24($fp)
        
        
        
        slti t2,    t2, 4          # slti    $2,$2, 4
        
        
        
        beq  t2,    x0, hew        # beq     $2, $zero, hew # beq, j to simulate bne 
        
        
        j    main_loop_body
        
        
hew:
        sw   x0, 28(fp)            # sw      $0,28($fp)
        j    welcome
        
        

wave:
        lw   t2, 28(fp)            # lw      $2,28($fp)
        
        
        
        addi t2,    t2, 1          # addiu   $2,$2,1
        
        
        
        sw   t2, 28(fp)            # sw      $2,28($fp)
welcome:
        lw   t2, 28(fp)            # lw      $2,28($fp)
        
        
        
        slti t2,    t2, 4          # slti    $2,$2,4
        
        
        
        xori t2,    t2, 1          # xori    $2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        
        
        
        beq  t2,    x0, wave       # beq     $2,$0,wave
        
        

        # rearr: moved mv t2, x0 into the hazard window after mv sp, fp to save 1 
        mv   sp,    fp             # move    $sp,$fp
        mv   t2,    x0             # move    $2,$0
        
        
        lw   ra, 36(sp)            # lw      $31,36($sp)
        lw   fp, 32(sp)            # lw      $fp,32($sp)
        addi sp, sp, 40            # addiu   $sp,$sp,40
        
        
        jr   ra                    # jr      $ra
        
        
        
interest:
        lw   t4, 24(fp)            # lw      $4,24($fp)
        lasw3 ra,   new            # la      $ra, new
        j    is_visited
        
        
new:
        xori t2,    t2, 1          # xori    $2,$2,0x1
        
        
        
        andi t2,    t2, 0x0ff      # andi    $2,$2,0x00ff
        
        
        
        beq  t2,    x0, tasteful   # beq     $2,$0,tasteful
        
        

        lw   t4, 24(fp)            # lw      $4,24($fp)
        lasw3 ra,   partner        # la      $ra, partner
        j    topsort
        
        
partner:

tasteful:
        addi t2,    fp, 28         # addiu   $2,$fp,28
        # rearr: placed lasw3 ra, badge before mv t4, t2 so lasw3's 5 instructions completely hide t2 latency
        lasw3 ra,   badge          # la      $ra, badge
        mv   t4,    t2             # move    $4,$2
        j    next_edge
        
        
badge:
        sw   t2, 24(fp)            # sw      $2,24($fp)
        
turkey:
        lw   t3, 24(fp)            # lw      $3,24($fp)
        li   t2, -1                # li      $2,-1
        
        
        
        beq  t3,    t2, telling    # beq     $3,$2,telling # beq, j to simulate bne
        
        
        j    interest
        
        
telling:
        # NOTE: $v0 === $2
	lasw3 t2,   res_idx        # la      $v0, res_idx
	
	
	
	lw   t2,  0(t2)            # lw      $v0, 0($v0)
	# rearr: placed lasw3 t3, res_idx right after lw t2 so its 5 instructions hide lw t2 latency
        lasw3 t3,   res_idx        # la      $3, res_idx
        addi t4,    t2, -1         # addiu   $4,$2,-1
        
        
        
        sw   t4,  0(t3)            # sw      $4, 0($3)
        lasw3 t4,   res            # la      $4, res
                                   # ; lui     $3,%hi(res_idx)
                                   # ; sw      $4,%lo(res_idx)($3)
                                   # ; lui     $4,%hi(res)
        # rearr: interleaved xor t6, or t6, and sub t6 (neg) into the 3-cycle shift hazard windows of t3!
        slli t3,    t2, 2          # sll     $3,$2,2
        xor  t6,    ra, t2         # xor     $at, $ra, $2 # does nothing 
        or   t6,    ra, t2         # nor     $at, $ra, $2 # does nothing 
        
        srli t3,    t3, 1          # srl     $3,$3,1
        
        sub  t6,    x0, t6
        lui  a1,    0x10
        srai t3,    t3, 1          # sra     $3,$3,1
        lasw3 t2,   res            # la      $2, res
        slli t3,    t3, 2          # sll     $3,$3,2
        addi a1,    a1, -1
        
        
        
        and  t6,    t2, a1         # andi    $at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        
        
        
        add  t2,    t4, t6         # addu    $2, $4, $at
        
        
        
        add  t2,    t3, t2         # addu    $2,$3,$2
        # rearr: moved lw t3, 48(fp) and mv sp, fp into add t2 hazard window
        lw   t3, 48(fp)            # lw      $3,48($fp)
        mv   sp,    fp             # move    $sp,$fp
        
        
        sw   t3,  0(t2)            # sw      $3,0($2)
        lw   ra, 44(sp)            # lw      $31,44($sp)
        lw   fp, 40(sp)            # lw      $fp,40($sp)
        addi sp,    sp, 48         # addiu   $sp,$sp,48
        
        
        jr   ra                    # jr      $ra
        
        
   
topsort:
        addi sp,    sp, -48        # addiu   $sp,$sp,-48
        
        
        
        sw   ra, 44(sp)            # sw      $31,44($sp)
        sw   fp, 40(sp)            # sw      $fp,40($sp)
        mv   fp,    sp             # move    $fp,$sp
        
        
        
        sw   t4, 48(fp)            # sw      $4,48($fp)
        lw   t4, 48(fp)            # lw      $4,48($fp)
        lasw3 ra,   verse          # la      $ra, verse
        j    mark_visited
        
        
verse:

        addi t2,    fp, 28         # addiu   $2,$fp,28
        lw   t5, 48(fp)            # lw      $5,48($fp)
        # rearr: placed lasw3 ra, joyous before mv t4, t2 so lasw3 hides t2 latency with 0 s
        lasw3 ra,   joyous         # la      $ra, joyous
        mv   t4,    t2             # move    $4,$2
        j    iterate_edges
        
        
joyous:

        addi t2,    fp, 28         # addiu   $2,$fp,28
        # rearr: placed lasw3 ra, whispering before mv t4, t2 so lasw3 hides t2 latency with 0 s
        lasw3 ra,   whispering     # la      $ra, whispering
        mv   t4,    t2             # move    $4,$2
        j    next_edge
        
        
whispering:

        sw   t2, 24(fp)            # sw      $2,24($fp)
        j    turkey
        
        

iterate_edges:
        addi sp,    sp, -24        # addiu   $sp,$sp,-24
        
        
        
        sw   fp, 20(sp)            # sw      $fp,20($sp)
        mv   fp,    sp             # move    $fp,$sp
        
        
        
        sub  t6,    fp, sp         # subu    $at, $fp, $sp
        sw   t4, 24(fp)            # sw      $4,24($fp)
        sw   t5, 28(fp)            # sw      $5,28($fp)
        lw   t2, 28(fp)            # lw      $2,28($fp)
        # rearr: placed sw x0, 12(fp) in lw t2 hazard window
        sw   x0, 12(fp)            # sw      $0,12($fp)
        
        
        sw   t2,  8(fp)            # sw      $2,8($fp)
        lw   t2, 24(fp)            # lw      $2,24($fp)
        lw   t4,  8(fp)            # lw      $4,8($fp)
        lw   t3, 12(fp)            # lw      $3,12($fp)
        
        
        sw   t4,  0(t2)            # sw      $4,0($2)
        sw   t3,  4(t2)            # sw      $3,4($2)
        # rearr: placed mv sp, fp right after lw t2, 24(fp) to overlap their latencies
        lw   t2, 24(fp)            # lw      $2,24($fp)
        mv   sp,    fp             # move    $sp,$fp
        
        
        
        lw   fp, 20(sp)            # lw      $fp,20($sp)
        addi sp,    sp, 24         # addiu   $sp,$sp,24
        
        
        jr   ra                    # jr      $ra
        
        
        
next_edge:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        
        
        
        sw   ra, 28(sp)            # sw      $31,28($sp)
        sw   fp, 24(sp)            # sw      $fp,24($sp)
        add  fp,    x0, sp         # add     $fp,$zero,$sp
        
        
        
        sw   t4, 32(fp)            # sw      $4,32($fp)
        j    waggish
        
        

snail:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        
        
        
        lw   t3,  0(t2)            # lw      $3,0($2)
        lw   t2, 32(fp)            # lw      $2,32($fp)
        lw   t2,  4(t2)            # lw      $2,4($2)
        # rearr: placed lasw3 ra, induce before mv t5/t4 so its 5 instructions hide lw t3 and lw t2 latency
        lasw3 ra,   induce         # la      $ra,induce
        mv   t5,    t2             # move    $5,$2
        mv   t4,    t3             # move    $4,$3
        j    has_edge
        
        
induce:
        beq  t2,    x0, quarter    # beq     $2,$0,quarter
        
        
        lw   t2, 32(fp)            # lw      $2,32($fp)
        
        
        
        lw   t2,  4(t2)            # lw      $2,4($2)
        # rearr: moved lw t3, 32(fp) into lw t2 hazard window to save 1 
        lw   t3, 32(fp)            # lw      $3,32($fp)
        
        
        addi t4,    t2, 1          # addiu   $4,$2,1
        
        
        
        sw   t4,  4(t3)            # sw      $4,4($3)
        j    cynical
        
        

quarter:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        
        
        
        lw   t2,  4(t2)            # lw      $2,4($2)
        
        
        
        addi t3,    t2, 1          # addiu   $3,$2,1
        lw   t2, 32(fp)            # lw      $2,32($fp)
        
        
        
        sw   t3,  4(t2)            # sw      $3,4($2)

waggish:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        
        
        
        lw   t2,  4(t2)            # lw      $2,4($2)
        
        
        
        slti t2,    t2, 4          # slti    $2,$2,4
        
        
        
        beq  t2,    x0, mark       # beq     $2,$zero,mark # beq, j to simulate bne 
        
        
        j    snail
        
        
mark:
        li   t2, -1                # li      $2,-1

cynical:
        mv   sp,    fp             # move    $sp,$fp
        
        
        
        lw   ra, 28(sp)            # lw      $31,28($sp)
        lw   fp, 24(sp)            # lw      $fp,24($sp)
        addi sp,    sp, 32         # addiu   $sp,$sp,32
        
        
        jr   ra                    # jr      $ra
        
        
has_edge:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        
        
        
        sw   fp, 28(sp)            # sw      $fp,28($sp)
        mv   fp,    sp             # move    $fp,$sp
        
        
        
        sw   t4, 32(fp)            # sw      $4,32($fp)
        sw   t5, 36(fp)            # sw      $5,36($fp)
        lasw3 t2,   adjacencymatrix# la      $2,adjacencymatrix
        lw   t3, 32(fp)            # lw      $3,32($fp)
        
        
        
        slli t3,    t3, 2          # sll     $3,$3,2
        
        
        
        add  t2,    t3, t2         # addu    $2,$3,$2
        
        
        
        lw   t2,  0(t2)            # lw      $2,0($2)
        
        
        
        # rearr: interleaved sw t2, 16(fp), li t2, 1, and sw x0, 12(fp) to save 2 s before sw t2, 8(fp)
        sw   t2, 16(fp)            # sw      $2,16($fp)
        li   t2,  1                # li      $2,1
        sw   x0, 12(fp)            # sw      $0,12($fp)
        
        
        sw   t2,  8(fp)            # sw      $2,8($fp)
        j    measley
        
        

look:
        lw   t2,  8(fp)            # lw      $2,8($fp)
        
        
        
        slli t2,    t2, 1          # sll     $2,$2,1
        
        
        
        # rearr: started lw t2, 12(fp) immediately after sw t2, 8(fp) since sw only reads t2 in ID
        sw   t2,  8(fp)            # sw      $2,8($fp)
        lw   t2, 12(fp)            # lw      $2,12($fp)
        
        
        
        addi t2,    t2, 1          # addiu   $2,$2,1
        
        
        
        sw   t2, 12(fp)            # sw      $2,12($fp)
measley:
        lw   t3, 12(fp)            # lw      $3,12($fp)
        lw   t2, 36(fp)            # lw      $2,36($fp)
        
        
        
        slt  t2,    t3, t2         # slt     $2,$3,$2
        
        
        
        beq  t2,    x0, experience # beq     $2,$0,experience # beq, j to simulate bne 
        
        
        j    look
        
        
experience:
        lw   t3,  8(fp)            # lw      $3,8($fp)
        lw   t2, 16(fp)            # lw      $2,16($fp)
        
        
        
        and  t2,    t3, t2         # and     $2,$3,$2
        
        
        
        slt  t2,    x0, t2         # slt     $2,$0,$2
        # rearr: moved mv sp, fp into slt t2 hazard window so sp is ready right after andi t2
        mv   sp,    fp             # move    $sp,$fp
        
        
        andi t2,    t2, 0xff       # andi    $2,$2,0x00ff
        lw   fp, 28(sp)            # lw      $fp,28($sp)
        addi sp,    sp, 32         # addiu   $sp,$sp,32
        
        
        jr   ra                    # jr      $ra
        
        
        
mark_visited:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        
        
        
        sw   fp, 28(sp)            # sw      $fp,28($sp)
        mv   fp,    sp             # move    $fp,$sp
        # rearr: moved li t2, 1 into mv fp, sp hazard window to save 3 s!
        li   t2,  1                # li      $2,1
        
        
        sw   t4, 32(fp)            # sw      $4,32($fp)
        sw   t2,  8(fp)            # sw      $2,8($fp)
        sw   x0, 12(fp)            # sw      $0,12($fp)
        j    recast
        
        

example:
        lw   t2,  8(fp)            # lw      $2,8($fp)
        
        
        
        slli t2,    t2, 8          # sll     $2,$2,8
        
        
        
        sw   t2,  8(fp)            # sw      $2,8($fp)
        lw   t2, 12(fp)            # lw      $2,12($fp)
        
        
        
        addi t2,    t2, 1          # addiu   $2,$2,1
        
        
        
        sw   t2, 12(fp)            # sw      $2,12($fp)
recast:
        lw   t3, 12(fp)            # lw      $3,12($fp)
        lw   t2, 32(fp)            # lw      $2,32($fp)
        
        
        
        slt  t2,    t3, t2         # slt     $2,$3,$2
        
        
        
        beq  t2,    x0, pat        # beq     $2,$zero,pat # beq, j to simulate bne
        
        
        j    example
        
        
pat:

       	lasw3 t2, visited            # la      $2, visited
        
        
        
        sw   t2, 16(fp)              # sw      $2,16($fp)
        lw   t2, 16(fp)              # lw      $2,16($fp)
        
        
        
        lw   t3,  0(t2)              # lw      $3,0($2)
        lw   t2,  8(fp)              # lw      $2,8($fp)
        
        
        
        or   t3,    t3, t2           # or      $3,$3,$2
        lw   t2, 16(fp)              # lw      $2,16($fp)
        # rearr: moved mv sp, fp into lw t2 / or t3 hazard window to save 3 s
        mv   sp,    fp               # move    $sp,$fp
        
        
        sw   t3,  0(t2)              # sw      $3,0($2)
        lw   fp, 28(sp)              # lw      $fp,28($sp)
        addi sp,    sp, 32           # addiu   $sp,$sp,32
        
        
        jr   ra                      # jr      $ra
        
        
        
is_visited:
        addi sp,    sp, -32          # addiu   $sp,$sp,-32
        
        
        
        sw   fp, 28(sp)              # sw      $fp,28($sp)
        mv   fp,    sp               # move    $fp,$sp
        # rearr: moved ori t2, x0, 1 into mv fp, sp hazard window to save 3 s!
        ori  t2,    x0, 1            # ori     $2,$zero,1
        
        
        sw   t4, 32(fp)              # sw      $4,32($fp)
        sw   t2,  8(fp)              # sw      $2,8($fp)
        sw   x0, 12(fp)              # sw      $0,12($fp)
        j    evasive
        
        

justify:
        lw   t2,  8(fp)              # lw      $2,8($fp)
        
        
        
        slli t2,    t2, 8            # sll     $2,$2,8
        
        
        
        sw   t2,  8(fp)              # sw      $2,8($fp)
        lw   t2, 12(fp)              # lw      $2,12($fp)
        
        
        
        addi t2,    t2, 1            # addiu   $2,$2,1
        
        
        
        sw   t2, 12(fp)              # sw      $2,12($fp)
evasive:
        lw   t3, 12(fp)              # lw      $3,12($fp)
        lw   t2, 32(fp)              # lw      $2,32($fp)
        
        
        
        slt  t2,    t3, t2           # slt     $2,$3,$2
        
        
        
        beq  t2,    x0,representative# beq $2,$0,representitive # beq, j to simulate bne
        
        
        j    justify
        
        
representative:

        lasw3 t2,   visited          # la      $2,visited
        
        
        
        lw   t2,  0(t2)              # lw      $2,0($2)
        
        
        
        sw   t2, 16(fp)              # sw      $2,16($fp)
        lw   t3, 16(fp)              # lw      $3,16($fp)
        lw   t2,  8(fp)              # lw      $2,8($fp)
        
        
        
        and  t2,    t3, t2           # and     $2,$3,$2
        
        
        
        slt  t2,    x0, t2           # slt     $2,$0,$2
        # rearr: moved mv sp, fp into slt t2 hazard window so sp is ready right after andi t2
        mv   sp,    fp               # move    $sp,$fp
        
        
        andi t2,    t2, 0xff         # andi    $2,$2,0x00ff
        lw   fp, 28(sp)              # lw      $fp,28($sp)
        addi sp,    sp, 32           # addiu   $sp,$sp,32
        
        
        jr   ra                      # jr      $ra
        
        

end:
        wfi