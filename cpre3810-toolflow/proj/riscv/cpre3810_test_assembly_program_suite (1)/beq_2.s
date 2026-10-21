.data

.text
.globl main

main:
    # This test checks whether the BEQ instruction correctly branches when two different 
    # registers have equal nonzero values

    # The test will compare positive, negative, minimum (12bit) and maximum (12 bit)
    # values

    # This test is useful since it verifies that the BEQ compares the entire register 
    # and correctly updates the PC


    # Start Test

    # Initialize positive value registers 
    addi x10, x0, 100
    addi x11, x0, 100

    # Initialize negative value registers
    addi x12, x0, -100
    addi x13, x0, -100

    # Initialize minimum (32 bit) signed registers 
    lui x14, 0x80000
    lui x15, 0x80000

    # Initialize maximum signed (32 bit) registers
    lui x16, 0x80000
    addi x16, x16, -1
    lui x17, 0x80000
    addi x17, x17, -1

    # Initialize test result registers
    addi x20, x0, 0 # x20 register is if test fails 
    addi x21, x0, 0 # x21 register is if test is successful 

    # Check positive values, should be taken 
    beq x10, x11, positive
    addi x20, x0, 1
    beq x0, x0, end 

positive:
    addi x21, x21, 1

    # check negative values, branch should be taken
    beq x12, x13, negative
    addi x20, x0, 1
    beq x0, x0, end 

negative:
    addi x21, x21, 1

    # Check minimum 32 bit value, branch should be taken 
    beq x14, x15, minimum 
    addi x20, x20, 1
    beq x0, x0, end

minimum:
    addi x21, x21, 1

    # Check maximum 32 bit value, branch should be taken 
    beq x16, x17, maximum
    addi x20, x0, 1
    beq x0, x0, end 

maximum:
    addi x21, x21, 1

    # Verify that 4 comparisons succeeded 
    addi x22, x0, 4
    beq x21, x22, end
    addi x20, x0, 1

end:
    # End of tests
wfi