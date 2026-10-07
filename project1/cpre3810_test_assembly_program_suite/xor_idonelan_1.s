.data

.text
.globl main

main:

# This tests the common case of xoring with a 0 not changing the value.
# This is a essential to how xor works, so it is a common case.

lui t0, 0x55555 # load t0 = 0x55555555
addi t0, t0, 0x555
xor t0, zero, t0 # t0 = 0x55555555 xor zero

# expect t0 = 0x55555555

end:

wfi