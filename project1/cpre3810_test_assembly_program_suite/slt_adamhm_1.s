.data

.text
.globl main

main:
    # Test1 : SLT and zero handling
    
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
    
    # SLT where rs1 is less than rs2
    addi x1, x0, 4	# x1 = 4
    addi x2, x0, 7	# x2 = 7
    slt x3, x1, x2	# x3 = 1 as 4<7
    
    # SLT where rs1 is greater than rs2
    slt x4, x2, x1	# x4 = 0 as 7 isn't less than 4
    
    # SLT where rs1 is equal to rs2
    addi x5, x0, 23	# x5 = 23
    addi x6, x0, 23	# x6 = 23
    slt x7, x5, x6	# x7 = 0 as 23 isn't less than 23
    
    # SLT comparing some value with zero
    addi x8, x0, 3	# x8 = 3
    slt x9, x8, x0	# x9 = 0 as 3 isn't less than 0
    
    # SLT comparing zero with some value
    slt x10, x0, x8	# x10 = 1 as 0<3
    
end:

wfi