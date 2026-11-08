.data

.text
.globl main

main:
#this test is a edge case where both vaules are equal 
#this case has value because neither vaules is greater 
#or less then the other. we tested if the value if greater
#but we still need to test if the value is the same.

# Start Test
addi x1, x0, -1  #set x1 to 0xFFFFFFFF      
addi x2, x0, -1  #set x2 to 0xFFFFFFFF
addi x3, x0, 0  #clear x3 to store the results  

bltu  x1, x2, brench #branch if x1 < x2 (false)

#this will not get skiped
addi x3, x0, 1 # sets x3 to -1 if branching fails 

brench: 

#if x3 is 0 this test failed
#if x3 is 1 this test passed


  end:

wfi