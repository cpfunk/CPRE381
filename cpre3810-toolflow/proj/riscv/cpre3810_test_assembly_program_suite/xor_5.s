.text
.globl main
main:
    # Test 2a: XOR with zero returns the original number.
    # 15 XOR 0 = 15
    addi t0, zero, 15
    xor  t1, t0, zero
    
    # Test 2b: XOR of the same register 
    xor  t2, t0, t0
 # this should a return 0 
wfi