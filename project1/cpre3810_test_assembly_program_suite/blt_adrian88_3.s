# blt_adrian88_3.s
# Tests: negative vs negative comparisons, and same register as both operands.
# Only uses: addi (above blt on the list)
.text
main:
	# Test 1: -5 < -1 => branch TAKEN
	# Common case: among two negatives, the more negative is "less than".
	# Verifies signed ordering works correctly for two negative values.
	addi x1,  x0, -5		# x1 = -5
	addi x2,  x0, -1		# x2 = -1
	addi x10, x0,  0	# x10 = 0
	blt  x1,  x2,  test1_pass	# -5 < -1 => TAKEN
	addi x10, x0,  1		# x10 = 1 => FAIL
test1_pass:
	# x10 == 0 => PASS
	# Test 2: -1 < -5 => branch NOT TAKEN
	# Confirms ordering: -1 is greater than -5 (signed).
	addi x1,  x0, -1			# x1 = -1
	addi x2,  x0, -5			# x2 = -5
	addi x11, x0,  0		# x11 = 0
	blt  x1,  x2,  test2_fail	# -1 < -5 => NOT TAKEN
	addi x11, x0,  1		# x11 = 1 => PASS
	addi x12, x0,  0		# dummy
	addi x12, x0,  0		# dummy
test2_fail:
	# If branched, x11 stays 0 => FAIL
	# Test 3: same register both operands => branch NOT TAKEN
	# Edge case: blt x1, x1 - a register is never less than itself.
	# Tests that the processor handles rs1 == rs2 (same physical register) correctly.
	addi x1,  x0, -42		# x1 = -42 (any value)
	addi x12, x0,  0		# x12 = 0
	blt  x1,  x1,  test3_fail	# x1 < x1 => NOT TAKEN (always false)
	addi x12, x0,  1		# x12 = 1 => PASS
	addi x13, x0,  0		# dummy
	addi x13, x0,  0		# dummy
test3_fail:
	# If branched, x12 stays 0 => FAIL
	# Test 4: -1 < 0 => branch TAKEN
	# Boundary: -1 should be less than 0 (signed).
	# Catches off-by-one errors at the signed zero boundary.
	addi x1,  x0, -1			# x1 = -1
	addi x2,  x0,  0			# x2 =  0
	addi x13, x0,  0		# x13 = 0
	blt  x1,  x2,  test4_pass	# -1 < 0 => TAKEN
	addi x13, x0,  1		# x13 = 1 => FAIL
test4_pass:
	# x13 == 0 => PASS
	addi x31, x0,  0		# sentinel: x31=0 signals end of test file
wfi