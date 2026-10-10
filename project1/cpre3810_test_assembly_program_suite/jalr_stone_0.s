.data

.text
.globl main

main:

    # Start Test
    auipc x1, 0 # store the current PC into register x1
    addi x1, x1, 16 # store the address of first_jump into register x1
    jalr x2, 0(x1) # common case: jump to first_jump and store return address in register x2.
    
    # after returning from first jump
    jalr x3, 4(x1) # common case: ensure that ALU is properly adding offset and the value of x1

  first_jump:
    jalr x0, 0(x2) # return to the initial location stored in register x2 to ensure address was 
    		   #stored, throw out return address- x0 should not be modified
  
  second_jump:
    addi x0, x0, 0 # nop psuedo instruction

wfi