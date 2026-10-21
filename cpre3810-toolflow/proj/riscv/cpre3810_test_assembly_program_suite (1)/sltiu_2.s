.data

.text
.globl main

main:

	#Start Test
	
	#Unsigned Test Cases (u of sltiu)
	#Testing cases of the specific behavior of
	#unsigned comparisons (-1 being the largest number)
	#unsigned behavior flips positive and negative 
	#comparisons but not negative and negative or 
	#positive and positive comparisons
	
	addi t0, x0, -1 #Initialize Register
	sltiu t1, t0, 1
	#t1 should be 0 ((unsigned)-1 > 1)
	
	sltiu t2, t0, -1
	#t2 should be 0 (-1 = -1)
	
	addi t0, x0, -2
	sltiu t3, t0, -1
	#t3 should be 1 (-2 < -1)
	
	addi t0, x0, 1
	sltiu t4, t0, -1
	#t4 should be 1 (1 < (unsigned)-1)
	
	sltiu t5, x0, -1
	#t5 should be 1 (0 < (unsigned)-1)
	
	addi t0, x0, -2048 #Smallest negative value
	sltiu t6, t0, 1 #Smallest positive value
	#t6 should be 0 ((unsigned)-2048 > 1)
	
end:

wfi