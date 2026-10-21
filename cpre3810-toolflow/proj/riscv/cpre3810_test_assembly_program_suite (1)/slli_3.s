.data
.text
.globl main

# reg and dependency edge cases
main:

addi x1, x0, 3 # init x1 = 3

# Source and destination identical
slli x1, x1, 4 # expect 48

# get result from previous instruction
slli x2, x1, 2 # expect192
                     
# check consecutive dependencies
slli x3, x2, 3 # expect 1536
                     
# zero shift by max amount
slli x4, x0, 31 # expect 0

# write to x0, ignored
slli x0, x1, 5 # expect x0 stays 0

# confirm x0 was has not changed
slli x5, x0, 1 # expect 0


addi x6, x0, -1 # init all bits to 1

# in-place shift negative operand
slli x6, x6, 1 # expect 0xFFFFFFFE

# discard all remaining set bits
slli x6, x6, 31 # expect 0x00000000

# verify zero result preserved
slli x7, x6, 0 # expect 0
                     

wfi