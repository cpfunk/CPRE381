	.text
	.globl _start

_start:
	# Test 1: all 1s shifted left by 1
	# Value: checks behavior on a negative two's-complement bit pattern.
	# slli is a logical bit shift, so it should just move bits left and fill with 0 on the right.
	xori x5, x0, -1		# x5 = 0xFFFFFFFF
	slli x6, x5, 1		# expect x6 = 0xFFFFFFFE

	# Test 2: all 1s shifted left by 4
	# Value: verifies repeated 1 bits are shifted correctly over multiple positions.
	slli x7, x5, 4		# expect x7 = 0xFFFFFFF0

	# Test 3: alternating bit pattern
	# Value: useful visual pattern for checking whether every bit moved exactly one place.
	lui x8, 0x55555		# x8 = 0x55555000
	ori x8, x8, 0x555	# x8 = 0x55555555
	slli x9, x8, 1		# expect x9 = 0xAAAAAAAA

	# Test 4: negative even value shifted by 31
	# Value: checks that only the original bit 0 can survive a shift by 31.
	# Since -2 = 0xFFFFFFFE has bit 0 = 0, the result should be 0.
	addi x10, x0, -2
	slli x11, x10, 31	# expect x11 = 0x00000000
wfi