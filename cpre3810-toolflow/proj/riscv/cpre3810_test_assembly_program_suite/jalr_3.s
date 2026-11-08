# Common-Case use of jalr function
 # Returning from a function

 # Requires the use of the jal instruction to call a function
        # Uses the beq to get out of a reiterative loop

 # Expected:
    # The value of x1 = 0x00400004

.data
.text
.globl main
main:

jal x1, function

beq zero, zero, Exit

function:

jalr x0, 0(x1)

Exit:
wfi