.data

.text
.globl main

main:

# This tests that xoring something with itself equals zero.
# This is important because it can be used in hardware to check the equality of two registers.

lui t0, 0x55555 # load t0 = 0x55555555
addi t0, t0, 0x555
xor t0, t0, t0 # t0 = t0 xor t0

# Expect t0 = 0x00000000

end:

wfi