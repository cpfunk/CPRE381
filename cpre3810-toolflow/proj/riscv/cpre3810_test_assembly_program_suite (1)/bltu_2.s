.data

.text
.globl main

main:
#this test has value because it testes if the unsign functions works
#unlike blt this function should branch 


# Start Test
addi x1, x0, 1  #set x1 to 0x00000001       
addi x2, x0, -1  #set x2 to 0xFFFFFFFF
addi x3, x0, 0  #clear x3 to store the results  

bltu x1, x2, brench #branch if x1 < x2 (ture)

#this will get skiped
addi x3, x0, -1 # sets x3 to -1 if branching fails 

brench: 
addi x3, x3, 1 # add 1 to x3

#if x3 is 0 this test failed
#if x3 is 1 this test passed


  end:

wfi