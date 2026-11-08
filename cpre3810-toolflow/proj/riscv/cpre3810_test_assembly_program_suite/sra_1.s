.text
.globl main

main:
    # Test 1: Positive and negative values and zero

    # Test a positive number shifted right by 3
    addi x1, x0, 36       # Pos num: 36
    addi x2, x0, 3        # Shift: 3
    sra  x3, x1, x2       # Expected x3 = 4
         
    # Tests a negative number when it is sign extended  
    addi x4, x0, -36      # Neg num: -36
    sra  x5, x4, x2       # Expected x5 = -5

    # Makes sure that shifting zero keeps the result zero
    addi x6, x0, 0        # Zero
    sra  x7, x6, x2       # Expected x7 = 0

wfi