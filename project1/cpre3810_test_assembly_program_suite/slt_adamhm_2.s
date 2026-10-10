.data

.text
.globl main

main:
    # Test2 : Signed comparison with negative values
    
    # Clearing the registers
    addi x1, x0, 0
    addi x2, x0, 0
    addi x3, x0, 0
    addi x4, x0, 0
    addi x5, x0, 0
    addi x6, x0, 0
    addi x7, x0, 0
    addi x8, x0, 0
    addi x9, x0, 0
    addi x10, x0, 0
    addi x11, x0, 0
    
    # SLT comparing negative with positive
    addi x1, x0, -6	# x1 = -6
    addi x2, x0, 8	# x2 = 8
    slt x3, x1, x2	# x3 = 1 as -6<8
    
    # SLT comparing positive with negative
    slt x4, x2, x1	# x4 = 0 as 8 isn't less than -6
    
    # SLT where comparing two negative values and rs1 is more negative
    addi x5, x0, -15	# x5 = -15
    addi x6, x0, -9	# x6 = -9
    slt x7, x5, x6	# x7 = 1 as -15<-9
    
    # SLT where comparing two negative values and rs1 is less negative
    slt x8, x6, x5	# x8 = 0 as -9 isn't less than -15
    
    # SLT where both negative values are equal
    addi x9, x0, -7	# x9 = -7
    addi x10, x0, -7	# x10 = -7
    slt x11, x9, x10	# x11 = 0 as -7 isn't less than -7
    
end:

wfi