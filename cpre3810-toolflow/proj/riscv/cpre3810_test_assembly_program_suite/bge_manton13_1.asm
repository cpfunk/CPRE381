.data

.text
.global main

main:
	#Start Test 1 - following the correct path of greater than, equals, less than
	#tests common cases to see if registers are read correctly
	#verifies that basic branching works withpositive numbers
	
	addi t1, x0, 1
	addi t2, x0, 2
	bge t2, t1, test2 # check t2 >= t1
	addi t3, x0, -1 #happens if it says t2 < t1
	test2:
		addi t1,x0,2 # t1 and t2 equal 2
		bge t1, t2, test3 # t1 = t2 so it should go to nest test
		addi t4, x0, -2 # failed to branch right when values equal
	test3:
		addi t1, x0, 1 # t1 = 1 and t2 = 2 
		bge t1, t2, end # shouldn't branch if t1 < t2
		addi t5, x0, 3 # if t1 < t2
	end:

wfi