.data
.text
.globl main
main:
#check if the jump and link put correct value in the return register
addi t0, t0,0
la t1, Target
jal t0, Target#the function we want to test
Target: 
Beq t1,t0, End
addi t3,t3,8
End:
wfi