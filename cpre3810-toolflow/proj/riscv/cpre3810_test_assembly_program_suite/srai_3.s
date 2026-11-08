.data
.text
.global main
main: 
	lui x28, 0x80000
	addi x28, x28, -1 #setup maximum positive number
	
	srai x29, x28, 1 #ensure 0 is added to most significant bit
	srai x30, x28, 30 #verify that 0s are added and we are left with 1
	srai x31, x28, 31 #verify that shifting a positive number by 31 gives 0
	
	lui x20, 0x80000 #setup negative value
	
	srai x20, x20, 4 #verify that shifting to the same register works correctly
	srai x20, x20, 4 #verify that it can read the value from previous shift and shift in place again
	srai x20, x20, 8 #continue shifting in place
	srai x20, x20, 16 #shift all the way out leaving only sign extended ones
	
	addi x21, x0, 15 #setup odd number
	
	srai x22, x21, 1 #verify truncation with odd numbers
	
	addi, x23, x0, -15 #setup negative odd number
	
	srai x24, x23, 1 #verify truncation with negative odd numbers
	
end: 

wfi