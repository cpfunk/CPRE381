# Test for sh
# Test storing a positive 16 bit value
# Valuable to ensure that sh stores the value correctly

.data

.text
.globl main

main:
lui t0, 0x10010    # load addr. Base addr for .data 
addi t1, x0, 1234  # aet value to 1234
sh t1, 0(t0)       # store halfword
lhu t2, 0(t0)      # read value. t2 should = 1234 dec or 0x000004D2 hex

end:

wfi