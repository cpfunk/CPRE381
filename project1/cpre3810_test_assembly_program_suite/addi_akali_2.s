# Author: Abdelrahman Ali
# NetID: akali@iastate.edu
# Test: 2
# Instruction under test: ADDI
#
# This test verifies correct handling of negative immediates.
# It ensures the immediate is sign-extended correctly.

addi x1, x0, -1      # x1 = -1
addi x2, x1, -5      # x2 = -6
addi x3, x2, 2       # x3 = -4

wfi