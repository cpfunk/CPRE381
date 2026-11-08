.data

.text
.globl main

main:

	#Start Test
	
	#Common Case (Testing normal activity of sltiu)
	#So testing values assigned to rd based on expected
	#activity of the command >, <, and =. 
	addi t0, x0, 3 #Initialize Register 
	sltiu t1, t0, 5
	#t1 should be 1 (3 < 5)
	
	addi t0, x0, 100 #Initialize Register
	sltiu t2, t0, 5
	#t2 should be 0 (100 > 5)
	
	addi t0, x0, 6 #Initialize Register
	sltiu t3, t0, 6
	#t3 should be 0 (6 = 6)
	
	sltiu t4, x0, 1
	#t4 should be 1 (0 < 1)
	
	sltiu t5, x0, 0
	#t5 should be 0 (0 = 0)
	
	addi t0, x0, 2046 #2nd highest 12-bit signed-number
	sltiu t6, t0, 2047 #Highest 12-bit signed-number
	#t6 should be 1 (2046 < 2047)
	
end:
	
wfi