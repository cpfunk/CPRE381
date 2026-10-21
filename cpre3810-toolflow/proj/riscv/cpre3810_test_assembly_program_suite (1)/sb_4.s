# sb test 2: each byte lane is written alone, other bytes unchanged

.data
buf: .space 8

.text
.globl main

main:

    # Start Test

    lui  x5, 0x10010        # x5 = address of buf
    lui  x6, 0xAAAAB
    addi x6, x6, -1366      # x6 = 0xAAAAAAAA (fill pattern)
    sw   x6, 0(x5)
    sw   x6, 4(x5)

    addi x7, x0, 0x11
    addi x8, x0, 0x22
    addi x9, x0, 0x33
    addi x10, x0, 0x44

    # Byte 0 (lowest byte of the word)
    sb   x7, 0(x5)
    lw   x11, 0(x5)         # expect 0xAAAAAA11

    # Byte 1 (odd address), byte 0 must stay
    sb   x8, 1(x5)
    lw   x12, 0(x5)         # expect 0xAAAA2211

    # Byte 2
    sb   x9, 2(x5)
    lw   x13, 0(x5)         # expect 0xAA332211

    # Byte 3 (highest byte), confirms little-endian order
    sb   x10, 3(x5)
    lw   x14, 0(x5)         # expect 0x44332211

    # Byte 3 is at the word boundary: next word must not change
    lw   x15, 4(x5)         # expect 0xAAAAAAAA

    # Overwrite: new byte replaces old (OR bug gives 0x77, AND bug gives 0x00)
    addi x16, x0, 0x55
    sb   x16, 1(x5)
    lw   x17, 0(x5)         # expect 0x44335511

    # Store to the second word only
    sb   x7, 4(x5)
    lw   x18, 4(x5)         # expect 0xAAAAAA11
    lw   x19, 0(x5)         # expect 0x44335511

  end:

wfi