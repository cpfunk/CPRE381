.data

.text
.globl main

main:

    # Start Test - Clear register values by "anding" with a register written with all 0's.
    
    # Fill register values 
    addi t1, x0, 0x00f
    addi t2, x0, 0x0ff
    addi t3, x0, 0x7ff
    
    # Test
    and t1, t1, x0
    and t2, t2, x0
    and t3, t3, x0
    

  end:

wfi