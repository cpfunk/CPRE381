# beq_jaylens_3.s
# Test: beq edge cases — comparing with x0, and forward vs backward branch offsets.
# Covers: (1) using x0 as an operand, (2) a backward (negative offset) branch,
#         (3) ensuring the branch target PC is computed correctly.

# Test 3a: Compare non-zero register with x0 — should NOT branch
addi x1, x0, 7         # x1 = 7
beq  x1, x0, fail3a    # SHOULD NOT branch (7 != 0)
addi x10, x0, 1        # PASS marker
fail3a:
addi x3, x0, 1
beq  x10, x3, pass3a
addi x20, x0, 1        # FAIL flag
pass3a:

# Test 3b: Compare zero-ed register with x0 — SHOULD branch
addi x1, x0, 0         # x1 = 0
beq  x1, x0, pass3b    # SHOULD branch (0 == 0)
addi x21, x0, 1        # FAIL flag — should not execute
pass3b:

# Test 3c: Backward branch — branch to an earlier label
# We use sub to produce zero, then beq back; this checks negative PC offsets.
addi x1, x0, 10        # x1 = 10
addi x2, x0, 10        # x2 = 10
beq  x0, x0, forward   # unconditional forward jump over the backward-branch target setup
backward:
# Arrive here via forward beq below — now test backward branch skips error code
beq  x1, x2, pass3c    # SHOULD branch (10 == 10); backward landing tests offset calc
addi x22, x0, 1        # FAIL flag
pass3c:
addi x11, x0, 1        # PASS marker — reached after correct backward branch resolution
beq  x0, x0, done      # skip the "forward" label setup block
forward:
# Test 3d: Verify beq with rs1==rs2 using a computed (sub) result of zero
addi x1, x0, 55        # x1 = 55
addi x2, x0, 55        # x2 = 55
sub  x3, x1, x2        # x3 = x1 - x2 = 0
beq  x3, x0, pass3d    # SHOULD branch (0 == 0); tests beq after arithmetic produces 0
addi x23, x0, 1        # FAIL flag
pass3d:
beq  x0, x0, backward  # jump back to backward label (tests negative offset)

done:
# If x20–x23 are all 0 and x11 == 1, all tests passed.

wfi