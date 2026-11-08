# Test 2: Halfword position and preservation of neighboring bytes
.data
value: .word 0x11223344

.text
lui  x5, 0x10010       # x5 = start of .data in default RARS layout

addi x6, x0, 85        # x6 = 0x0055
sh   x6, 0(x5)         # Replace LOW half only: word becomes 0x11220055
lw   x10, 0(x5)        # Expected: 0x11220055

addi x6, x0, 102       # x6 = 0x0066
sh   x6, 2(x5)         # Replace HIGH half only: word becomes 0x00660055
lw   x11, 0(x5)        # Expected: 0x00660055

wfi