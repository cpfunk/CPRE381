.data

.text
.globl main

main:

    # Start Test
    # lui test 1: one immediate bit at a time
    # Uses only lui

    # Walking one: finds a bit that is stuck at 0 or wired to the wrong place
    lui x1, 0x00001    # x1 = 0x00001000: imm bit 0 sets result bit 12
    lui x2, 0x00002    # x2 = 0x00002000: imm bit 1 sets result bit 13
    lui x3, 0x00004    # x3 = 0x00004000: imm bit 2 sets result bit 14
    lui x4, 0x00008    # x4 = 0x00008000: imm bit 3 sets result bit 15
    lui x5, 0x00010    # x5 = 0x00010000: imm bit 4 sets result bit 16
    lui x6, 0x00020    # x6 = 0x00020000: imm bit 5 sets result bit 17
    lui x7, 0x00040    # x7 = 0x00040000: imm bit 6 sets result bit 18
    lui x8, 0x00080    # x8 = 0x00080000: imm bit 7 sets result bit 19
    lui x9, 0x00100    # x9 = 0x00100000: imm bit 8 sets result bit 20
    lui x10, 0x00200   # x10 = 0x00200000: imm bit 9 sets result bit 21
    lui x11, 0x00400   # x11 = 0x00400000: imm bit 10 sets result bit 22
    lui x12, 0x00800   # x12 = 0x00800000: imm bit 11 sets result bit 23
    lui x13, 0x01000   # x13 = 0x01000000: imm bit 12 sets result bit 24
    lui x14, 0x02000   # x14 = 0x02000000: imm bit 13 sets result bit 25
    lui x15, 0x04000   # x15 = 0x04000000: imm bit 14 sets result bit 26
    lui x16, 0x08000   # x16 = 0x08000000: imm bit 15 sets result bit 27
    lui x17, 0x10000   # x17 = 0x10000000: imm bit 16 sets result bit 28
    lui x18, 0x20000   # x18 = 0x20000000: imm bit 17 sets result bit 29
    lui x19, 0x40000   # x19 = 0x40000000: imm bit 18 sets result bit 30
    lui x20, 0x80000   # x20 = 0x80000000: imm bit 19 sets the sign bit

    # Walking zero: finds a bit that is stuck at 1
    lui x1, 0xFFFFE    # x1 = 0xFFFFE000: imm bit 0 clear
    lui x2, 0xFFFFD    # x2 = 0xFFFFD000: imm bit 1 clear
    lui x3, 0xFFFFB    # x3 = 0xFFFFB000: imm bit 2 clear
    lui x4, 0xFFFF7    # x4 = 0xFFFF7000: imm bit 3 clear
    lui x5, 0xFFFEF    # x5 = 0xFFFEF000: imm bit 4 clear
    lui x6, 0xFFFDF    # x6 = 0xFFFDF000: imm bit 5 clear
    lui x7, 0xFFFBF    # x7 = 0xFFFBF000: imm bit 6 clear
    lui x8, 0xFFF7F    # x8 = 0xFFF7F000: imm bit 7 clear
    lui x9, 0xFFEFF    # x9 = 0xFFEFF000: imm bit 8 clear
    lui x10, 0xFFDFF   # x10 = 0xFFDFF000: imm bit 9 clear
    lui x11, 0xFFBFF   # x11 = 0xFFBFF000: imm bit 10 clear
    lui x12, 0xFF7FF   # x12 = 0xFF7FF000: imm bit 11 clear
    lui x13, 0xFEFFF   # x13 = 0xFEFFF000: imm bit 12 clear
    lui x14, 0xFDFFF   # x14 = 0xFDFFF000: imm bit 13 clear
    lui x15, 0xFBFFF   # x15 = 0xFBFFF000: imm bit 14 clear
    lui x16, 0xF7FFF   # x16 = 0xF7FFF000: imm bit 15 clear
    lui x17, 0xEFFFF   # x17 = 0xEFFFF000: imm bit 16 clear
    lui x18, 0xDFFFF   # x18 = 0xDFFFF000: imm bit 17 clear
    lui x19, 0xBFFFF   # x19 = 0xBFFFF000: imm bit 18 clear
    lui x20, 0x7FFFF   # x20 = 0x7FFFF000: sign bit clear

  end:

wfi