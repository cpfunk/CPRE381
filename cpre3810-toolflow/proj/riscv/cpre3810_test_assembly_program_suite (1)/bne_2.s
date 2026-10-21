.data

.text
.globl main



main:
	addi x1, x0, 25
	addi x2, x0, 10

	# Compare first input bigger should branch
	bne x1, x2, pass_case

	addi x3, x0, 0
	jal zero, end

pass_case:
	addi x3, x0, 1 #if x3 is one success
	
end:


wfi