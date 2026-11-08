# Test 1: Basic SH values (zero, positive, negative)
.data
values: .word 0, 0, 0

.text
lui  x5, 0x10010       # x5 = start of .data in default RARS memory layout

addi x6, x0, 0         # Zero checks that SH can write 0
sh   x6, 0(x5)         # First word should be 0x00000000

addi x6, x0, 100       # Positive value checks a normal store
sh   x6, 4(x5)         # Second word should be 0x00000064

addi x6, x0, -1        # -1 has lower 16 bits = 0xFFFF
sh   x6, 8(x5)         # Third word should be 0x0000FFFF

lw   x10, 0(x5)        # Check result: 0x00000000
lw   x11, 4(x5)        # Check result: 0x00000064
lw   x12, 8(x5)        # Check result: 0x0000FFFF

wfi