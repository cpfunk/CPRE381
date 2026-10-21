.data

.text
.globl main

main:
    # Testing a common case of a forward jump and link. 
    # Does PC update to the target address correctly?
    # Is the return address (PC + 4)  properly saved into the destination register (x1)?
    
    addi x2, x0, 0      # Clear any data in x2
    jal x1, target  	# Jump forward to forward_target, save PC+4 to x1
    addi x2, x0, 1      # x2 becomes 1 if jal fails

target:

wfi