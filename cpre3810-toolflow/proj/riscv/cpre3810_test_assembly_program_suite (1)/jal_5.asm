.data

.text
.globl main

main:
    # Testing edge case where destination register is x0.
    # Does jump still execute correctly? Is (x0) still 0 (and return address discarded)?
    
    addi x2, x0, 0          # Clear any data in x2
    jal x0, jump_no_link    # Jump without linking (i.e., what jump sudoinstruction does)
    addi x2, x0, 1          # x2 becomes 1 if jal fails

jump_no_link:
    add x3, x0, x0          # Add x0 to x0, ensure not overwritten with PC+4

wfi