.data
.text
.globl main
main:
    # Test 1: basic slli tests for small values

    addi x1, x0, 5 # x1 = 5 (0b101)

    slli x2, x1, 0 # shifting by 0 should leave value unchanged
                   #x2 = x1 = 5 (0b101)

    slli x3, x1, 1 # 5 << 1 = 10 (b1010)
                   # testing the shift by 1( *= 2)
                   

    slli x4, x1, 3 # 5 << 3 = 40 (0b101000)
                   # testing shift for a shift of three bits left. 
                   # expected x4 = 40

    addi x5, x0, 1 # setting x5 = 1

    slli x6, x5, 4 # testing shift of 1 bit value, 
                   #expected x6 = 16 (0b10000)

wfi