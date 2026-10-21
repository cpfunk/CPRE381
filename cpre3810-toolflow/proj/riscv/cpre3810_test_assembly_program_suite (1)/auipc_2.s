#Start Test Case
auipc x5, 0 #Set register 5 to program counter for comparision
addi x28, x0, 0 #Set register to 0 for incrementation logic in a loop to test program counter being added to registers
beq x0, x0, skip #Forced branch to change program counter
addi x0, x0, 0 #Filler for pc
addi x0, x0, 0 #Filler for pc
skip:
    auipc x6, 0 #Set register 6 to program counter to compare with register 5. Second time should be the same value
    bne x0, x28, continue #Branch away after looped once
    addi x28, x28, 1 #Set register 28 to 1 so loop is broken after branched once
    beq x0, x0, skip #Branch back to test if register 6 will keep the same value with the same instruction
continue:
    auipc x7, 0 #Set register 7 to compare to the other two.
    
#The purpose of this is to test if auipc works when there is a lot of branching going on
#Any repeated instructions will happen at the same point in the code as the previous time. Therefore the value should not change when instruction is repeated
wfi