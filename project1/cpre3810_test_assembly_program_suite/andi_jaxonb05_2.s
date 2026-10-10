# Testing sign extension of the 12-bit immediate
.data
.text
.globl main
main:
# "Normal case". fill upper bits with 0
addi x5, x0, 2047 # Set the first 12 bits to 1
andi x6, x5, -1 # Should result in the upper 20 bits being 0
# "Edge case", attempt a sign extend that should actually achieve nothing
addi x7, x0, 0 # Make sure x7 is zero
andi x8, x7, -2048 # Each bit should stay at zero
wfi