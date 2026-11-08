.data

.text
.globl main

main:
	# base case
	addi x5, x0, -1  #fill with xFFFFFFFF
	
	andi x6, x5, 0   #AND with x000
	# expected output: x00000000
	
	andi x7, x5, 273  #AND with x111
	# expected output: x00000111
	
	andi x28, x5, 381  #AND with x17D
	# expected output: x0000017D
	
	end:

wfi