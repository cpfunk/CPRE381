.data

.text
.globl main

main:
    # Test2 : ORI with negative immediate and alternating bit patterns
    
    # Clearing registers
    addi x1, x0, 0
    addi x2, x0, 0
    addi x3, x0, 0
    addi x4, x0, 0
    addi x5, x0, 0
    addi x15, x0, 0
    
    # ORI with a negative immediate
    # Justification: It tests if the process sign extends the 12 bit immediate to 32 bits correctly
    addi x1, x0, 5	# x1 = 5
    ori x2, x1, -1	# x2 = 5 | 0xFFFFFFFF = 0xFFFFFFFF --which is (-1)
    
    # ORI combining distinct alternating bit patterns
    # Justification: It tests to make sure that the individual bits are correctly OR'ed without carrying over
    addi x3, x0, 85	# x3 = 0b01010101 --which is 85 (decimal)
    ori x4, x3, 170	# x4 = 85 | 0b10101010 = 0b11111111 --where 0b10101010 is 170 and 0b11111111 is 255
    
    # ORI writing to a higher register number
    # Justification: It tests to to check that we can use different destination registers to store the final output 
    addi x5, x0, 16	# x5 = 16
    ori x15, x5, 8	# x15 = 16 | 8 = 24

end:

wfi