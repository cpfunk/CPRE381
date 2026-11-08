# Behavioral-Case
    # Checking the Offset
    # When using the jalr it is important that the instruction puts a multiple of 4 bits in the PC register
    # to access a valid space in the memory instruction for the entire 32-bit word


.data
.text 
.globl main
main:

bne x0, x1, Exit

lui x1, 0x00400
addi x1, x1, -4

jalr x0, 4(x1)

Exit:
wfi