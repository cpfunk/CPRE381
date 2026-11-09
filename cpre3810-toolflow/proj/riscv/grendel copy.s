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
	# Rearr used lui for 0x10011000 and lasw3 for pump so address generation has no internal data hazard
	lui  sp, 0x10011           # li $sp, 0x10011000
	li   fp, 0                 # li $fp, 0
	lasw3 ra, pump              # la $ra pump
	j    main
	nop
	nop
pump:
        j end
        nop
        nop
	ebreak                     # halt


main:
        addi sp,    sp, -40        # addiu   $sp,$sp,-40
        nop
        nop
        nop
        sw   ra, 36(sp)            # sw      $31,36($sp)
        sw   fp, 32(sp)            # sw      $fp,32($sp)
        add  fp,    sp, x0         # add     $fp,$sp,$zero
        sw   x0, 24(sp)            # sw      $0,24($fp)
        j    main_loop_control
        nop
        nop

main_loop_body:
        lw   t4, 24(fp)            # lw      $4,24($fp)
        lasw3 ra,    trucks         # la      $ra, trucks
        j    is_visited
        nop
        nop
trucks:

        xori t2,    t2, 1          # xori    $2,$2,0x1
        nop
        nop
        nop
        andi t2,    t2, 0xff       # andi    $2,$2,0x00ff
        nop
        nop
        nop
        beq  t2,    x0, kick       # beq     $2,$0,kick
        nop
        nop

        lw   t4, 24(fp)            # lw      $4,24($fp)
                                   # ; addi    $k0, $k0,1# breakpoint
        lasw3 ra,    billowy        # la      $ra, billowy
        j    topsort
        nop
        nop
billowy:

kick:
        lw   t2, 24(fp)            # lw      $2,24($fp)
        nop
        nop
        nop
        addi t2,    t2, 1          # addiu   $2,$2,1
        nop
        nop
        nop
        sw   t2, 24(fp)            # sw      $2,24($fp)
main_loop_control:
        lw   t2, 24(fp)            # lw      $2,24($fp)
        nop
        nop
        nop
        slti t2,    t2, 4          # slti    $2,$2, 4
        nop
        nop
        nop
        beq  t2,    x0, hew        # beq     $2, $zero, hew # beq, j to simulate bne 
        nop
        nop
        j    main_loop_body
        nop
        nop
hew:
        sw   x0, 28(fp)            # sw      $0,28($fp)
        j    welcome
        nop
        nop

wave:
        lw   t2, 28(fp)            # lw      $2,28($fp)
        nop
        nop
        nop
        addi t2,    t2, 1          # addiu   $2,$2,1
        nop
        nop
        nop
        sw   t2, 28(fp)            # sw      $2,28($fp)
welcome:
        lw   t2, 28(fp)            # lw      $2,28($fp)
        nop
        nop
        nop
        slti t2,    t2, 4          # slti    $2,$2,4
        nop
        nop
        nop
        xori t2,    t2, 1          # xori    $2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        nop
        nop
        nop
        beq  t2,    x0, wave       # beq     $2,$0,wave
        nop
        nop

        mv   t2,    x0             # move    $2,$0
        mv   sp,    fp             # move    $sp,$fp
        nop
        nop
        nop
        lw   ra, 36(sp)            # lw      $31,36($sp)
        lw   fp, 32(sp)            # lw      $fp,32($sp)
        addi sp, sp, 40            # addiu   $sp,$sp,40
        nop
        nop
        jr   ra                    # jr      $ra
        nop
        nop
        
interest:
        lw   t4, 24(fp)            # lw      $4,24($fp)
        lasw3 ra,    new            # la      $ra, new
        j    is_visited
        nop
        nop
new:
        xori t2,    t2, 1          # xori    $2,$2,0x1
        nop
        nop
        nop
        andi t2,    t2, 0x0ff      # andi    $2,$2,0x00ff
        nop
        nop
        nop
        beq  t2,    x0, tasteful   # beq     $2,$0,tasteful
        nop
        nop

        lw   t4, 24(fp)            # lw      $4,24($fp)
        lasw3 ra,    partner        # la      $ra, partner
        j    topsort
        nop
        nop
