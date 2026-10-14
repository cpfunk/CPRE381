.data

.text
.globl main

main:

# Test 1: compare with an arbitrary positive value
addi s0, x0, 20 # put arbitrary positive val in s0 for comparisons
slti t0, s0, 0x7FF # verify max immediate value results in 1
slti t1, s0, 21 # verify imm = val+1 results in 1
slti t2, s0, 20 # verify imm = val results in 0
slti t3, s0, 19 # verify imm = val-1 results in 0
slti t4, s0, 0 # verify imm = 0 results in 0
slti t5, s0, -21 # verify negative imm value with absolute value greater than val results in 0
slti t6, s0, -2048 # verify min immediate value results in 0

end:

wfi