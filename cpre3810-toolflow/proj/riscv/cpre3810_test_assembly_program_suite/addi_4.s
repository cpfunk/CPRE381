# addi_adrowski_1.s
# Test 1: Immediate field decoding and sign extension
#
# addi takes a 12-bit signed immediate (range -2048 to 2047) that the
# hardware must sign-extend to 32 bits before it reaches the ALU. These
# cases target the immediate path: the boundary values, the sign bit
# (bit 11), and bit patterns that expose swapped or stuck immediate bits.
# Only addi is used, since it is the first instruction on the list.

.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, 0         # x1 = 0x00000000. add 0 to zero = 0 - clears reg
    addi x2, x0, 1         # x2 = 0x00000001. Smallest positive immediate; checks that
                           # bit 0 of the immediate is routed correctly.
    addi x3, x0, 2047      # x3 = 0x000007FF. Largest positive immediate - check 0 sign extension

    addi x4, x0, -2048     # x4 = 0xFFFFF800. Most negative immediate - check 1 sign extension

    addi x5, x0, -1        # x5 = 0xFFFFFFFF. needs to fill x5 w all ones

    addi x6, x0, 1024      # x6 = 0x00000400. check if bit 10 accidently considered sign bit to extend w 1s
                           # (sign-extend from bit 10 = 0xFFFFFC00).
    addi x10, x0, 2046     # x10 = 0x000007FE. Max positive with bit 0 cleared; with x3,
                           # catches bit 0 stuck at 1.

    # Same boundary immediates with a non-zero rs1, so the sign-extended
    # immediate must be added rather than just passed through to rd.
    addi x11, x5, 2047     # x11 = -1 + 2047 = 2046 = 0x000007FE. check negeavtive plus positive
    addi x12, x3, -2048    # x12 = 2047 + (-2048) = -1 = 0xFFFFFFFF. check positive plus negative
    addi x13, x4, -1       # x13 = -2048 + (-1) = -2049 = 0xFFFFF7FF. 

  end:

wfi