# test 3: unsigned comparison with negative numbers
# check bltu treats values as unsigned
.data
.text
.globl main

main:
#start test
addi x1, x0, -1       # x1 = 0xFFFFFFFF
addi x2, x0, 1      

bltu x1, x2, fail     # should not branch b/c unsigned(0xFFFFFFFF) > 1

# Correct path
addi x3, x0, 5

fail:
addi x4, x0, 6


wfi