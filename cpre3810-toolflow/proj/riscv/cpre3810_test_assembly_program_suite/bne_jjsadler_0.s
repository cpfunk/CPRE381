.data
.text
.globl main

main:

	#start test

addi x1, x0, 5
addi x2, x0, 5  #placing equal values into to registers 

bne x1, x2, fail 
#should not branch because x1 and x2 are equal. If it does branch there is an issue
#check the PC to make sure it is only PC + 4 and not branching to fail
exit: 

fail:
wfi