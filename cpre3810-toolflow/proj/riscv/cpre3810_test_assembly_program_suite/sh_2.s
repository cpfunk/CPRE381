# Test for sh
# Test storing the maximum and minimum unsigned halfword values of 0x0000 and 0xFFFF
# Valuable to ensure that sh can store the maximum or minimum unsigned values
# sh stores bits. doesnt care about signed or unsigned

.data

.text
.global main

main:
lui t0, 0x10010   # load addr. Base addr for .data
addi t1, x0, 0    # set reg to minimum
addi t2, x0, -1   # set reg to maximum
sh t1, 0(t0)      # store 0 in lower half
sh t2, 2(t0)      # store 0xFFFF in upper half
lhu t3, 0(t0)     # read lower half t3 should = 0
lhu t4, 2(t0)     # read upper half t4 should = 65535 of 0xFFFF
lw t5, 0(t0)      # whole segment is 0xFFFF0000

end:

wfi