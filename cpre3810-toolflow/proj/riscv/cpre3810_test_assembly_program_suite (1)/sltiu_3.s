.data

.text
.globl main

main:

	#Start Test
	
	#Edge-Case Testing
	
	#12-bit signed immediate boundary
	addi t0, x0, -2048
	sltiu t1, t0, 2047
	#t1 should be 0 ((unsigned)-2048 > 2047)
	
	#Writing to same register that is operated on
	addi t2, x0, 2
	sltiu t2, t2, 3
	#t2 should be 1 (2 < 3)
	
	#Function can't write to x0
	addi t0, x0, 3
	sltiu x0, t0, 5
	#x0 should be 0 (3 < 5 = 1 & 0 = 0)
	
	#Largest positive signed compared against negative imm
	lui t0, 0x80000 
	addi t0, t0, -1 #t0 is now 0x7FFFFFFF
	sltiu t3, t0, -2048
	#t3 should be 1 (0x7FFFFFFF < -2048(unsigned))
	
	#Consecutive sltiu instructions
	sltiu t0, x0, 0
	#t0 should be 0 (0 = 0)
	sltiu t4, t0, 1
	#t4 should be 1 (0 < 1)
	
end:

wfi