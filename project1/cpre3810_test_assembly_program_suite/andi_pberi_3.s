.text
.globl main

main:

    # Test 3: chain andi with sign-extended immediates and register masks
    # Targets bugs where sign-extension of negative immediates or lower-bit extraction is mishandled, and verifies chained logical operations behave as expected.
    lui x1,0xF0F0F        # x1 = 0xF0F0F000
    addi x1,x1,0x0F0      # x1 = 0xF0F0F0F0

    andi x2,x1,-2048      # x2 = x1 & (-2048) ; clears lower 11 bits
    andi x3,x1,0x7FF      # x3 = x1 & 0x7FF     ; lower 11 bits
    and x4,x2,x3          # x4 = combination (likely zero)

    addi x0,x0,0          # no-op end

wfi