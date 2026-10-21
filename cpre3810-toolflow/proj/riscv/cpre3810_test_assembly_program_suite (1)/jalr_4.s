# Exceptional-Case use of jalr function
 # Using the rd = PC + 4 aspect of the function

 # Requires the use of the jal instruction to call a function
        # Uses the beq to get out of a reiterative loop

 # Expected:
    # The value of a0 = 0x0040000C

.data
.text
.globl main
main:

jal x1, function

beq zero, zero, Exit

function:

jalr a0, 0(x1)

Exit:
wfi