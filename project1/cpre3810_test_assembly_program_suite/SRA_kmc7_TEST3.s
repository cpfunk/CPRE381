.text
    .globl main
main:

    # test 1

    addi x1, x0, -2         # 0xFFFFFFFE

    addi x5, x0, 1
    sra  x10, x1, x5        #0xFFFFFFFF
    srl  x11, x1, x5        #0x7FFFFFFF


    # test 2

    lui  x2, 0x80000        # 0x80000000
    addi x2, x2, 1          # 0x80000001

    addi x5, x0, 4
    sra  x12, x2, x5        # 0xF8000000
    srl  x13, x2, x5        # 0x08000000


    # test 3

    lui  x6, 0x80000
    addi x6, x6, -1         # 0x7FFFFFFF

    addi x5, x0, 1
    sra  x14, x6, x5        # 0x3FFFFFFF
    srl  x15, x6, x5        # 0x3FFFFFFF


    # test 4

    addi x7, x0, -42
    addi x5, x0, 31
    sra  x16, x7, x5        # 0xFFFFFFFF

    addi x7, x0, 42
    sra  x17, x7, x5        # 0x00000000



    addi x0, x0, 0
wfi