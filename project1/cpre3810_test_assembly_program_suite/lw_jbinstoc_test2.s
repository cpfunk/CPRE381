.data
val_neg: 	.word 0xFFFFFFFF
val_msb: 	.word 0x80000000
val_deadbeef: 	.word 0xDEADBEEF
val_aaaa: 	.word 0xAAAAAAAA
val_5555: 	.word 0x55555555

.text
.global main

main: 

#Test 1: Load -1 0xFFFFFFFF
#Verifies lw preserves every bit when all 32 are 1
lui x1, %hi(val_neg)
addi x1, x1, %lo(val_neg)
lw x3, 0(x1)		#x3 = result = 0xFFFFFFFF
lui x2, 0xFFFFF		#x2 = 0xFFFFF000
li x2, -1		#x2 = expected = 0xFFFFFFFF 
#^^^although it is not allowed li is necessary here because if you add immediate with "-1" then you get x2 = 0xFFFFEFFF, 
#and with "0xFFF" the value is too large for a 12 bit immediate

#Test 2: Load only MSB 0x80000000
#Isolates the sign bit
lui x1, %hi(val_msb)
addi x1, x1, %lo(val_msb)
lw x5, 0(x1)		#x5 = result = 0x80000000
lui x4, 0x80000		#x4 = expected = 0x80000000

#Test 3: Load 0xDEADBEEF
#Non-uniform nibbles across all 4 bytes. Catches byte-swap bugs, endianness issues, or any partial-word load
lui x1, %hi(val_deadbeef)
addi x1, x1, %lo(val_deadbeef)
lw x7, 0(x1)		#x7 = result = 0xDEADBEEF
lui x6, 0xDEADC		#x6 = 0xDEADC000
addi x6, x6, -0x111	#x6 = expected = 0xDEADBEEF

#Test 4: Load alternating bits (1010...) 0xAAAAAAAA
lui x1, %hi(val_aaaa)
addi x1, x1, %lo(val_aaaa)
lw x9, 0(x1)		#x9 = result = 0xAAAAAAAA
lui x8, 0xAAAAB		#x8 = 0xAAAAB000
addi x8, x8, -0x556	#x8 = expected = 0xAAAAAAAA

#Test 5: Load alternating bits (0101...) 0x55555555
lui x1, %hi(val_5555)
addi x1, x1, %lo(val_5555)
lw x11, 0(x1)		#x11 = result = 0x55555555
lui x10, 0x55555	#x10 = 0xAAAAB000
addi x10, x10, 0x555	#x10 = expected = 0x55555555

wfi