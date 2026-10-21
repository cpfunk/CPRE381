.text
.globl main
main:
    # Test 1: Normal positive operands 
    # 5 XOR 3 = 6 
    addi t0, zero, 5
    addi t1, zero, 3
    xor  t2, t0, t1

wfi