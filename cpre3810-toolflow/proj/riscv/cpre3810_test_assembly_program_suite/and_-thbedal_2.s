.data
.text
.globl main

main:
# TEST 2: Mutually Exclusive and Overlapping Bit Patterns

# Load values using lui (upper 20 bits) to test large numbers
lui x1, 0x55555      # x1 = 0x55555000 (0101...)
lui x2, 0xAAAAA      # x2 = 0xAAAAA000 (1010...)
lui x4, 0xFFFFF      # x4 = 0xFFFFF000 (all 1s in upper 20 bits)

# Test Mutually Exclusive Bits (Expected: 0)
and x3, x1, x2       # verify that completely mismatched bit patterns correctly 
                     # result in zero without bleeding over into adjacent bits

# Test Overlapping Bits (Expected: 0x55555000)
and x5, x1, x4       # verify that masking large upper-immediate numbers works appropriately 
wfi