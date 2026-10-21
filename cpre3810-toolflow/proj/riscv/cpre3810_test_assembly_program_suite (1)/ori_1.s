.data

.text
.globl main

main:
    # Test1 : ORI basic operations and zero handling
    
    # Clearing registers
    addi x1, x0, 0
    addi x2, x0, 0
    addi x3, x0, 0
    addi x4, x0, 0
    addi x5, x0, 0
    
    # ORI with zero immediate
    # Justification: It tests that combining a number with zero keeps the original number unchanged
    addi x1, x0, 42	# x1 = 42
    ori x2, x1, 0	# x2 = 42 | 0 = 42
    
    # ORI with x0 as source register
    # Justification: It tests that immediate loads directly into a register without any prior values
    ori x3, x0, 15	# x3 = 0 | 15 = 15
    
    # ORI with identical values
    # Justification: It tests the behavior when the immediate matches the regsiter's bit pattern
    addi x4, x0, 10	# x4 = 10
    ori x5, x4, 10	# x5 = 10 | 10 = 10
    
end:

wfi