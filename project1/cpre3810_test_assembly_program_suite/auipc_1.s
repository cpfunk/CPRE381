
.text
.globl main
main:
    # Clear registers using addi
    addi x1, x0, 0
    addi x2, x0, 0
    addi x3, x0, 0

# --- Test 1: imm = 0 ---
# AUIPC adds (imm << 12) to the current PC.
# With imm = 0, result should just be the PC of this instruction.
test1:
    auipc x1, 0       # x1 = PC(test1) + 0

# --- Test 2: imm = 1 ---
# Should add 4096 (1 << 12) to PC.
test2:
    auipc x2, 1       # x2 = PC(test2) + 4096

# --- Test 3: rd = x0 ---
# Writing to x0 should have no effect.
test3:
    auipc x0, 2       # x0 remains 0

# End program
#end:
wfi
  #  j end             # loop forever

