# Test purpose:
#   Verify that BGEU takes the branch when two registers are equivalent.
# Why this matters:
#   To check if the instruction behaves like a greater than or equal and not just a greater than.
# Expected result:
#   x31 = 0

    addi x31, x0, 0      # failure check    

    addi x5,  x0, 7      # x5 = 7
    addi x6,  x0, 7      # x6 = 7

    bgeu x5, x6, pass    # should branch because 7 >= 7 (unsigned)

fail:
    addi x31, x31, 1    # if set to 1 the comparison has failed.
    jal  x0, done

pass:
    addi x0,  x0, 0      # harmless real instruction (acts like nop)

done:
    addi x0,  x0, 0
wfi