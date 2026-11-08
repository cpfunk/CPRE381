# addi_adrowski_2.s
# Test 2: Register operand handling (rd / rs1 decoding, x0, data dependencies)
#
# These cases check that addi reads from and writes to the correct
# regs: every rd/rs1 index decodes correctly, rd == rs1 works,
# writes to x0 are discarded, x0 always reads as 0, and back-to-back
# dependent addi's get the newest value

.data

.text
.globl main

main:

    # Start Test

    # Part A: write each register as itself - simple and easy to tell if bits are messed up.
    addi x1, x0, 1
    addi x2, x0, 2
    addi x3, x0, 3
    addi x4, x0, 4
    addi x5, x0, 5
    addi x6, x0, 6
    addi x7, x0, 7
    addi x8, x0, 8
    addi x9, x0, 9
    addi x10, x0, 10
    addi x11, x0, 11
    addi x12, x0, 12
    addi x13, x0, 13
    addi x14, x0, 14
    addi x15, x0, 15
    addi x16, x0, 16
    addi x17, x0, 17
    addi x18, x0, 18
    addi x19, x0, 19
    addi x20, x0, 20
    addi x21, x0, 21
    addi x22, x0, 22
    addi x23, x0, 23
    addi x24, x0, 24
    addi x25, x0, 25
    addi x26, x0, 26
    addi x27, x0, 27
    addi x28, x0, 28
    addi x29, x0, 29
    addi x30, x0, 30
    addi x31, x0, 31

    # Part B: double the value of each register - each reg feeds itself with rd = rs1
    addi x1, x1, 1         # x1 = 2
    addi x2, x2, 2         # x2 = 4
    addi x3, x3, 3         # x3 = 6
    addi x4, x4, 4         # x4 = 8
    addi x5, x5, 5         # x5 = 10
    addi x6, x6, 6         # x6 = 12
    addi x7, x7, 7         # x7 = 14
    addi x8, x8, 8         # x8 = 16
    addi x9, x9, 9         # x9 = 18
    addi x10, x10, 10      # x10 = 20
    addi x11, x11, 11      # x11 = 22
    addi x12, x12, 12      # x12 = 24
    addi x13, x13, 13      # x13 = 26
    addi x14, x14, 14      # x14 = 28
    addi x15, x15, 15      # x15 = 30
    addi x16, x16, 16      # x16 = 32
    addi x17, x17, 17      # x17 = 34
    addi x18, x18, 18      # x18 = 36
    addi x19, x19, 19      # x19 = 38
    addi x20, x20, 20      # x20 = 40
    addi x21, x21, 21      # x21 = 42
    addi x22, x22, 22      # x22 = 44
    addi x23, x23, 23      # x23 = 46
    addi x24, x24, 24      # x24 = 48
    addi x25, x25, 25      # x25 = 50
    addi x26, x26, 26      # x26 = 52
    addi x27, x27, 27      # x27 = 54
    addi x28, x28, 28      # x28 = 56
    addi x29, x29, 29      # x29 = 58
    addi x30, x30, 30      # x30 = 60
    addi x31, x31, 31      # x31 = 62

    # Part C: x0 is hardwired to zero - can't rewrite it even if trying to
    addi x0, x0, 5         # try write 5 to x0
    addi x0, x31, 100      # try write 162 to x0 from reg source
    addi x30, x0, 0        # x30 = 0 (was 60). Fails if x0 kept either value above

    # Part D: back-to-back dependencies (read-after-write hazards)
    addi x1, x0, 10        # x1 = 10
    addi x1, x1, 1         # x1 = 11  
    addi x1, x1, 1         # x1 = 12 
    addi x1, x1, -20       # x1 = -8 = 0xFFFFFFF8
    addi x2, x1, 3         # x2 = -5 = 0xFFFFFFFB
    addi x3, x2, 0         # x3 = -5 = 0xFFFFFFFB
    addi x4, x1, 8         # x4 = 0  

    addi x5, x1, 9         # x5 = 1 

    # Expected final values:
    #   x1 = 0xFFFFFFF8, x2 = 0xFFFFFFFB, x3 = 0xFFFFFFFB, x4 = 0, x5 = 1
    #   x6..x28 = 2*N (e.g. x6 = 12, x28 = 56)
    #   x29 = 0xFFFFFFF9, x30 = 0, x31 = 62, x0 = 0

  end:

wfi