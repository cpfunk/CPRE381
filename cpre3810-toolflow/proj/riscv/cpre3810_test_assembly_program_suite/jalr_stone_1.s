.data

.text
.globl main

main:

    # Start Test
    auipc x1, 0 # store the current PC into register x1
    addi x1, x1, 28 # store the address of first_jump into register x1
    jalr x2, 0(x1) # common case: jump to first_jump and store return address in register x2.
    
    # several nop's to ensure that instructions are being jumped properly
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    
    # after returning from first jump
    jalr x3, 44(x2) # common case: ensure that ALU is properly adding larger offset and the value of x1

  first_jump:
    jalr x0, 0(x2) # return to the initial location stored in register x2 to ensure address was 
    		   #stored, throw out return address- x0 should not be modified
  
  # several nop's to ensure that instructions are being jumped properly
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
  
  second_jump:
    addi x5, x0, 0 # place the value of x0 into x5, should still be x0

wfi