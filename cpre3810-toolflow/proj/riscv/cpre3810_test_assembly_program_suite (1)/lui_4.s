.data

.text
.globl main

main:

	# Format: lui rd, imm
	# Puts imm (20 bits) into rd[31:12]. Puts zeros into rd[11:0].
	
	# This test file will test basic and boundary values, to ensure basic functionality of the lui instruction.

	# Begin tests.
	lui x5, 0x00000 # lui should properly load all 0s, making x5 0x00000000.
	
	lui x6, 0xFFFFF # verify that lui properly loads all 1s, lower 12 bits should be 0s. Expected x6 0xFFFFF000.
	
	lui x7, 0x00001 # lui should be able to properly load the smallest possible value (excluding zero), making x7 0x00001000.
	
	lui x8, 0x7FFFF # lui should be able to properly load the largest positive value (in 20-bit 2s complement), making x8 0x7FFFF000.
	
	lui x9, 0x80000 # verify that lui can properly load a 20-bit value when only the sign bit is set to 1, making x9 0x80000000.
	
	lui x10, 0x7CF26 # verify lui properly loads values into the top 20 bits and fills the bottom 12 with zeros.
	
	lui x11, 0x0F0F0 # verify lui properly loads values into the top 20 bits and fills the bottom 12 with zeros.
	
	lui x12, 0x55555 # verify lui properly loads values into the top 20 bits and fills the bottom 12 with zeros.
	
	lui x13, 0x80001 # verify lui properly loads values into the top 20 bits and fills the bottom 12 with zeros.
	
	# End tests.
wfi