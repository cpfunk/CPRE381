#given that it is just or its difficult to think of test cases beyond yep thats or
.data
.text
.globl main
main:
#Aidan Griffith or test 2 checking writing to register specifics

#test to check that or cannot write to register 0
addi t0, x0, 20 #addi needed to actually intialize registers
addi t1, x0, 200
or x0, t0, t1
addi, t2, x0, 0 #checks that 0 is still 0

#checking that x or x results in x unchanged
addi t0, x0, 0
lui t0, 0x12345 #checks that the top end or works too
addi t0, t0, 0x678
or t3, t0, t0 #shoudl result in 0x12345678

#test to check that or overwrites register or t1, t1, t2, t1 is overwritten while still comparing itself
addi s0, x0, 0x0F0
addi s1, x0, 0x00F
or s0, s0, s1 #should result in s0 being 000000FF 

end:


wfi