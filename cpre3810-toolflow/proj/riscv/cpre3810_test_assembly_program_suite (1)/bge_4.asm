.data
.text
.globl main

# Test 2: First number is less than the second number
main:
addi x1, x0, 3       	# Set x1 to 3 for rs1
addi x2, x0, 5		# Set x2 to 5 for rs2
addi x3, x0, 0       	# Clear x3 to use if the branch doesn't work

bge x1, x2, branch 	# 3 >= 5 is false, so it doesn't branch
addi x3, x0, 1       	# Should execute because the program shouldn't branch

branch:
addi x4, x0, 1       	# Add 1 to x4 if the program branched

end:


wfi