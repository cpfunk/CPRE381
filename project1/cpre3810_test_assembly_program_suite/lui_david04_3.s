# instruction: lui
# loads a 20-bit imm into the upper 20 bits of a register

# Test 3: checks the shifting the 12 bits
addi t2, x0, 0 # intializes t2 with 0
lui t2, 4 # shifts 12 bits to the left
# expected: 0x00004000

# reasoning: for this test we are simply checking for the shifting of the bits. In order to understand this more, the way this work, is by shfiting 12 bits to the left, or in another way 
# to see this is through 3 hex digits. In our case for this particular test case we intializing t2 with 0, and then we are simplying trying to shift 12 bits to the left using the imm value
# 4, so the expected should show us 0x00004000 by doing what we have been talking about shifting 3 hex digits to the left and putting in that imm value that we used for lui
# of course if the lui value is not shifted or shown correctly then the test case failed
wfi