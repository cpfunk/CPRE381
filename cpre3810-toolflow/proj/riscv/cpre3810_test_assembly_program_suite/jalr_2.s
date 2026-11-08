# jalr_adrian88_3
# Hazards around jalr. x30=1 pass, x30=-1 fail (x31 = failing test)
# Each target adds 1 to x29; a wrong landing skips it and fails the count at the end.

.data
tbl:
	.word	t1_tgt,t1_ret
	.word	t2_tgt,t2_ret
	.word	t3_tgt,t3_ret
	.word	t4_tgt,t4_ret
	.word	t5_tgt,t5_ret
	.word	t6_tgt
	.word	t7_tgt

.text
.globl	main

main:
	lui	x8,0x10010		# x8 = tbl (start of .data)
	addi	x29,x0,0

	# Test 1: rd = rs1 (target must use old rs1 before link overwrites it)
	addi	x31,x0,1
	lw	x10,0(x8)
	lw	x11,4(x8)
	jalr	x10,x10,0
t1_ret:
	jal	x0,fail
t1_tgt:
	addi	x29,x29,1
	bne	x10,x11,fail

	# Test 2: rd = rs1 with nonzero imm (same hazard with the imm added)
	addi	x31,x0,2
	lw	x12,8(x8)
	addi	x12,x12,-4
	lw	x11,12(x8)
	jalr	x12,x12,4
t2_ret:
	jal	x0,fail
t2_tgt:
	addi	x29,x29,1
	bne	x12,x11,fail

	# Test 3: rs1 loaded right before (load-use hazard; pipeline must stall)
	addi	x31,x0,3
	addi	x13,x0,0
	lw	x11,20(x8)
	lw	x13,16(x8)
	jalr	x1,x13,0
t3_ret:
	jal	x0,fail
t3_tgt:
	addi	x29,x29,1
	bne	x1,x11,fail

	# Test 4: rs1 from addi right before (EX/MEM forwarding into jalr)
	addi	x31,x0,4
	lw	x11,28(x8)
	lw	x14,24(x8)
	addi	x14,x14,-16
	addi	x14,x14,16
	jalr	x1,x14,0
t4_ret:
	jal	x0,fail
t4_tgt:
	addi	x29,x29,1
	bne	x1,x11,fail

	# Test 5: one instruction between producer and jalr (MEM/WB forwarding)
	addi	x31,x0,5
	lw	x11,36(x8)
	lw	x15,32(x8)
	addi	x15,x15,8
	addi	x15,x15,-8
	addi	x16,x0,0
	jalr	x1,x15,0
t5_ret:
	jal	x0,fail
t5_tgt:
	addi	x29,x29,1
	bne	x1,x11,fail

	# Test 6: jalr uses link from previous jalr (forwarding of the link value)
	addi	x31,x0,6
	lw	x17,40(x8)
	jalr	x1,x17,0
t6_ret:
	jal	x0,fail			# skipped by return to t6_ret+4
	addi	x29,x29,1		# return landed here

	# Test 7: instructions after jalr must not execute (pipeline flush on jump)
	addi	x31,x0,7
	addi	x20,x0,0
	lw	x18,44(x8)
	jalr	x0,x18,0
	addi	x20,x20,1
	addi	x20,x20,2
	jal	x0,fail
t7_tgt:
	addi	x29,x29,1
	bne	x20,x0,fail
	jal	x0,pass

	jal	x0,fail
t6_tgt:
	jalr	x0,x1,4			# uses x1 written by the jalr just before
	jal	x0,fail

pass:
	addi	x21,x0,7		# 7 counted landings
	bne	x29,x21,fail
	addi	x30,x0,1
	jal	x0,done
fail:
	addi	x30,x0,-1
done:

wfi