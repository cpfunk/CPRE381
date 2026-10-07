	.text
	.globl _start

_start:
	# Test 1: maximum legal shift amount in RV32
	# Value: shamt = 31 is the boundary case for slli on a 32-bit processor.
	addi x5, x0, 1
	slli x6, x5, 31		# expect x6 = 0x80000000

	# Test 2: shifting out the top bit
	# Value: verifies overflow/truncation behavior; the top bit is discarded.
	slli x7, x6, 1		# expect x7 = 0x00000000

	# Test 3: value already near the top of the word
	# Value: checks that a bit in position 30 moves into position 31 correctly.
	lui x8, 0x40000		# x8 = 0x40000000
	slli x9, x8, 1		# expect x9 = 0x80000000

	# Test 4: overflow from a high-order bit pattern
	# Value: verifies that shifting a high bit pattern too far left truncates to 32 bits.
	slli x10, x8, 2		# expect x10 = 0x00000000
wfi