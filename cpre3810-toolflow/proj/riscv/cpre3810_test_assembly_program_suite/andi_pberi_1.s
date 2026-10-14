.text
.globl main

main:

    # Test 1: andi basics with immediate masks (zero, -1, max positive, sign-extended negative)
    # Detects incorrect immediate sign-extension handling and simple masking bugs.
    lui x1,0x12345         # x1 = 0x12345000
    addi x1,x1,0x678       # x1 = 0x12345678

    andi x2,x1,0          # x2 = 0
    andi x3,x1,-1         # x3 = x1 (mask -1)
    andi x4,x1,0x7ff      # x4 = x1 & 0x7ff (lower 11 bits)
    andi x5,x1,-2048      # x5 = x1 & (-2048) ; clears lower 11 bits

    addi x0,x0,0          # no-op end

wfi