# This test is a sequence of small jumps to make sure
# its skipping instructions correctly.

.data

.text
.globl main

main:
# Zeroing registers
addi t0, zero, 0
addi t1, zero, 0
jal ra, step1
# This shouldn't run
addi t0, t0, 1

step1:
addi t1, t1, 1
jal ra, step2
# This shouldn't run
addi t0, t0, 1

step2:
addi t1, t1, 1
jal ra, step3
# This shouldn't run
addi t0, t0, 1

step3:
addi t1, t1, 1
# t1 should be at 3, t0 should be at 0 by end
wfi