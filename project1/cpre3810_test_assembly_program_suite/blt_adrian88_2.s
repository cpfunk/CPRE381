# blt_adrian88_2.s
# Tests: extreme 32-bit signed values (most negative and most positive).
# Edge case: ensures blt correctly handles INT_MIN and INT_MAX boundaries.
# Only uses: addi, lui (both above blt on the list)

# INT_MAX =  0x7FFFFFFF =  2147483647
# INT_MIN =  0x80000000 = -2147483648
.text
main:
	# Test 1: INT_MIN < INT_MAX => branch TAKEN
	# Most extreme possible signed comparison.
	# Verifies the processor handles the full signed range correctly.
	lui  x1,  0x80000		# x1 = 0x80000000 = INT_MIN
	lui  x2,  0x7FFFF
	addi x2,  x2,  0x7FF		# x2 = 0x7FFFFFFF = INT_MAX
	addi x10, x0,  0		# x10 = 0 (stays 0 if test fails)
	blt  x1,  x2,  test1_pass	# INT_MIN < INT_MAX => TAKEN
	addi x10, x0,  1		# x10 = 1 => FAIL
test1_pass:
	# x10 == 0 => PASS
	# Test 2: INT_MAX < INT_MIN => branch NOT TAKEN
	# Flipped: INT_MAX is NOT less than INT_MIN (signed).
	# Confirms blt correctly orders extreme values.
	lui  x1,  0x80000		# x1 = INT_MIN
	lui  x2,  0x7FFFF
	addi x2,  x2,  0x7FF		# x2 = INT_MAX
	addi x11, x0,  0		# x11 = 0
	blt  x2,  x1,  test2_fail	# INT_MAX < INT_MIN => NOT TAKEN
	addi x11, x0,  1		# x11 = 1 => PASS
	addi x12, x0,  0		# dummy
	addi x12, x0,  0		# dummy
test2_fail:
	# If branched, x11 stays 0 => FAIL
	# Test 3: INT_MIN < -1 => branch TAKEN
	# INT_MIN should be less than any other negative number.
	lui  x1,  0x80000		# x1 = INT_MIN
	addi x2,  x0,  -1		# x2 = -1
	addi x12, x0,  0		# x12 = 0
	blt  x1,  x2,  test3_pass	# INT_MIN < -1 => TAKEN
	addi x12, x0,  1		# x12 = 1 => FAIL
test3_pass:
	# x12 == 0 => PASS
	# Test 4: INT_MAX < INT_MAX => branch NOT TAKEN
	# Equal extreme values must not branch.
	lui  x1,  0x7FFFF
	addi x1,  x1,  0x7FF		# x1 = INT_MAX
	lui  x2,  0x7FFFF
	addi x2,  x2,  0x7FF		# x2 = INT_MAX
	addi x13, x0,  0		# x13 = 0
	blt  x1,  x2,  test4_fail	# INT_MAX < INT_MAX => NOT TAKEN (equal)
	addi x13, x0,  1		# x13 = 1 => PASS
	addi x14, x0,  0		# dummy
	addi x14, x0,  0		# dummy
test4_fail:
	# If branched, x13 stays 0 => FAIL
	addi x31, x0,  0		# sentinel: x31=0 signals end of test file
wfi