.data

.text
.globl main

main:

# Start Test
# Tests basic beq functionality by verifying both taken and not-taken branches across multiple registers.

# Load Registers with compare values
# Two equal registers
addi x1, x0, 4
addi x2, x0, 4

# Unequal register (used to verify branch not taken)
addi x3, x0, 7

# Registers to be used to test resultant beq behavior
addi x4, x0, 10
addi x6, x0, 11
addi x7, x0, 11


## Test A ## Branch should be taken because x1 == x2 (4 == 4)
beq x1, x2, testA_pass

addi x4, x0, 1             # should be skipped

testA_pass:


## Test B ## Branch should NOT be taken because x1 != x3 (4 != 7)
beq x1, x3, testB_fail
addi x5, x0, 10             # should execute

testB_fail:


## Test C ## Branch should be taken because x4 == x5 (10 == 10)
beq x4, x5, testC_pass     # x5 set in Test B
addi x6, x0, 1             # should be skipped

testC_pass:


## Test D ## Branch should be taken because x6 = x7 (11 == 11)
beq x6, x7, testD_pass
addi x8, x0, 170           # should be skipped

testD_pass:

# Proper beq implementation should result in x8 with a value of 0

end:

wfi