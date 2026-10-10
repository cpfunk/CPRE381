# Author: Abdelrahman Ali
# NetID: akali@iastate.edu
# Test: 3
# Instruction under test: ADDI
#
# This test checks edge cases of the 12-bit signed immediate.
# The range of ADDI immediate is -2048 to 2047.

addi x1, x0, 2047     # maximum positive immediate
addi x2, x0, -2048    # minimum negative immediate
addi x3, x1, -1       # test boundary behavior

wfi