partner:

tasteful:
        addi t2,    fp, 28         # addiu   $2,$fp,28
        # Rearr computed t4 directly from fp + 28 to avoid 3-cycle RAW dependency on t2
        addi t4,    fp, 28         # move    $4,$2
        lasw3 ra,    badge          # la      $ra, badge
        j    next_edge
        nop
        nop
badge:
        sw   t2, 24(fp)            # sw      $2,24($fp)
        
turkey:
        lw   t3, 24(fp)            # lw      $3,24($fp)
        li   t2, -1                # li      $2,-1
        nop
        nop
        nop
        beq  t3,    t2, telling    # beq     $3,$2,telling # beq, j to simulate bne
        nop
        nop
        j    interest
        nop
        nop
telling:
        # NOTE: $v0 === $2
	lasw3 t2,    res_idx        # la      $v0, res_idx
	nop
	nop
	nop
	lw   t2,  0(t2)            # lw      $v0, 0($v0)
	# Rearr placed lasw3 t3, res_idx right after lw t2 so its 4 instructions hide lw t2 latency
        lasw3 t3,    res_idx        # la      $3, res_idx
        addi t4,    t2, -1         # addiu   $4,$2,-1
        slli t3,    t2, 2          # sll     $3,$2,2
        lasw3 t2,    res_idx
        nop
        nop
        nop
        sw   t4,  0(t2)            # sw      $4, 0($3)
        lasw3 t4,    res            # la      $4, res
                                   # ; lui     $3,%hi(res_idx)
                                   # ; sw      $4,%lo(res_idx)($3)
                                   # ; lui     $4,%hi(res)
        srli t3,    t3, 1          # srl     $3,$3,1
        nop
        nop
        nop
        srai t3,    t3, 1          # sra     $3,$3,1
        nop
        nop
        nop
        slli t3,    t3, 2          # sll     $3,$3,2
       
       	xor  t6,    ra, t2         # xor     $at, $ra, $2 # does nothing 
        or   t6,    ra, t2         # nor     $at, $ra, $2 # does nothing 
        # Rearr expanded neg and li 0xffff without internal hazards, and interleaved lw a0 / mv sp, fp during address addition
        sub  t6,    x0, t6
        
        lasw3 t2,    res            # la      $2, res
        lui  a1,    0x10
        nop
        nop
        nop
        addi a1,    a1, -1
        nop
        nop
        nop
        and  t6,    t2, a1         # andi    $at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        nop
        nop
        nop
        add  t2,    t4, t6         # addu    $2, $4, $at
        nop
        nop
        nop
        add  t2,    t3, t2         # addu    $2,$3,$2
        lw   t3, 48(fp)            # lw      $3,48($fp)
        mv   sp,    fp             # move    $sp,$fp
        nop
        nop
        sw   t3,  0(t2)            # sw      $3,0($2)
        lw   ra, 44(sp)            # lw      $31,44($sp)
        lw   fp, 40(sp)            # lw      $fp,40($sp)
        addi sp,    sp, 48         # addiu   $sp,$sp,48
        nop
        nop
        jr   ra                    # jr      $ra
        nop
        nop
   
topsort:
        addi sp,    sp, -48        # addiu   $sp,$sp,-48
        nop
        nop
        nop
        sw   ra, 44(sp)            # sw      $31,44($sp)
        sw   fp, 40(sp)            # sw      $fp,40($sp)
        mv   fp,    sp             # move    $fp,$sp
        nop
        nop
        nop
        sw   t4, 48(fp)            # sw      $4,48($fp)
        lw   t4, 48(fp)            # lw      $4,48($fp)
        lasw3 ra,    verse          # la      $ra, verse
        j    mark_visited
        nop
        nop
verse:

        addi t2,    fp, 28         # addiu   $2,$fp,28
        lw   t5, 48(fp)            # lw      $5,48($fp)
        # Rearr computed t4 directly from fp + 28 to avoid RAW hazard on t2
        addi t4,    fp, 28         # move    $4,$2
        lasw3 ra,    joyous         # la      $ra, joyous
        j    iterate_edges
        nop
        nop
