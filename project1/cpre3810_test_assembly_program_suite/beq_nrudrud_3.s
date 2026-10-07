.data

.text
.globl main

main:

# Start Test
# Tests beq backwards branching to verify correct negative branch offsets and repeated branch execution.

# Initialize loop counter
addi x1, x0, 3        # x1 = 3 (loop counter)
addi x2, x0, 0        # x2 = 0 (termination value)


loop_start:

## Test A ## Branch should NOT be taken while x1 != 0
# 3 != 0, 2 != 0, 1 != 0
beq x1, x2, loop_exit

addi x1, x1, -1       # decrement counter

## Test B ## Backwards branch
# Always taken to repeat loop
beq x0, x0, loop_start


loop_exit:

## Test C ## Program should reach here after 3 iterations
addi x8, x0, 170      # indicates backwards branching completed correctly


# Proper beq implementation should result in x8 with value 170 (0xAA)

end:

wfi