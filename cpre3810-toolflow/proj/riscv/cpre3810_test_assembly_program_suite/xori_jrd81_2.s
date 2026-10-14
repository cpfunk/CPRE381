.data

.text
.globl main

main:
	
    # Start Test
    
    addi t0, x0, 0 	#t0 = 0x00000000
    addi t1, x0, -1	#t1 = 0xFFFFFFFF
    
    #xori testing immediate maximum boundry, value: boundry test imm[11]=0
    xori t2, t0, 2047	#t2 = 0x000007FF
    xori t3, t1, 2047	#t3 = 0xFFFFF800
    
    #xori testing immediate minimum boundry, value: boundry test imm[11]=1 & sign extension
    xori t4, t0, -2048	#t4 = 0xFFFFF800
    xori t5, t1, -2048	#t5 = 0x000007FF
    
    #xori as not on 1's, value: 32-bit inversion, check if xor ignored overflow c_out bit
    xori t6, t1, -1 #t6 = 0x00000000
    
    #final register values
    # t2 = 0x000007FF
    # t3 = 0xFFFFF800
    # t4 = 0xFFFFF800
    # t5 = 0x000007FF
    # t6 = 0x00000000
    
end:

wfi