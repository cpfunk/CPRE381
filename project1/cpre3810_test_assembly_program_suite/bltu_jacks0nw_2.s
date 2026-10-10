# test 2: equality case
#  check bltu does not branch when operands are equal

.data
.text
.globl main

main:
#start test
addi x1, x0, 15       
addi x2, x0, 15      

bltu x1, x2, fail     # Should NOT branch because values are equal

addi x3, x0, 3 # x3 won't update if fail

fail:
addi x4, x0, 4

#both x3 and x4 update on success

wfi