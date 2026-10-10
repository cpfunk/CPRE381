# Test logical Nulls and Identities
.data
.text
.globl main
main:
# "Normal case", set all bits to 1 or 0 by ANDing with -1 or 0
addi x10, x0, -1 # Set all bits to 1
andi x11, x10, 0 # Should result is an all zero x11 due to all ANDs resulting in 0
andi x12, x10, -1 # Should fill x12 with all ones since all ANDs should result in 1
# "Edge case", set "random" bits to 1 and AND with "random" numbers
addi x13, x0, 1027 # Set bits 10, 1 and 0 to 1
andi x14, x13, 1024 # Only bit 10 should remain active after this test

wfi