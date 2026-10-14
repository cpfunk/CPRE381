.data

.text
.globl main

main:

# Test 3: compare with the zero register
slti t0, x0, 0x7FF # verify max immediate value results in 1
slti t1, x0, 250 # verify arbitrary positive imm value results in 1
slti t2, x0, 1 # verify imm = 1 results in 1
slti t3, x0, 0 # verify imm = 0 results in 0
slti t4, x0, -1 # verify imm = 0 results in 0
slti t5, x0, -250 # verify arbitrary negative imm value results in 0
slti t6, x0, -2048 # verify min immediate value results in 0

end:

wfi