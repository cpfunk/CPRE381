#test 1: SB takes the lower 8 bits of a word, this tests to make sure the other bits of the input are untouched and not put into memory.
lui t1, 0xFFFFF
addi t1, t1, 0x7AB

#t1: FFFFF7AB

#default address location: 0x10010000 at t0
lui t0, 0x10010

#initialize the memory to zero
lui t2, 0x00000
sw t2, 0(t0)


#this instruction should store AB into the memory address at 10010000, the value loaded in should be the bottom 8 bits of t1 which is AB
sb t1, 0(t0) 


#loads the value from memory address at t0 into t3. t3 should be 0x000000AB
lw t3, 0(t0)







wfi