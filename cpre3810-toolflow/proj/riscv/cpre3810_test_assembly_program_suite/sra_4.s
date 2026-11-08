.text

main:
addi x5, x0, 16          # x5 = 16 (positive)
addi x6, x0, 2           # shift amount 2
sra  x7, x5, x6          # expect 4: 16/4 = 4

addi x8, x0, -16         # x8 = 0xFFFFFFF0
sra  x9, x8, x6          # expect 0xFFFFFFFC (-4): sign bit replicated

addi x10, x0, -1         # all ones
addi x11, x0, 31
sra  x12, x10, x11       # expect 0xFFFFFFFF all 1's sign shifted is still all 1's

addi x13, x0, 5
sra  x14, x13, x0        # shift by 0: expect 5 (identity)

#x7 = 4,   0x00000004
#x9 = -4,  0xFFFFFFFC
#x12 = -1, 0xFFFFFFFF
#x14 = 5,  0x00000005
wfi