joyous:

        addi t2,    fp, 28         # addiu   $2,$fp,28
        # Rearr computed t4 directly from fp + 28 to avoid RAW hazard on t2
        addi t4,    fp, 28         # move    $4,$2
        lasw3 ra,    whispering     # la      $ra, whispering
        j    next_edge
        nop
        nop
whispering:

        sw   t2, 24(fp)            # sw      $2,24($fp)
        j    turkey
        nop
        nop

iterate_edges:
        addi sp,    sp, -24        # addiu   $sp,$sp,-24
        nop
        nop
        nop
        sw   fp, 20(sp)            # sw      $fp,20($sp)
        mv   fp,    sp             # move    $fp,$sp
        nop
        nop
        nop
        sub  t6,    fp, sp         # subu    $at, $fp, $sp
        sw   t4, 24(fp)            # sw      $4,24($fp)
        sw   t5, 28(fp)            # sw      $5,28($fp)
        lw   t2, 28(fp)            # lw      $2,28($fp)
        sw   x0, 12(fp)            # sw      $0,12($fp)
        nop
        nop
        sw   t2,  8(fp)            # sw      $2,8($fp)
        lw   t2, 24(fp)            # lw      $2,24($fp)
        lw   t4,  8(fp)            # lw      $4,8($fp)
        lw   t3, 12(fp)            # lw      $3,12($fp)
        nop
        nop
        sw   t4,  0(t2)            # sw      $4,0($2)
        sw   t3,  4(t2)            # sw      $3,4($2)
        lw   t2, 24(fp)            # lw      $2,24($fp)
        mv   sp,    fp             # move    $sp,$fp
        nop
        nop
        nop
        lw   fp, 20(sp)            # lw      $fp,20($sp)
        addi sp,    sp, 24         # addiu   $sp,$sp,24
        nop
        nop
        jr   ra                    # jr      $ra
        nop
        nop
        
next_edge:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        nop
        nop
        nop
        sw   ra, 28(sp)            # sw      $31,28($sp)
        sw   fp, 24(sp)            # sw      $fp,24($sp)
        add  fp,    x0, sp         # add     $fp,$zero,$sp
        nop
        nop
        nop
        sw   t4, 32(fp)            # sw      $4,32($fp)
        j    waggish
        nop
        nop

snail:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        nop
        nop
        nop
        lw   t3,  0(t2)            # lw      $3,0($2)
        lw   t2,  4(t2)            # lw      $2,4($2)
        # Rearr moved lasw3 ra, induce before mv t5/t4 to hide lw t3 and lw t2 latency
        lasw3 ra,    induce         # la      $ra,induce
        mv   t5,    t2             # move    $5,$2
        mv   t4,    t3             # move    $4,$3
        nop
        nop
        j    has_edge
        nop
        nop
induce:
        beq  t2,    x0, quarter    # beq     $2,$0,quarter
        nop
        nop
        lw   t2, 32(fp)            # lw      $2,32($fp)
        nop
        nop
        nop
        lw   t2,  4(t2)            # lw      $2,4($2)
        lw   t3, 32(fp)            # lw      $3,32($fp)
        nop
        nop
        addi t4,    t2, 1          # addiu   $4,$2,1
        nop
        nop
        nop
        sw   t4,  4(t3)            # sw      $4,4($3)
        j    cynical
        nop
        nop

quarter:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        nop
        nop
        nop
        lw   t2,  4(t2)            # lw      $2,4($2)
        nop
        nop
        nop
        addi t3,    t2, 1          # addiu   $3,$2,1
        lw   t2, 32(fp)            # lw      $2,32($fp)
        nop
        nop
        sw   t3,  4(t2)            # sw      $3,4($2)

waggish:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        nop
        nop
        nop
        lw   t2,  4(t2)            # lw      $2,4($2)
        nop
        nop
        nop
        slti t2,    t2, 4          # slti    $2,$2,4
        nop
        nop
        nop
        beq  t2,    x0, mark       # beq     $2,$zero,mark # beq, j to simulate bne 
        nop
        nop
        j    snail
        nop
        nop
mark:
        li   t2, -1                # li      $2,-1

