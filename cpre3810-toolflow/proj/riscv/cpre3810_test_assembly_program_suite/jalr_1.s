# jalr_adrian88_1
# Basic jump and link. x30=1 pass, x30=-1 fail (x31 = failing test)
# Each target adds 1 to x29; a wrong landing skips it and fails the count at the end.

.data
tbl:
	.word	t1_tgt,t1_ret
	.word	t2_tgt,t2_ret
	.word	t3_tgt,t3_ret
	.word	func,t4_ret

.text
.globl	main

main:
	lui	x8,0x10010		# x8 = tbl (start of .data)
	addi	x29,x0,0

	# Test 1: forward jump, link must be PC+4 (common case: jump + correct return address)
	addi	x31,x0,1
	lw	x10,0(x8)
	lw	x11,4(x8)
	jalr	x1,x10,0
t1_ret:
	jal	x0,fail
t1_tgt:
	addi	x29,x29,1
	bne	x1,x11,fail

	# Test 2: backward jump, different rd (target below PC; link not hardwired to x1)
	addi	x31,x0,2
	jal	x0,t2_setup
	jal	x0,fail
t2_tgt:
	addi	x29,x29,1
	bne	x2,x11,fail
	jal	x0,t3_start
t2_setup:
	lw	x10,8(x8)
	lw	x11,12(x8)
	jalr	x2,x10,0
t2_ret:
	jal	x0,fail

	# Test 3: rd = x0, link must be discarded (jr/ret encoding; x0 must stay 0)
t3_start:
	addi	x31,x0,3
	lw	x10,16(x8)
	lw	x11,20(x8)
	jalr	x0,x10,0
t3_ret:
	jal	x0,fail
t3_tgt:
	addi	x29,x29,1
	beq	x0,x11,fail		# x0 must not hold the link

	# Test 4: call and return using only jalr (function pointer call + ret idiom)
	addi	x31,x0,4
	lw	x10,24(x8)
	lw	x11,28(x8)
	jalr	x1,x10,0
t4_ret:
	addi	x29,x29,1		# return landed here
	jal	x0,pass

	jal	x0,fail
func:
	addi	x29,x29,1		# call landed here
	bne	x1,x11,fail
	jalr	x0,x1,0			# return
	jal	x0,fail

pass:
	addi	x21,x0,5		# 5 targets
	bne	x29,x21,fail
	addi	x30,x0,1
	jal	x0,done
fail:
	addi	x30,x0,-1
done:

wfi