.data
.text
.globl main

# basic slli functionality
main:

addi x1, x0, 1 # init to 1

# shift by 0, preserve value
slli x2, x1, 0 # expect 1

# confirm single-bit shift
slli x3, x1, 1 # expect 2

# confirm two-bit shift
slli x4, x1, 2 # expect 4

# confirm normal shift amount
slli x5, x1, 4 # expected 16

# confirm bigger shift
slli x6, x1, 8 # expect 256

# confirm upper-half movement
slli x7, x1, 16 # expect 65536

# test near-max shift
slli x8, x1, 30 # expect 0x40000000

# max allowed RV32I shift
slli x9, x1, 31 # expect 0x80000000


wfi