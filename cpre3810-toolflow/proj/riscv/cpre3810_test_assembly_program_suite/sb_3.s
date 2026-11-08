#we are testing negative offsets, this tests if the processor treats the offset as an unsigned or signed number when offsetting the memory 
lui t0, 0x11223
addi t0, t0, 0x344

#t0: 0x11223344

#memory starts off at 0x10010000 (4th byte)
lui t1, 0x10010

#set address to the 4th byte -> 0x10010004
addi t2, t1, 4

#stores 11223344 into memory at address t1 
sw t0, 0(t1)


#testing negative offset, 
lui t3, 0xBBBBB
addi t3, t3, 0x5AF

sb t3, -1(t2) #this should change memory to look like AF223344 

lw t4, 0(t1) #expected value is AF223344 for t4, this demonstrates that the negative offset is treated as a signed immediate
 

 

   


wfi