.data
.text
.globl main

# Test 3: First number is equal to the second number
main:
addi x1, x0, 3       	# Set x1 to 3 for rs1
addi x2, x0, 3		# Set x2 to 3 for rs2
addi x3, x0, 0       	# Clear x3 to use if the branch doesn't work

bge x1, x2, branch   	# 3 >= 3 is true, so it branches
addi x3, x0, 1      	# Should be skipped if the branch works

branch:
addi x4, x0, 1		# Add 1 to x4 to show that the branch worked

end:


wfi