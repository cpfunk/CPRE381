# bgeu_itheng_3.s
# Unit test 3 for bgeu: Zero operand edge cases
# Tests behavior when one or both operands are zero (x0).
# Zero is the smallest unsigned value, so anything >= 0 is always true,
# and 0 >= anything nonzero is always false

    addi x1, x0, 0       # x1 = 0 (failure flag)

    # Test 1: 0 >= 0, branch should be taken
    # equal zeros must branch
    bgeu x0, x0, test1_pass
    addi x1, x0, 1       # fail
test1_pass:

    # Test 2: nonzero >= 0, branch SHOULD be taken
    # zero is minimum unsigned value, any value is >= 0
    addi x2, x0, 7
    bgeu x2, x0, test2_pass
    addi x1, x0, 1       # fail: any value should be >= 0 unsigned
test2_pass:

    # Test 3: 0 >= nonzero, branch should NOT be taken
    # zero is less than any positive unsigned value
    addi x3, x0, 1
    bgeu x0, x3, test3_fail
    bgeu x0, x0, test3_done
test3_fail:
    addi x1, x0, 1       # fail: 0 was treated as >= 1
test3_done:

    # Test 4: large unsigned value >= 0, branch SHOULD be taken
    # maximum unsigned value is still >= 0
    addi x5, x0, -1      # x5 = 0xFFFFFFFF
    bgeu x5, x0, test4_pass
    addi x1, x0, 1       # fail
test4_pass:

    # x1 == 0 means all tests passed

wfi