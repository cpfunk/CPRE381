# Test purpose:
#   Verify that BGEU uses an UNSIGNED comparison.
# Why this matters:
#   If the processor incorrectly uses signed comparison logic it will think
#   0xFFFFFFFF is -1 and fail the branch against 1. Unsigned however 0xFFFFFFFF > 1, so the branch should pass.
# Expected result:
#   x31 = 0

    addi x31, x0, 0      # failure check

    addi x5,  x0, -1     # x5 = 0xFFFFFFFF
    addi x6,  x0, 1      # x6 = 1

    bgeu x5, x6, pass    # should pass: 0xFFFFFFFF >= 1 (unsigned)

fail:
    addi x31, x31, 1     # if set to 1 the comparison has failed.
    jal  x0, done

pass:
    addi x0,  x0, 0

done:
    addi x0,  x0, 0
wfi