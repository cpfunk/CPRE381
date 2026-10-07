.data
.text
.globl main

main:
	#start test
addi x1, x0, 5
addi x2, x0, 6 

bne x1, x2, true 

#should not branch because x1 and x2 are equal. If it does branch there is an issue
#check the PC to make sure it is only PC + 4  and branching to true

true:
wfi