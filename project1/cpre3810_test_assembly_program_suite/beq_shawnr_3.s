# Test 3: Backward branch and sign-extension.
# Justification: Tests the PC-relative calculation for negative offsets. 
# Many hardware bugs occur when the 12th bit isn't sign-extended correctly.

    addi x1, x0, 1      # x1 = 1
    addi x2, x0, 1      # x2 = 1
    beq  x1, x2, jump_fwd
    
back_target:
    addi x4, x0, 1      # Success: We successfully jumped backward.
    beq  x0, x0, end    # Exit

jump_fwd:
    beq  x1, x2, back_target # Branch backward to test negative immediate
    addi x4, x0, 2      # Failure path

end:
    addi x5, x0, 1
    


wfi