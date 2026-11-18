# hw_data_hazard_test.s
# Jamison Bice & Christopher Fun

.data
buf:
    .word 0, 0, 0, 0

.text
.globl main

main:
    # Base pointer setup 
    lui   tp, 0x10010          # tp = 0x10010000
    addi  tp, tp, 0            

    #EX/MEM -> EX 
    addi  t0, x0, 15           # t0 = 15
    add   t1, t0, t0           #t1 = 30

    #MEM/WB -> EX 
    addi  t2, x0, 7            # t2 = 7
    addi  t3, x0, 4            # (1 intervening instruction)
    sub   t4, t2, t0           #t2=7 t0=15 -> t4 = -8
    add   t5, t3, t2           #t3=4,t2=7  -> t5 = 11

    #WB -> DE Register File Bypass
    addi  s0, x0, 100          # produces s0 = 100
    addi  s1, x0, 200          # produces s1 = 200
    addi  s2, x0, 300          
    add   s3, s0, t0           # s3 = 115
    add   s4, t0, s1           # s4 = 215

    #EX/MEM must take priority over MEM/WB
    addi  a0, x0, 10           # oldest write to a0 (10)
    addi  a0, a0, 20           # Newer write to a0 (30) 
    addi  a1, a0, 5            #  a1 = 35

    #x0 Hazard Immunity
    addi  x0, t0, 99           # Attempt to write 114 to x0
    addi  a2, x0, 42           #  a2 = 42
    addi  x0, t0, 88           # attempt to write 103 to x0
    addi  t6, x0, 1            # Intervening instruction 
    add   a3, x0, t6           #  a3 = 1

    #Store Hazards 
    addi  s5, tp, 4            # s5 = 0x10010004 
    addi  s6, x0, 0x5A         # s6 = 0x5A 
    sw    s6, 4(s5)            #  Mem[0x10010008] = 0x5A

    # Load-Use Hazard Stall
    lw    s7, 8(tp)            # loads 0x5A from 0x10010008
    addi  s8, s7, 6            #  s8 = 0x60 (96)
    lw    s9, 8(tp)            # Loads 0x5A from 0x10010008
    add   s10, s8, s9          #  s10 = 186 (0xBA)

    # Load-to-Store Data Hazard 
    lw    s11, 8(tp)           # Loads 0x5A
    sw    s11, 12(tp)          # Load-Use stall on Store RS2 (s11)
    lw    a4, 12(tp)           #  a4 = 0x5A

    # Store final verification checksum at buf[0]:
    # t1(30) + t4(-8) + t5(11) + s3(115) + s4(215) + a1(35) + a2(42) + a3(1) + s8(96) + s10(186) + a4(90) = 813 (0x32D)
    add   a5, t1, t4           # 22
    add   a5, a5, t5           # 33
    add   a5, a5, s3           # 148
    add   a5, a5, s4           # 363
    add   a5, a5, a1           # 398
    add   a5, a5, a2           # 440
    add   a5, a5, a3           # 441
    add   a5, a5, s8           # 537
    add   a5, a5, s10          # 723
    add   a5, a5, a4           # 813 (0x0000032D)
    sw    a5, 0(tp)            # Mem[0x10010000] = 813 (0x32D)

    wfi