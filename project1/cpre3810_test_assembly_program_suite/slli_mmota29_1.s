	.text
	.globl _start

_start:
	# Test 1: shift by 0
	# Value: verifies slli with shamt = 0 leaves the source unchanged.
	addi x5, x0, 0
	slli x6, x5, 0		# expect x6 = 0x00000000

	# Test 2: simple small shift
	# Value: common case; verifies a single-bit left shift works correctly.
	addi x7, x0, 1
	slli x8, x7, 1		# expect x8 = 0x00000002

	# Test 3: multi-bit shift on a small positive value
	# Value: checks that several low bits move left correctly.
	addi x9, x0, 15
	slli x10, x9, 4		# expect x10 = 0x000000F0

	# Test 4: shift across a higher bit position
	# Value: verifies bits move correctly into a higher position, not just near bit 0.
	addi x11, x0, 1024
	slli x12, x11, 1	# expect x12 = 0x00000800
wfi