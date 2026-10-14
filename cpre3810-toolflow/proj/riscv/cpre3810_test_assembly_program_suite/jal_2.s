# This test is a sequence of small jumps backward
# and forward to make sure PC can be decremented.

.data

.text
step1:
addi t1, t1, 1
jal ra, step2
# This shouldn't run
addi t0, t0, 1

step3:
addi t1, t1, 1
jal ra, step4
# This shouldn't run
addi t0, t0, 1

step2:
addi t1, t1, 1
jal ra, step3
# This shouldn't run
addi t0, t0, 1

.globl main

main:
# Zeroing registers
addi t0, zero, 0
addi t1, zero, 0
jal ra, step1
# This shouldn't run
addi t0, t0, 1

step4:
addi t1, t1, 1
# t1 should be 4, t0 should be 0 by end
wfi