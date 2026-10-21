.data
.text
.global main
main:
	addi x1, x0, -1 #setup all ones value
	
	srai x2, x1, 0 #verify that shifting by 0 preserves all bits
	srai x3, x1, 1 #verify that shifting right puts a 1 in the sign bit
	srai x4, x1, 16 #verify that the upper 16 bits are sign extended
	srai x5, x1, 31 #verify that it keeps -1 when shifting by 31 due to sign extension
	
	lui x6, 0x80000 #load most negative integer
	
	srai x7, x6, 1 #verify that it keeps 1 at the sign bit
	srai x8, x6, 2 #verify shifting by 2 keeps the sign bit
	srai x9, x6, 4 #verify shifting by 4 keeps the sign bit
	srai x10, x6, 16 #verify shifting by 16 keeps the sign bit
	srai x11, x6, 31 #verify sign extension when shifting by 31
	
	addi x12, x0, -16 #setup small negative value
	
	srai x13, x12, 2 #veriy negative number division
	srai x14, x12, 4 #should leave only the ones from sign extension
	
end:

wfi