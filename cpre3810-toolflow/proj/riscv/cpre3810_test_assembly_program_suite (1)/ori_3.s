.data

.text
.globl main

main:
    # Test3 : ORI edge cases/limits
    
    # Clearing registers
    addi x1, x0, 0
    addi x2, x0, 0
    addi x3, x0, 0
    addi x4, x0, 0
    addi x5, x0, 0
    
    # ORI large positive numbers
    # Justification: It tests the upper bound of the positive immediate value
    addi x1, x0, 10	# x1 = 10
    ori x2, x1, 2047	# x2 = 10 | 2047 = 2047 --because 10 is within the bits of 2047

    # ORI with the most negative 12 bit immediate
    # Justification: It tests the lower bound of the negative immediate value
    addi x3, x0, 1024	# x3 = 1024
    ori x4, x3, -2048	# x4 = 1024 | 0xFFFFF800 = 0xFFFFFC00 --where 0xFFFFF800 is -2048 and 0xFFFFFC00 is -1024
            
    # ORI where the destination register is the same as the source register
    # Justification: It tests the register forwarding & overwriting
    addi x5, x0, 16	# x5 = 16
    ori x5, x5, 4	# x5 = 16 | 4 = 20 --overwrites x5
    
    # ORI with x0 register
    # Justification: It tests that the x0 register always stays at 0, even if we try to save a new number into it
    ori x0, x5, 255	# x0 should stay as 0
    
end:

wfi