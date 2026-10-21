.data

.text
.globl main

main:

    # Start Test - Bit masking. Remove unwanted bits with '0'. Keep wanted bits with '1'.
    # This test is useful and applicable for removing unwanted bits. For example, bit
    # masking with "and" could be used to convert from byte addressable memory to word 
    # addressable memory. 
    
    # Fill register values 
    addi t1, x0, 0x00f
    addi t2, x0, 0x0ff
    addi t3, x0, 0x7ff
    
    # Fill bit masks
    addi t4, x0, 0x7fc
    addi t5, x0, 0x7f0
    addi t6, x0, 0x00f
    
    # Test
    and t1, t1, t4	# 000_0000_1111 & 111_1111_1100 = 000_0000_1100 = 0x00c
    and t2, t2, t5      # 000_1111_1111 & 111_1111_0000 = 000_1111_0000 = 0x0f0
    and t3, t3, t6      # 111_1111_1111 & 000_0000_1111 = 000_0000_1111 = 0x00f
    

  end:

wfi