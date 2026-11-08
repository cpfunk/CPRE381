.data

.text
.globl main

main:

    # Start Test
    # lui test 2: every destination register, x0, field overlap, lui with addi
    # Uses only lui and addi

    # Every register gets a different value so a write to the wrong register shows
    lui x1, 0x08421    # x1 = 0x08421000: rd = 00001
    lui x2, 0x10842    # x2 = 0x10842000: rd = 00010
    lui x3, 0x18C63    # x3 = 0x18C63000: rd = 00011
    lui x4, 0x21084    # x4 = 0x21084000: rd = 00100
    lui x5, 0x294A5    # x5 = 0x294A5000: rd = 00101
    lui x6, 0x318C6    # x6 = 0x318C6000: rd = 00110
    lui x7, 0x39CE7    # x7 = 0x39CE7000: rd = 00111
    lui x8, 0x42108    # x8 = 0x42108000: rd = 01000
    lui x9, 0x4A529    # x9 = 0x4A529000: rd = 01001
    lui x10, 0x5294A   # x10 = 0x5294A000: rd = 01010
    lui x11, 0x5AD6B   # x11 = 0x5AD6B000: rd = 01011
    lui x12, 0x6318C   # x12 = 0x6318C000: rd = 01100
    lui x13, 0x6B5AD   # x13 = 0x6B5AD000: rd = 01101
    lui x14, 0x739CE   # x14 = 0x739CE000: rd = 01110
    lui x15, 0x7BDEF   # x15 = 0x7BDEF000: rd = 01111
    lui x16, 0x84210   # x16 = 0x84210000: rd = 10000
    lui x17, 0x8C631   # x17 = 0x8C631000: rd = 10001
    lui x18, 0x94A52   # x18 = 0x94A52000: rd = 10010
    lui x19, 0x9CE73   # x19 = 0x9CE73000: rd = 10011
    lui x20, 0xA5294   # x20 = 0xA5294000: rd = 10100
    lui x21, 0xAD6B5   # x21 = 0xAD6B5000: rd = 10101
    lui x22, 0xB5AD6   # x22 = 0xB5AD6000: rd = 10110
    lui x23, 0xBDEF7   # x23 = 0xBDEF7000: rd = 10111
    lui x24, 0xC6318   # x24 = 0xC6318000: rd = 11000
    lui x25, 0xCE739   # x25 = 0xCE739000: rd = 11001
    lui x26, 0xD6B5A   # x26 = 0xD6B5A000: rd = 11010
    lui x27, 0xDEF7B   # x27 = 0xDEF7B000: rd = 11011
    lui x28, 0xE739C   # x28 = 0xE739C000: rd = 11100
    lui x29, 0xEF7BD   # x29 = 0xEF7BD000: rd = 11101
    lui x30, 0xF7BDE   # x30 = 0xF7BDE000: rd = 11110
    lui x31, 0xFFFFF   # x31 = 0xFFFFF000: rd = 11111

    # x0 must stay zero
    lui x0, 0xFFFFF    # x0 stays 0x00000000: write to x0 must be ignored
    addi x1, x0, 0     # x1 = 0x00000000: copy x0 so the result can be seen

    # The immediate sits where other formats keep rs1, rs2, funct3 and funct7
    # lui must ignore those fields
    addi x31, x0, -1   # x31 = 0xFFFFFFFF: nonzero value for the fake rs1 and rs2 to point at
    lui x2, 0x000F8    # x2 = 0x000F8000: rs1 field bits all ones, fails if rs1 is added
    lui x3, 0x01F00    # x3 = 0x01F00000: rs2 field bits all ones, fails if rs2 is used
    lui x4, 0x00007    # x4 = 0x00007000: funct3 field bits all ones, fails if funct3 is decoded
    lui x5, 0xFE000    # x5 = 0xFE000000: funct7 field bits all ones, fails if funct7 is decoded
    lui x6, 0x00000    # x6 = 0x00000000: all fields zero as a baseline

    # lui followed by addi to build a full 32 bit constant, the common use of lui
    lui x7, 0x12345    # x7 = 0x12345000: upper 20 bits
    addi x7, x7, 0x678 # x7 = 0x12345678: positive low part
    lui x8, 0xDEADC    # x8 = 0xDEADC000: upper part is one higher to make up for the negative low part
    addi x8, x8, -273  # x8 = 0xDEADBEEF: negative low part
    lui x9, 0x80000    # x9 = 0x80000000: most negative value
    addi x9, x9, -1    # x9 = 0x7FFFFFFF: overflow wraps to the most positive value
    lui x10, 0x7FFFF   # x10 = 0x7FFFF000: largest positive lui result
    addi x10, x10, 2047 # x10 = 0x7FFFF7FF: largest low part with no carry

  end:

wfi