cynical:
        mv   sp,    fp             # move    $sp,$fp
        nop
        nop
        nop
        lw   ra, 28(sp)            # lw      $31,28($sp)
        lw   fp, 24(sp)            # lw      $fp,24($sp)
        addi sp,    sp, 32         # addiu   $sp,$sp,32
        nop
        nop
        jr   ra                    # jr      $ra
        nop
        nop
has_edge:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        nop
        nop
        nop
        sw   fp, 28(sp)            # sw      $fp,28($sp)
        mv   fp,    sp             # move    $fp,$sp
        nop
        nop
        nop
        sw   t4, 32(fp)            # sw      $4,32($fp)
        sw   t5, 36(fp)            # sw      $5,36($fp)
        # Rearr placed lw t3 before lasw3 t2 so lasw3's 4 instructions hide lw t3 latency
        lw   t3, 32(fp)            # lw      $3,32($fp)
        lasw3 t2,    adjacencymatrix# la      $2,adjacencymatrix
        slli t3,    t3, 2          # sll     $3,$3,2
        nop
        nop
        nop
        add  t2,    t3, t2         # addu    $2,$3,$2
        nop
        nop
        nop
        lw   t2,  0(t2)            # lw      $2,0($2)
        nop
        nop
        nop
        sw   t2, 16(fp)            # sw      $2,16($fp)
        li   t2,  1                # li      $2,1
        sw   x0, 12(fp)            # sw      $0,12($fp)
        nop
        nop
        sw   t2,  8(fp)            # sw      $2,8($fp)
        j    measley
        nop
        nop

look:
        lw   t2,  8(fp)            # lw      $2,8($fp)
        nop
        nop
        nop
        slli t2,    t2, 1          # sll     $2,$2,1
        nop
        nop
        nop
        sw   t2,  8(fp)            # sw      $2,8($fp)
        lw   t2, 12(fp)            # lw      $2,12($fp)
        nop
        nop
        nop
        addi t2,    t2, 1          # addiu   $2,$2,1
        nop
        nop
        nop
        sw   t2, 12(fp)            # sw      $2,12($fp)
measley:
        lw   t3, 12(fp)            # lw      $3,12($fp)
        lw   t2, 36(fp)            # lw      $2,36($fp)
        nop
        nop
        nop
        slt  t2,    t3, t2         # slt     $2,$3,$2
        nop
        nop
        nop
        beq  t2,    x0, experience # beq     $2,$0,experience # beq, j to simulate bne 
        nop
        nop
        j    look
        nop
        nop
experience:
        lw   t3,  8(fp)            # lw      $3,8($fp)
        lw   t2, 16(fp)            # lw      $2,16($fp)
        # Rearr moved mv sp, fp into lw t2 hazard window
        mv   sp,    fp             # move    $sp,$fp
        nop
        nop
        and  t2,    t3, t2         # and     $2,$3,$2
        nop
        nop
        nop
        slt  t2,    x0, t2         # slt     $2,$0,$2
        nop
        nop
        nop
        andi t2,    t2, 0xff       # andi    $2,$2,0x00ff
        lw   fp, 28(sp)            # lw      $fp,28($sp)
        addi sp,    sp, 32         # addiu   $sp,$sp,32
        nop
        nop
        jr   ra                    # jr      $ra
        nop
        nop
        
mark_visited:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        # Rearr moved li t2, 1 into sp hazard window
        li   t2,  1                # li      $2,1
        nop
        nop
        sw   fp, 28(sp)            # sw      $fp,28($sp)
        mv   fp,    sp             # move    $fp,$sp
        nop
        nop
        nop
        sw   t4, 32(fp)            # sw      $4,32($fp)
        sw   t2,  8(fp)            # sw      $2,8($fp)
        sw   x0, 12(fp)            # sw      $0,12($fp)
        j    recast
        nop
        nop

example:
        lw   t2,  8(fp)            # lw      $2,8($fp)
        nop
        nop
        nop
        slli t2,    t2, 8          # sll     $2,$2,8
        nop
        nop
        nop
        sw   t2,  8(fp)            # sw      $2,8($fp)
        lw   t2, 12(fp)            # lw      $2,12($fp)
        nop
        nop
        nop
        addi t2,    t2, 1          # addiu   $2,$2,1
        nop
        nop
        nop
        sw   t2, 12(fp)            # sw      $2,12($fp)
