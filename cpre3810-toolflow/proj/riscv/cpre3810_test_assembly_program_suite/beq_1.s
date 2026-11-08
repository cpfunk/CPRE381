.data

.text
.globl main

main:
# This test checks whether the BEQ instruction correctly handles comparisons
# between registers with different values and the zero register x0 

# The first comparisons should not branch since they would not equal zero from the initialization
# The final comparison between x0 and x0 should branch as these are equal

# This test is useful as it verifies that the branches are taken or not taken accordingly
# which helps identify errors in register comparison and PC updates

    # Start Test 

    # Initialize registers
    addi x10, x0, 1
    addi x11, x0, 2047
    addi x12, x0, -3
    addi x13, x0, -4
    addi x14, x0, -2048

    # initialize test result registers
    addi x20, x0, 0 # x20 corresponds to failed tests
    addi x21, x0, 0 # x21 corresponds to passed tests

    # failed branches
    beq x10, x0, fail
    beq x11, x0, fail
    beq x12, x0, fail
    beq x13, x0, fail
    beq x14, x0, fail

    # passed branch 
    beq x0, x0, equal # This should be the only one that branches to branch "equal"

    # if BEQ was not taken, test is failed
    addi x20, x0, 1
    beq x0, x0, end

equal:
    addi x21, x0, 1
    beq x0, x0, end 

fail:
    addi x20, x0, 1

end:
    # End of tests
wfi