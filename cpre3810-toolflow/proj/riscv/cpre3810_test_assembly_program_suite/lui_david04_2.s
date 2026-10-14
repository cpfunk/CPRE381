# instruction: lui
# loads a 20-bit imm into the upper 20 bits of a register

# Test 2: clearing register
addi t1, x0, 100 # intializes t1 with 100
lui t1, 0 # clears t0 register with 0
# expected: 0x00000000

# reasoning: this test case will check to see if a register is cleared with using a 0 imm value
# in this case we will have register t1 have 100, and to test if the case works we simply load the t1 register by 0, this should completely clear the t1
# this will overwrite the register with all 0's, and also shift to the left with 0's however you wont be able to tell since the whole result is 0
# of course if otherwise, the register is not cleared with all 0's this will tell us the test case failed


wfi