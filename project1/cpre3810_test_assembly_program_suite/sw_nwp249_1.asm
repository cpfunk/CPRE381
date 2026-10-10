.data

.text
.globl main

main:
	# Test 1: Common case store - storing a word, storing at an offset
	lui x5, 0x10010 # load base data memory address into x5
	addi x6, x0, 1 	# load a value to store
	sw x6, 0(x5)	# store a word
	sw x6, 4(x5)	# store a word at an offset
	# expect value 1 at 0x10010000 and 0x10010000

exit:
	
wfi