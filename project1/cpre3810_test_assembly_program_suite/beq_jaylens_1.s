# beq_jaylens_1.s
# Test: beq branches when two registers are EQUAL (common case)
# This verifies the fundamental behavior of beq: branch taken when rs1 == rs2.

# Test 1a: Both registers hold zero — simplest equal case
addi x1, x0, 0         # x1 = 0
addi x2, x0, 0         # x2 = 0
beq  x1, x2, pass1a    # SHOULD branch (0 == 0)
addi x10, x0, 1        # FAIL: should not execute (sets x10=1 as error flag)
pass1a:

# Test 1b: Both registers hold a positive value
addi x1, x0, 42        # x1 = 42
addi x2, x0, 42        # x2 = 42
beq  x1, x2, pass1b    # SHOULD branch (42 == 42)
addi x11, x0, 1        # FAIL: should not execute
pass1b:

# Test 1c: Both registers hold a negative value (sign extension check)
addi x1, x0, -1        # x1 = 0xFFFFFFFF (-1 in two's complement)
addi x2, x0, -1        # x2 = 0xFFFFFFFF
beq  x1, x2, pass1c    # SHOULD branch (-1 == -1)
addi x12, x0, 1        # FAIL: should not execute
pass1c:

# Test 1d: Both registers hold the max positive 12-bit immediate
addi x1, x0, 2047      # x1 = 2047 (max addi immediate)
addi x2, x0, 2047      # x2 = 2047
beq  x1, x2, pass1d    # SHOULD branch (2047 == 2047)
addi x13, x0, 1        # FAIL: should not execute
pass1d:

# Test 1e: Compare a register with itself — always equal
addi x1, x0, 99        # x1 = 99
beq  x1, x1, pass1e    # SHOULD branch (rs1 and rs2 are the same register)
addi x14, x0, 1        # FAIL: should not execute
pass1e:

# If x10–x14 are all still 0, all tests passed.

wfi