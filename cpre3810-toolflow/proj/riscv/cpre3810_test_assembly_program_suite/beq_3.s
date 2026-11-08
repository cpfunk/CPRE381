.data

.text
.globl main

main:
    # This test checks whether the BEQ instruction correctly updates the PC when
    # branching forward and backward

    # The first branch tests forward jump
    # The second branch tests a longer forward jump
    # The third branch tests a backward jump 

    # This test is useful since it checks positive and negative branch offsets and verifies 
    # the correct branch targets


    # Start tests 
    
    # Initialize test result registers
    addi x20, x0, 0 # x20 is for failed tests
    addi x21, x0, 0 # x21 is for successful tests 
    addi x22, x0, 0 # x22 is for long_forward failure test 
    addi x23, x0, 0

    # Test 1 short forward jump
    # branch should skip failure instruction
    beq x0, x0, short_forward
    addi x20, x0, 1

short_forward:
    addi x21, x21, 1

    # Test 2 longer forward jump
    # Branch should skip the failure instructions
    beq x0, x0, long_forward
    addi x22, x22, 1
    addi x22, x22, 1
    addi x22, x22, 1
    addi x22, x22, 1

long_forward:
    # Verify instructions that were skipped were actually skipped 
    beq x22, x0, successful_long_forward
    addi x20, x0, 1
    beq x0, x0, end 

successful_long_forward:
    addi x21, x21, 1

    # Test 3 backward jump 
    beq x0, x0, backward_jump_setup

backward_jump_target:
    # increment x21 for success and jump to finished branch
    addi x21, x21, 1
    beq x0, x0, backward_jump_finished

backward_jump_setup:
    # set new marker, and branch backward 
    addi x23, x0, 1
    beq x23, x23, backward_jump_target

    # Failure instructions 
    addi x20, x0, 1
    beq x0, x0, end 

backward_jump_finished:
    # verify that backward jump was successful
    addi x24, x0, 1
    beq x23, x24, check
    
    # Failure instructions 
    addi x20, x0, 1
    beq x0, x0, end
    
check:
    # verify all 3 branch tests
    addi x24, x0, 3
    beq x21, x24, end 

    # failure instruction
    addi x20, x0, 1

end:
    # End of tests
wfi