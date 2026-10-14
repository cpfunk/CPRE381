# Test purpose:
#   Verify that BGEU works correctly with a backward branch target, and that it can be taken repeatedly
# Why this matters:
#   This stresses both unsigned comparison and aritmetic calculation through the branch.
# Sequence: 
#   x5 starts at 0, x6 starts at 1.
#   Control jumps to check.
#   Checks:
#     check 1: 1 >= 0 -> taken to body, x5 becomes 1
#     check 2: 1 >= 1 -> taken to body, x5 becomes 2
#     check 3: 1 >= 2 -> false, fall through
# Expected result:
#   x31 = 0, x5 = 2

    addi x31, x0, 0      # failure check 

    addi x5,  x0, 0      # x5 = 0
    addi x6,  x0, 1      # x6 = 1

    jal  x0, check

body:
    addi x5,  x5, 1      #x5++ each time the branch is passed through

check:
    bgeu x6, x5, body    # backward branch; taken while 1 >= x5 unsigned

    addi x7,  x0, 2      # target value
    beq  x5,  x7, pass   # verify final value

fail:
    addi x31, x31, 1    # if set to 1 the comparison has failed.
    jal  x0, done

pass:
    addi x0,  x0, 0

done:
    addi x0,  x0, 0
wfi