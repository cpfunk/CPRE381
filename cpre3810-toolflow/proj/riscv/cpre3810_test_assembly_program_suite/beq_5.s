.data
.text
.globl main
main:
# Start Test
addi x1, x0, -1   # Set x1 to -1
addi x2, x0, -1   # Set x2 to -1
addi x3, x0, 0    # Clear failure register
addi x4, x0, 0    # Clear failure register

# Test equal negative values.
# Branch should be taken because -1 equals -1.
beq x1, x2, negative_equal
addi x3, x0, 1    # Failure: branch was not taken

negative_equal:
# Test comparing the zero register to itself.
# Branch should always be taken because x0 = 0.
beq x0, x0, zero_equal
addi x4, x0, 1    # Failure: branch was not taken

zero_equal:
addi x5, x0, 1    # Mark successful completion
wfi