.data

.text
.globl main

main:
    # Test3 : SLT edge cases
    
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
    
    # SLT where comparing the largest positive immediate and the largest negative immediate
    addi x1, x0, 2047	# x1 = 2047 which is the maximum 12 bit signed immediate
    addi x2, x0, -2048	# x2 = -2048 which is the minimum 12 bit signed immediate
    slt x3, x2, x1	# x3 = 1 as -2048<2047
    slt x4, x1, x2	# x4 = 0 as 2047 isn't less than -2048

    # SLT where both register sources are x0
    slt x5, x0, x0	# x5 = 0 as 0 isn't less than 0
            
    # SLT where rd is the same as one of the source registers
    addi x6, x0, 16	# x6 = 16
    addi x7, x0, 21	# x7 = 21
    slt x6, x6, x7	# x6 = 1 as 16<21 (The result overwrote x6)
    
    # SLT comparing -1 to 0 to check the signed comparison
    # We know that in signed -1<0, but in unsigned 0xFFFFFFFF>0
    addi x8, x0, -1	# x8 = -1 (0xFFFFFFFF)
    slt x9, x8, x0	# x9 = 1 as -1<0 (signed comparison)
    
end:

wfi