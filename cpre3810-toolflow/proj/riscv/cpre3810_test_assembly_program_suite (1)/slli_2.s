.data
.text
.globl main

# overflow and sign-bit behavior
main:

addi x1, x0, -1 # x1 = 0xFFFFFFFF
addi x2, x0, 127 # x2 = 0x0000007F
addi x3, x0, 1024 # x3 = 0x00000400

# operand < 0, low bit cleared
slli x4, x1, 1 # expect 0xFFFFFFFE
                     
# confirm zero-fill of lower 16 bits
slli x5, x1, 16 # expect 0xFFFF0000

# keep only lowest bit
slli x6, x1, 31 # expect 0x80000000

# discard upper bits
slli x7, x2, 25 # expect 0xFE000000

# all set bits shift out
slli x8, x3, 22 # expect 0x00000000

lui x9, 0x80000 # x9 = 0x80000000

# sign bit fully shifted out
slli x10, x9, 1 # expect 0x00000000

# shift by zero preserve sign bit
slli x11, x9, 0 # expect 0x80000000

                     

wfi