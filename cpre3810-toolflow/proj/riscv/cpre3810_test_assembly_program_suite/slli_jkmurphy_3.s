.data
.text
.globl main
main:
    # Test 3: verify source register is preserved for shifts, and large shifts work. 

    addi x1, x0, 3 # x1 = 3 = 0b11
                        

    slli x1, x1, 2 # destination and source are the same register
                   # expected x1 = x1 *4  = 12 (0b1100)

    addi x2, x0, 1 # x2 = 1

    slli x3, x2, 15  # 1 << 15 = 32768 (2^15 = 32768) 
                     # tests a large shift amount
                     # expected x3 = 32768 (0b00000000000000001000000000000000)

    slli x4, x2, 31  # 1 << 31 = 0x80000000
                     # tests shifting to the maximum value
                     # expected x4 = 0x80000000

    addi x5, x0, -1 # x5 = 0xFFFFFFFF
                    # all bits set

    slli x6, x5, 1  # 0xFFFFFFFF << 1 = 0xFFFFFFFE
                    # verifies all bits shift left and low bit is cutoff
                    # expected x6 = 0xFFFFFFFE

wfi