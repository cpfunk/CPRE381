.text
main:
#load up some upper immediates to test edge cases for sra
lui x5, 0x80000 #most negative val

#makes x6 most pos int
lui x6, 0x80000
addi x6, x6, -1 

#x12 = largest legal shift, x14 = 33 / illegal shift
addi x12, x0, 31 
addi x14, x0, 33 #0x00000021 (should still work because lowest 5 bits is 0b00001) 

#shift by 2 test
addi x15, x0, -30 #0xFFFFFFE2 (should still work because lowest 5 bits is 0b00010) 

sra x19, x5, x12 #divide most neg number by 2^31 should result in -1 or all F's/1's
sra x20, x6, x14 #most pos int shifted by 33 (should be same as div by 2)
sra x21, x5, x15 #expect x21 = 0xE0000000 (divide most neg num by 4)

#x19 = -1, 0xFFFFFFFF
#x20 = 7FFFFFFF -> 3FFFFFFF because 0111 -> 0011
#x21 = 0xE0000000 because 0b1000 sign shifted is 0b1110 (E)






wfi