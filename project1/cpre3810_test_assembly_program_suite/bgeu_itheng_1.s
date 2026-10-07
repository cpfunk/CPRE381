# bgeu_itheng_1.s
# Unit test 1 for bgeu: Basic behavior
# Tests: branch taken when equal, branch taken when rs1 > rs2 (unsigned),
#        branch NOT taken when rs1 < rs2 (unsigned).
# x1 is failure flag (0 = pass, 1 = fail).

    addi x1, x0, 0       # x1 = 0 (failure flag)

    # Test 1: rs1 == rs2, branch should be taken
    # equality is the boundary condition of >=
    addi x2, x0, 5
    addi x3, x0, 5
    bgeu x2, x3, test1_pass
    addi x1, x0, 1       # fail: branch not taken when rs1 == rs2
test1_pass:

    # Test 2: rs1 > rs2 (unsigned), branch should be taken
    # common case where rs1 is strictly greater than rs2
    addi x2, x0, 10
    addi x3, x0, 3
    bgeu x2, x3, test2_pass
    addi x1, x0, 1       # fail: branch not taken when rs1 > rs2
test2_pass:

    # Test 3: rs1 < rs2 (unsigned), branch should not be taken
    # common case where condition is false, fall-through must occur
    addi x2, x0, 3
    addi x3, x0, 10
    bgeu x2, x3, test3_fail
    bgeu x0, x0, test3_done
test3_fail:
    addi x1, x0, 1       # fail: branch taken when rs1 < rs2
test3_done:

    # x1 == 0 means all tests passed

wfi