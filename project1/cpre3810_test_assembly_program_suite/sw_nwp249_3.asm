.data

.text
.globl main

main:
	# Test 3: Edge case store - data from max register, zero register
	lui x5, 0x10010 # load base data memory address into x31
	addi x31, x0, 1	# common value
	sw x31, 0(x5)	# store the value
	# expect 1 at location 0x10010000
	
	sw x0, 0(x5)	# store the value
	# expect 0 at location 0x10001000
exit:
	
wfi