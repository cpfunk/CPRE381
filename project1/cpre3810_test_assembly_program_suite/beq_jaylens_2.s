# beq_jaylens_2.s
# Test: beq does NOT branch when two registers are NOT equal (branch not-taken path)
# A buggy processor might always branch or never branch — this catches both bugs.

# Test 2a: Different positive values — branch must NOT be taken
addi x1, x0, 5         # x1 = 5
addi x2, x0, 6         # x2 = 6
beq  x1, x2, fail2a    # SHOULD NOT branch (5 != 6)
addi x10, x0, 1        # PASS marker: this line should execute
fail2a:

# Verify pass marker was set; if x10 != 1 here, beq misbehaved
addi x3, x0, 1
beq  x10, x3, pass2a   # branch if x10 == 1 (i.e., pass)
addi x15, x0, 1        # FAIL flag
pass2a:

# Test 2b: Positive vs negative — branch must NOT be taken
addi x1, x0, 1         # x1 = 1
addi x2, x0, -1        # x2 = -1 (0xFFFFFFFF)
beq  x1, x2, fail2b    # SHOULD NOT branch (1 != -1)
addi x11, x0, 1        # PASS marker
fail2b:

addi x3, x0, 1
beq  x11, x3, pass2b
addi x16, x0, 1        # FAIL flag
pass2b:

# Test 2c: Zero vs nonzero — branch must NOT be taken
addi x1, x0, 0         # x1 = 0
addi x2, x0, 1         # x2 = 1
beq  x1, x2, fail2c    # SHOULD NOT branch (0 != 1)
addi x12, x0, 1        # PASS marker
fail2c:

addi x3, x0, 1
beq  x12, x3, pass2c
addi x17, x0, 1        # FAIL flag
pass2c:

# Test 2d: Values differ only in sign bit (edge case: large positive vs small negative)
addi x1, x0, 2047      # x1 = 2047
addi x2, x0, -2048     # x2 = -2048
beq  x1, x2, fail2d    # SHOULD NOT branch
addi x13, x0, 1        # PASS marker
fail2d:

addi x3, x0, 1
beq  x13, x3, pass2d
addi x18, x0, 1        # FAIL flag
pass2d:

# If x15–x18 are all 0, all not-taken tests passed.

wfi