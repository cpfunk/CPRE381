# bgeu_itheng_2.s
# Unit test 2 for bgeu: Unsigned interpretation edge cases
# 0xFFFFFFFF is -1 signed, but is 4294967295 unsigned.
# bgeu must treat operands as unsigned, so 0xFFFFFFFF >= 1 must be true,
# and 1 >= 0xFFFFFFFF must be false.

    addi x1, x0, 0       # x1 = 0 (failure flag)

    # Load 0xFFFFFFFF into x2 using addi -1
    addi x2, x0, -1      # x2 = 0xFFFFFFFF (largest unsigned 32-bit value)
    addi x3, x0, 1       # x3 = 1

    # Test 1: 0xFFFFFFFF >= 1 (unsigned), branch should be taken
    # tests wrong sign comparison
    #   (signed: -1 >= 1 is FALSE, unsigned: 0xFFFFFFFF >= 1 is TRUE)
    bgeu x2, x3, test1_pass
    addi x1, x0, 1       # fail: treated as signed instead of unsigned
test1_pass:

    # Test 2: 1 >= 0xFFFFFFFF (unsigned), branch should not be taken
    # inverse of first test, checks asymmetry
    bgeu x3, x2, test2_fail
    bgeu x0, x0, test2_done
test2_fail:
    addi x1, x0, 1       # fail: 1 treated as >= 0xFFFFFFFF
test2_done:

    # Test 3: 0xFFFFFFFF >= 0xFFFFFFFF, branch SHOULD be taken (equal)
    # equality at the maximum unsigned value
    addi x5, x0, -1      # x5 = 0xFFFFFFFF
    bgeu x2, x5, test3_pass
    addi x1, x0, 1       # fail: equal max values didn't branch
test3_pass:

    # x1 == 0 means all tests passed

wfi