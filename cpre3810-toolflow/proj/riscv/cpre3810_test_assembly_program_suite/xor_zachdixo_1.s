# Simple check, output should be 0xFFFFFFFE
# This tests checks that every single bit of the register can be xor'd
addi a1, x0, 1
addi a2, x0, -1

xor t0, a2, a1
wfi