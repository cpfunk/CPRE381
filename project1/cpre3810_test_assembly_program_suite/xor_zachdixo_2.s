#Test 2
# Check that XOR -1 & -1 yeilds 0
# this tests verifies an output of 0, because A XOR A = 0 in all cases

addi a1, x0, 1
addi a2, x0, -1

xor t1, a2, a2
wfi