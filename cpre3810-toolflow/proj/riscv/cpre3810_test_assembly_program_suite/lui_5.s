.data

.text
.globl main

main:

	# Format: lui rd, imm
	# Puts imm (20 bits) into rd[31:12]. Puts zeros into rd[11:0].
	
	# This test file will test patterns, such as alternating 1s and 0s. This is important to make sure that lui is putting all the bits in the right place.

	# Begin tests.
	lui x5, 0x55555 # verify lui properly loads a pattern of alternating 0s and 1s, with the sign bit being 0 and alternating from there.
	
	lui x6, 0xAAAAA # verify lui properly loads a pattern of alternating 1s and 0s, with the sign bit being 1 and alternating from there.
	
	lui x7, 0xF0F0F # verify lui properly loads a pattern of four 1s alternating with four 0s.
	
	lui x7, 0x0F0F0 # verify lui properly loads a pattern of four 1s alternating with four 0s.
	
	lui x8, 0x00001 # this and the following tests will ensure that, when only 1 bit of the immediate is a 1, the proper bit in the upper 20 bits is set. Expected x8 0x00001000.
	
	lui x9, 0x00002 # 1 placement test, see above test. Expected x9 0x00002000.
	
	lui x10, 0x00004 # 1 placement test. Expected x10 0x00004000.
	
	lui x11, 0x00008 # 1 placement test. Expected x11 0x00008000.
	
	lui x12, 0x00010 # 1 placement test. Expected x12 0x00010000.
wfi