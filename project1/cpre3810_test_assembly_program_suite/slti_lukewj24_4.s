.data

.text
.globl main

main:

# Test 4: compare with an arbitrary negative value
addi s0, x0, -45 # put arbitrary negative val in s0 for comparisons
slti t0, s0, 0x7FF # verify max immediate value results in 1
slti t1, s0, 44 # verify positive imm value smaller than absolute value of val results in 1
slti t2, s0, 0 # verify imm = 0 results in 1
slti t3, s0, -44 # verify imm = val+1 results in 1
slti t4, s0, -45 # verify imm = val results in 0
slti t5, s0, -46 # verify imm = val-1 results in 0
slti t6, s0, -2048 # verify min immediate value results in 0

end:

wfi