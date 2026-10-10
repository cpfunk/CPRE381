.data

.text
.globl main

main:

# Test 2: compare with the maximum value for a 12-bit signed immediate
addi s0, x0, 0x7FF # put max imm val in s0 for comparisons
# all results should be 0
slti t0, s0, 0x7FF # verify imm = val results in 0
slti t1, s0, 0x7FE # verify imm = val-1 results in 0
slti t2, s0, 0 # verify imm = 0 results in 0
slti t3, s0, -16 # verify arbitrary negative imm value results in 0
slti t4, s0, -2048 # verify min immediate value results in 0
addi s1, s0, 1 # make comparison value larger than max imm value
slti t5, s1, 0x7FF # verify compare with value larger than max imm val results in 0

end:

wfi