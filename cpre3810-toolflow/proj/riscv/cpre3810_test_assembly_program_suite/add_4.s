.data

.text
.globl main

main:

    # positive addition across two registers
    addi x1, x0, 10    #  0xA into x1
    addi x2, x0, 25    #  0x19 into x2
    add  x3, x1, x2    # 10 + 25 = 35 (0x00000023) in x3

    # using the zero register (rs2 = x0)
    add  x4, x3, x0    #  x + 0 = x: x4 should equal x3 (35)

    #test Hardwired zero register write protection (rd = x0)
    add  x0, x1, x2    
    

wfi