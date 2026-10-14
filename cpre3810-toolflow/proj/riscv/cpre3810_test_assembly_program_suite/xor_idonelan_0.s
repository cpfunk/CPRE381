.data

.text
.globl main

main:

# Make sure xoring with all 1s flips every bit.
# This tests the common case of using the xor operator as a bit toggle.
# This is important in programs and makes sure xor is working properly.

addi t0, zero, -1 # load all 1s into t0
lui t1, 0x55555 # load 0x55555555 into t1
addi t1, t1, 0x555
xor t1, t1, t0 # t1 = 0x55555555 xor 0xFFFFFFFF

# t1 should equal 0xAAAAAAAA

end:

wfi