recast:
        lw   t3, 12(fp)            # lw      $3,12($fp)
        lw   t2, 32(fp)            # lw      $2,32($fp)
        nop
        nop
        nop
        slt  t2,    t3, t2         # slt     $2,$3,$2
        nop
        nop
        nop
        beq  t2,    x0, pat        # beq     $2,$zero,pat # beq, j to simulate bne
        nop
        nop
        j    example
        nop
        nop
pat:

       	lasw3 t2, visited             # la      $2, visited
        nop
        nop
        nop
        sw   t2, 16(fp)              # sw      $2,16($fp)
        lw   t2, 16(fp)              # lw      $2,16($fp)
        nop
        nop
        nop
        lw   t3,  0(t2)              # lw      $3,0($2)
        lw   t2,  8(fp)              # lw      $2,8($fp)
        nop
        nop
        nop
        or   t3,    t3, t2           # or      $3,$3,$2
        lw   t2, 16(fp)              # lw      $2,16($fp)
        # Rearr moved mv sp, fp into lw t2 / or t3 hazard window
        mv   sp,    fp               # move    $sp,$fp
        nop
        nop
        sw   t3,  0(t2)              # sw      $3,0($2)
        lw   fp, 28(sp)              # lw      $fp,28($sp)
        addi sp,    sp, 32           # addiu   $sp,$sp,32
        nop
        nop
        jr   ra                      # jr      $ra
        nop
        nop
        
is_visited:
        addi sp,    sp, -32          # addiu   $sp,$sp,-32
        # Rearr moved ori t2, x0, 1 into sp hazard window
        ori  t2,    x0, 1            # ori     $2,$zero,1
        nop
        nop
        sw   fp, 28(sp)              # sw      $fp,28($sp)
        mv   fp,    sp               # move    $fp,$sp
        nop
        nop
        nop
        sw   t4, 32(fp)              # sw      $4,32($fp)
        sw   t2,  8(fp)              # sw      $2,8($fp)
        sw   x0, 12(fp)              # sw      $0,12($fp)
        j    evasive
        nop
        nop

justify:
        lw   t2,  8(fp)              # lw      $2,8($fp)
        nop
        nop
        nop
        slli t2,    t2, 8            # sll     $2,$2,8
        nop
        nop
        nop
        sw   t2,  8(fp)              # sw      $2,8($fp)
        lw   t2, 12(fp)              # lw      $2,12($fp)
        nop
        nop
        nop
        addi t2,    t2, 1            # addiu   $2,$2,1
        nop
        nop
        nop
        sw   t2, 12(fp)              # sw      $2,12($fp)
evasive:
        lw   t3, 12(fp)              # lw      $3,12($fp)
        lw   t2, 32(fp)              # lw      $2,32($fp)
        nop
        nop
        nop
        slt  t2,    t3, t2           # slt     $2,$3,$2
        nop
        nop
        nop
        beq  t2,    x0,representative# beq $2,$0,representitive # beq, j to simulate bne
        nop
        nop
        j    justify
        nop
        nop
representative:

        lasw3 t2,    visited          # la      $2,visited
        nop
        nop
        nop
        lw   t2,  0(t2)              # lw      $2,0($2)
        nop
        nop
        nop
        sw   t2, 16(fp)              # sw      $2,16($fp)
        lw   t3, 16(fp)              # lw      $3,16($fp)
        lw   t2,  8(fp)              # lw      $2,8($fp)
        # Rearr moved mv sp, fp into lw t2 hazard window
        mv   sp,    fp               # move    $sp,$fp
        nop
        nop
        and  t2,    t3, t2           # and     $2,$3,$2
        nop
        nop
        nop
        slt  t2,    x0, t2           # slt     $2,$0,$2
        nop
        nop
        nop
        andi t2,    t2, 0xff         # andi    $2,$2,0x00ff
        lw   fp, 28(sp)              # lw      $fp,28($sp)
        addi sp,    sp, 32           # addiu   $sp,$sp,32
        nop
        nop
        jr   ra                      # jr      $ra
        nop
        nop

end:
        wfi