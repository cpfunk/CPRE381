# For branching (not jalr and jal)
#   1 2 3 4
# | F D E M --> branch address loaded into PC when branch instruction in memory stage,
#               this means that the two pipeline stages before need to be filled with s.
#
# For read after write (note: this includes jalr and jal)
#   1 2 3 4 5
# | F D E M W
# |   F D E M W
# |     F D E M W
# |  	  F D E M W
# |         F D E M W --> since regfile not negative edge triggered: Decode only after writeback --> 3 s inbetween

main:
	ori s0, x0, 0x123
	j skip
	
	
	li s0, 0xffffffff
skip:
	ori s1, x0, 0x123
    
	
	
	beq s0, s1, skip2
	
	
	li s0, 0xffffffff
skip2:
	jal fun
	
	
	ori s3, x0, 0x123
	beq s0, x0, exit
	
	
	ori s4, x0, 0x123
	j exit
	
    
fun:
	ori s2, x0, 0x123
	jr ra
    
	
exit:
	wfi