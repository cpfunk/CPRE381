.data
.text
.global main

main:
	srai x1, x0, 0 #verify that shifting 0 by 0 results in 0
	srai x2, x0, 16 #verify that shifting 0 by an amount results in 0
	srai x3, x0, 31 #verify that shifting by the max amount results in 0
	
	addi x4, x0, 1024 #setup value to use in next tests (single bit: 2^10, 0x00000400)
	
	srai x5, x4, 0 #verify that the shifter does not shift when the immediate is 0
	srai x6, x4, 1 #test dividing by 2
	srai x7, x4, 10 #test shifting exactly to bit 0
	srai x8, x4, 11 #test shifting completely out of the register (result should be 0)
	
	addi x9, x0, 2047 #setup value with multiple bits for next tests (0x000007FF)
	
	srai x10, x9, 4 #test shifting multi bit value by one byte (result should be 0x0000007F)
	srai x11, x9, 31 #test shifting multi bit value all the way out of the register
	srai x0, x9, 4 #test that register 0 cannot change its value from 0
	
end:

wfi