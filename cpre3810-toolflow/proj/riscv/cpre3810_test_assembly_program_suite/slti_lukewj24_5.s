.data

.text
.globl main

main:

# Test 5: compare with the minimum value for a 12-bit signed immediate
addi s0, x0, -2048 # put min imm val in s0 for comparisons
slti t0, s0, 0x7FF # verify max immediate value results in 1
slti t1, s0, 128 # verify arbitrary positive imm value results in 1
slti t2, s0, 0 # verify imm = 0 results in 1
slti t3, s0, -128 # verify arbitrary negative imm value results in 1
slti t4, s0, -2048 # verify min immediate value results in 0
addi s1, s0, -1 # put min imm val - 1 in s1 for next comparison
slti t5, s1, -2048 # verify min immediate value now results in 1

end:

wfi