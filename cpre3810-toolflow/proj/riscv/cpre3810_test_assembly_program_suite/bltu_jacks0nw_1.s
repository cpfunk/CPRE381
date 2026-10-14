#test 1: unsigned comparison
# check that bltu branches when rs1 < rs2 using positve values

.data
.text
.globl main

main:
#start test
addi x1, x0, 5        
addi x2, x0, 10     

bltu x1, x2, pass     # should branch since 5 < 10

# If branch fails, execute this instruction
addi x3, x0, 1        # Indicates failure path

pass:
addi x4, x0, 2        # Indicates correct branch path


wfi