.data
anchor: .word 0x000000AA #one word before buf, target of negative offset test
buf:	.word 0x000000BB #buf + 0
	.word 0x000000CC #buf + 4
	.word 0x00001000 #buf + 8
	.word 0x00002000 #buf + 12
	.word 0x000000DD #buf + 16
	
.text
.global main

main: 

#x1 = &buf base register for offset tests
lui x1, %hi(buf)
addi x1, x1, %lo(buf)

#Test 1: lw with offset 0
lw x3, 0(x1)		#x3 = result = 0x000000BB
addi x2, x0, 0xBB	#x2 = expected = 0x000000BB

#Test 2: lw with offset +4
lw x5, 4(x1)		#x5 = result = 0x000000CC
addi x4, x0, 0xCC	#x4 = expected = 0x000000CC

#Test 3: lw with offset +8
lw x7, 8(x1)		#x7 = result = 0x00001000
lui x6, 1		#x6 = expected = 0x00001000

#Test 4: lw with offset +12
lw x9, 12(x1)		#x9 = result = 0x00002000
lui x8, 2		#x8 = expected = 0x00002000

#Test 5: lw with offset +16
lw x11, 16(x1)		#x11 = result = 0x000000DD
addi x10, x0, 0xDD		#x10 = expected = 0x000000DD

#Test 6: lw with negative offset -4
addi x15, x1, 4		#x15 = &buf +4 for temporary shifted base
lw x13, -4(x15)		#x13 = result = 0x000000BB
addi x12, x0, 0xBB	#x12 = expected = 0x000000BB
wfi