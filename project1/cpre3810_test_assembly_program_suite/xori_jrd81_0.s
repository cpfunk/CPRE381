.data

.text
.globl main

main:
	
    # Start Test
    
    
    addi t0, x0, 0 	#t0 = 0x00000000
    addi t1, x0, -1	#t1 = 0xFFFFFFFF
    addi t2, x0, 1	#t2 = 0x00000001
    
    # xori with all 0's, value: catch bad ALU control and imm select error on trivial case 
    xori t3, t0, 0 #t3 = t0
    # xori with all 1's,  value: imm=0 causes similar behavior as addi rd, rs1, 0 with non-trivial rs1
    xori t4, t1, 0	#t4 = t1
    #xori with max imm value: verify sign extension & 12-bit imm positive bounds
    xori t5, t0, 2047	#t5 = 0x000007FF
    #xori as not, value: stress testing inversion of all 32-bits
    xori t6, t2, -1	#t6 = 0xFFFFFFFE
    #xori attempted write to x0, value: catch we to x0
    xori x0, t1, 2047	#x0 = 0, 0x000007FF attempts to propogate
    
    #final register values
    # t3 = 0x00000000
    # t4 = 0xFFFFFFFF
    # t5 = 0x000007FF
    # t6 = 0xFFFFFFFE
    # x0 = 0x00000000
    
end:

wfi