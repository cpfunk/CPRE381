.data

.text
.globl main



main:
	addi x1, x0, 10
	addi x2, x0, 10

	# Compare equal non-zero registers 10 == 10 should NOT branch
	bne x1, x2, fail_case

	addi x3, x0, 1
	jal zero, end

fail_case:
	addi x3, x0, 0 # if x3 is zero test failed
	
end:


wfi