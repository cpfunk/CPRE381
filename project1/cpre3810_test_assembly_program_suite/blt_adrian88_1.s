# blt_adrian88_1.s
# Tests: basic signed comparisons involving positive, negative, and zero values.
# blt rs1, rs2, label  =>  branch if rs1 < rs2 (signed)
# Only uses: addi (above blt on the list)

.text
main:
 	# Test 1: negative < positive => branch TAKEN
	# Edge case: signed negative number should be less than positive.
	# Verifies blt interprets values as signed (not unsigned).
    	addi x1,  x0, -1			# x1 = -1
    	addi x2,  x0,  1			# x2 =  1
	addi x10, x0,  0		# x10 = 0 (stays 0 if test passes)
	blt  x1,  x2,  test1_pass  # -1 < 1 => TAKEN
	addi x10, x0,  1		# x10 = 1 => FAIL (should not reach here)
test1_pass:
	# x10 == 0 => PASS

	# Test 2: positive < negative => branch NOT TAKEN
	# Edge case: a positive number is NOT less than a negative (signed).
	# Confirms blt does not branch when condition is false.
	addi x1,  x0,  1			# x1 =  1
	addi x2,  x0, -1			# x2 = -1
   	addi x11, x0,  0		# x11 = 0 (stays 0 if test passes)
	blt  x1,  x2,  test2_fail	# 1 < -1 => NOT TAKEN (signed)
	addi x11, x0,  1		# x11 = 1 => PASS (should reach here)
	addi x12, x0,  0		# dummy
	addi x12, x0,  0		# dummy
test2_fail:
	# If we branch here, x11 stays 0 => FAIL

	# Test 3: zero < positive => branch TAKEN
	# Common case: zero is less than a positive number.
	addi x1,  x0,  0			# x1 = 0
	addi x2,  x0,  5			# x2 = 5
	addi x12, x0,  0		# x12 = 0
	blt  x1,  x2,  test3_pass 	# 0 < 5 => TAKEN
	addi x12, x0,  1		# x12 = 1 => FAIL
test3_pass:
	# x12 == 0 => PASS

	# Test 4: zero < zero => branch NOT TAKEN
	# Equal values: blt must NOT branch when rs1 == rs2.
	addi x1,  x0,  0			# x1 = 0
	addi x2,  x0,  0			# x2 = 0
	addi x13, x0,  0		# x13 = 0
	blt  x1,  x2,  test4_fail	# 0 < 0 => NOT TAKEN (equal)
	addi x13, x0,  1		# x13 = 1 => PASS
	addi x14, x0,  0		# dummy
	addi x14, x0,  0		# dummy
test4_fail:
	# If branched, x13 stays 0 => FAIL
	# End of test 1
	addi x31, x0,  0		# sentinel: x31=0 signals end of test file
wfi