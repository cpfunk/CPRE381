.text
.globl main
main:
    addi x1, x0, 5
    addi x2, x0, 5
    #Test when values are equal to each other
    # Both registers contain 5.
    # Branch should be taken.
    beq x1, x2, equal

    addi x3, x0, 1    # Failure indicator

equal:
    addi x4, x0, 1    # Success indicator
wfi