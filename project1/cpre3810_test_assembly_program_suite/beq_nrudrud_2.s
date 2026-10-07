.data

.text
.globl main

main:

# Start Test
# Tests beq edge cases including zero comparisons, negative values, and same-register comparisons.

# Load Registers with edge-case values

# Zero values for zero comparison tests
addi x1, x0, 0
addi x2, x0, 0

# Negative values
addi x3, x0, -5
addi x4, x0, -5

# Different negative value
addi x5, x0, -7

# Register for same-register comparison
addi x6, x0, 12


## Test A ## Branch should be taken because x1 == x2 (0 == 0)
beq x1, x2, testA_pass

addi x8, x0, 170           # should be skipped

testA_pass:


## Test B ## Branch should be taken because x6 == x6 (same register comparison)
beq x6, x6, testB_pass

addi x8, x0, 170           # should be skipped

testB_pass:


## Test C ## Branch should be taken because x3 == x4 (-5 == -5)
beq x3, x4, testC_pass

addi x8, x0, 170           # should be skipped

testC_pass:


## Test D ## Branch should NOT be taken because x3 != x5 (-5 != -7)
beq x3, x5, testD_fail
addi x7, x0, 9             # should execute

testD_fail:


## Test E ## Branch should be taken because x1 == x0 (explicit zero register comparison)
beq x1, x0, testE_pass

addi x8, x0, 170           # should be skipped

testE_pass:

# Proper beq implementation should result in x8 with a value of 0

end:

wfi