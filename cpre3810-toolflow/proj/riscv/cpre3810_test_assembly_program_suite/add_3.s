.data

.text
.globl main

# add test 3 - carries and bit patterns
# small numbers dont catch a broken bit in the adder so this pushes carries
# across the byte, half word and whole word and uses 0101/1010 patterns
# lui and addi used for setup, both above add on the list

main:

    # Start Test

    addi x1, x0, 1      # x1 = 1
    addi x2, x0, 255    # x2 = 0xff
    lui x3, 0x00010     # x3 = 0x00010000
    addi x3, x3, -1     # x3 = 0x0000ffff
    addi x4, x0, -1     # x4 = 0xffffffff
    lui x5, 0x55555
    addi x5, x5, 0x555  # x5 = 0x55555555
    lui x6, 0xaaaab
    addi x6, x6, -1366  # x6 = 0xaaaaaaaa (0xaaaab000 - 0x556)
    lui x7, 0x2aaab
    addi x7, x7, -1366  # x7 = 0x2aaaaaaa

    add x8, x2, x1      # 0xff + 1, should be 0x100. carry out of the low byte
    add x9, x3, x1      # 0xffff + 1, should be 0x10000. carry out of the low half
    add x10, x4, x1     # 0xffffffff + 1, should be 0. carry through every bit, last one dropped
    add x11, x5, x6     # 0x55555555 + 0xaaaaaaaa, should be 0xffffffff. no carries at all, every bit set
    add x12, x5, x5     # 0x55555555 + itself, should be 0xaaaaaaaa. pattern shifts up one
    add x13, x6, x6     # 0xaaaaaaaa + itself, should be 0x55555554. every set bit carries
    add x14, x5, x7     # 0x55555555 + 0x2aaaaaaa, should be 0x7fffffff. fills up to max, sign bit stays 0
    add x15, x14, x1    # 0x7fffffff + 1, should be 0x80000000. carry into bit 31
    add x16, x3, x2     # 0xffff + 0xff, should be 0x100fe. carry that stops part way

    add x17, x1, x1     # 1 + 1, should be 2
    add x17, x17, x17   # 2 + 2, should be 4
    add x17, x17, x17   # 4 + 4, should be 8
    add x17, x17, x17   # 8 + 8, should be 0x10. walks a single 1 up the bits

    lui x18, 0x12345    # x18 = 0x12345000
    lui x19, 0x6dcba    # x19 = 0x6dcba000
    add x20, x18, x19   # should be 0x7ffff000. only the upper bits in play
    addi x21, x0, 2047  # x21 = 0x7ff, biggest addi immediate
    addi x22, x0, 2047  # x22 = 0x7ff
    add x23, x21, x22   # 0x7ff + 0x7ff, should be 0xffe. only the low bits in play
    add x24, x20, x23   # 0x7ffff000 + 0xffe, should be 0x7ffffffe. both halves together

  end:

wfi