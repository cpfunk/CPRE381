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
    addi  tp, tp, 0            # EX/MEM -> EX on RS1 (tp = 0x10010000)

    #EX/MEM -> EX 
    addi  t0, x0, 15           # t0 = 15
    add   t1, t0, t0           # EX/MEM -> EX on both RS1 and RS2 (t1 = 30)

    #MEM/WB -> EX 
    addi  t2, x0, 7            # t2 = 7
    addi  t3, x0, 4            # (1 intervening instruction)
    sub   t4, t2, t0           # MEM/WB -> EX on RS1 (t2=7), WB/DE on RS2 (t0=15) -> t4 = -8
    add   t5, t3, t2           # MEM/WB -> EX on RS1 (t3=4), WB/DE on RS2 (t2=7)  -> t5 = 11

    #WB -> DE Register File Bypass
    addi  s0, x0, 100          # produces s0 = 100
    addi  s1, x0, 200          # produces s1 = 200
    addi  s2, x0, 300          
    add   s3, s0, t0           #(s0 in WB, read in DE on RS1) -> s3 = 115
    add   s4, t0, s1           #(s1 in WB, read in DE on RS2) -> s4 = 215

    #EX/MEM must take priority over MEM/WB
    addi  a0, x0, 10           # Oldest write to a0 (10)
    addi  a0, a0, 20           # Newer write to a0 (30) - forwards from EX/MEM
    addi  a1, a0, 5            # Must forward a0=30 from EX/MEM, NOT a0=10 from MEM/WB -> a1 = 35

    #x0 Hazard Immunity
    addi  x0, t0, 99           # Attempt to write 114 to x0 (in EX/MEM next cycle)
    addi  a2, x0, 42           # EX/MEM RD=x0 must not forward -> a2 = 42
    addi  x0, t0, 88           # Attempt to write 103 to x0
    addi  t6, x0, 1            # Intervening instruction (pushes x0 write to MEM/WB)
    add   a3, x0, t6           # MEM/WB RD=x0 must not forward -> a3 = 1

    #Store Hazards 
    addi  s5, tp, 4            # s5 = 0x10010004 (base address in EX/MEM)
    addi  s6, x0, 0x5A         # s6 = 0x5A (store data in EX/MEM, s5 now in MEM/WB)
    sw    s6, 4(s5)            # RS1 (s5) from MEM/WB, RS2 (s6) from EX/MEM, IMM=4 -> Mem[0x10010008] = 0x5A

    # Load-Use Hazard Stall
    lw    s7, 8(tp)            # Loads 0x5A from 0x10010008
    addi  s8, s7, 6            # Load-Use stall on RS1 (stalls 1 cycle, then forwards from WB) -> s8 = 0x60 (96)
    lw    s9, 8(tp)            # Loads 0x5A from 0x10010008
    add   s10, s8, s9          # Load-Use stall on RS2 (s9) + MEM/WB forward on RS1 (s8) -> s10 = 186 (0xBA)

    # Load-to-Store Data Hazard 
    lw    s11, 8(tp)           # Loads 0x5A
    sw    s11, 12(tp)          # Load-Use stall on Store RS2 (s11), then forwards into MEM_DATA_SRC_MUX
    lw    a4, 12(tp)           # Verify store worked -> a4 = 0x5A

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