.data

.text
.globl main

main:
	# Test 2: Edge case store - max positive and negative number
	lui x5, 0x10010 # load base data memory address into x5
	lui x6, 0x80000	# load max value into x6
	addi x6, x6, -1
	sw x6, 0(x5)	# store the value
	# expect 0x7fffffff at location 0x10010000
	
	lui x6, 0x80000	# load max negative value into x6
	sw x6, 4(x5)	# store the value
	# expect 0x80000000 at location 0x10001004
exit:
	
wfi