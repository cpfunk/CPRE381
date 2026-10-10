# instruction: lui
# loads a 20-bit imm into the upper 20 bits of a register

# Test 1: overwrites register
addi t0, x0, 67 # initializes t0 with 67
lui t0, 0xBAD # shifts 12 imm bits, and gives 0x00BAD000
# expected: 0x00BAD000

# reasoning: for this test, we can use lui in this case to overwrite a register
# in this case we are simply overwriting the register value 67 with 0xBAD, which also shifts to the left 12 bits (3 hex digits)
# ultimately this test checks that the lui instruction overwrites the previous contents of the t0 register with an alrady defined value
# of course if the lui imm value is not shown with a shift to the left by 3 hex digits or 12 bits we know the test case failed





wfi