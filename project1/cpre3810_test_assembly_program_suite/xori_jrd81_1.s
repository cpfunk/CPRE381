.data

.text
.globl main

main:

    #Note: xori never has a zero extended immediate
	
    # Start Test
    
    lui t0, 0x12345	# t0 = 0x12345000
    addi t0, t0, 0x067	# t0 = 0x12345067
    # xori w/ max pos imm and sign extension, value: 
    xori t1, t0, 2047	#t1 = 0x12345798
    # xori w/ minimum neg imm (sign extended) value: this fails if immediate is zero extended by accident
    xori t2, t0, -2048	#t2 = 0xEDCBA867
    
    addi t3, x0, -1	#t3 = 0xFFFFF800
    #xori w/ max and min values and rs1 is all ones. value: verifies correct sign extension, easy to spot errors
    xori t4, t3, 2047	#t4 = 0xFFFFF800
    xori t5, t3, -2048	#t5 = 0x000007FF
    
    # xori not behaviour value: stress test sign extended -1 and bitwise flip
    xori t6, t0, -1	#t6 = 0xEDCBAF98
    
    
    #final register values
    # t0 = 0x12345067
    # t1 = 0x12345798
    # t2 = 0xEDCBA867
    # t3 = 0xFFFFFFFF
    # t4 = 0xFFFFF800
    # t5 = 0x000007FF
    # t6 = 0xEDCBAF98
    
end:

wfi