# Test for sh
# Test storing a 32 bit value using sh
# Valuable because sh should only store the lower 16 bits and ignore the upper 16

.data

.text
.globl main

main:
lui t0, 0x10010      # load addr. base addr for .data
lui t1, 0x12345      # load upper 20 bits bits
addi t1, t1, 0x678   # add lower 12 bits to make t1 = 0x12345678
sh t1, 0(t0)         # store lower 16 into memory 
lhu t2, 0(t0)        # read value. t2 should = 0x00005678

end:

wfi