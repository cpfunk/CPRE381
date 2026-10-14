# This test is to see if we can pull a mask out of our registers using andi
.data
.text
.globl main
main:
# "Normal case", flip an endcap bit
addi x1, x0, 15 # Fills our 4 least significant bits with 1s
andi x2, x1, 7 # Our mask, should flip bit 3 to 0 if working correctly
# "Edge case", flip a "random" bit in the middle of our register
addi x3, x0, -1 # Sets all bits to 1
andi x4, x3, 1  # Should flip everthing but bit 0 to zero if working correctly
wfi