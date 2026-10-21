.data

.text
.globl main

main:
#this is a nornal test case where we test if the bltu branches
#this test case has vaule because it tests the implementation 
# of bltu uses some of the same HW as blt. it tests if implementating
#the unsigned function effected the comparison unit.
#in this case bltu should result no diffenert than blt.

# Start Test
addi x1, x0, 1  #set x1 to 1        
addi x2, x0, 2  #set x2 to 2
addi x3, x0, 0  #clear x3 to store the results  

bltu x1, x2, brench #branch if x1 < x2 (true)

#this will get skiped
addi x3, x0, -1 # sets x3 to -1 if branching fails 

brench: 
addi x3, x3, 1 # add 1 to x3

#if x3 is 0 this test failed
#if x3 is 1 this test passed

  end:
	
wfi