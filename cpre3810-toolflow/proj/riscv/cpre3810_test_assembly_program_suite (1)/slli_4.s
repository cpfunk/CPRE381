# This test shifts a single bit by every shift amount from 1 to 30, into a new register each instruction.
# Every result should have exactly one bit set. x1 should also be unchanged after all the shifts.
# shamt is the shift amount, signifying how many places the bit shifted.
#
# Why this has value: a shifter is built from stages that shift by 1, 2, 4,
# 8 and 16. Shift amounts 1-30 use each stage alone and in every combination,
# so a broken stage shows up as a wrong result for a predictable set of shamts.
# Each output bit position 1-30 receives the 1 exactly once, checking every
# path through the shifter. Each result goes to a different register (x2-x31),
# which also checks that slli writes the correct rd for every register number.
# shamt = 0 and 31 are boundary cases and are covered in the next test.

.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, 1      # x1 = 0x00000001: single set bit in position 0 is the source for every shift below

    slli x2,  x1, 1     # expect 0x00000002  shamt=1
    slli x3,  x1, 2     # expect 0x00000004  shamt=2
    slli x4,  x1, 3     # expect 0x00000008  shamt=3
    slli x5,  x1, 4     # expect 0x00000010  shamt=4
    slli x6,  x1, 5     # expect 0x00000020  shamt=5
    slli x7,  x1, 6     # expect 0x00000040  shamt=6
    slli x8,  x1, 7     # expect 0x00000080  shamt=7
    slli x9,  x1, 8     # expect 0x00000100  shamt=8
    slli x10, x1, 9     # expect 0x00000200  shamt=9
    slli x11, x1, 10    # expect 0x00000400  shamt=10
    slli x12, x1, 11    # expect 0x00000800  shamt=11
    slli x13, x1, 12    # expect 0x00001000  shamt=12
    slli x14, x1, 13    # expect 0x00002000  shamt=13
    slli x15, x1, 14    # expect 0x00004000  shamt=14
    slli x16, x1, 15    # expect 0x00008000  shamt=15
    slli x17, x1, 16    # expect 0x00010000  shamt=16
    slli x18, x1, 17    # expect 0x00020000  shamt=17
    slli x19, x1, 18    # expect 0x00040000  shamt=18
    slli x20, x1, 19    # expect 0x00080000  shamt=19
    slli x21, x1, 20    # expect 0x00100000  shamt=20
    slli x22, x1, 21    # expect 0x00200000  shamt=21
    slli x23, x1, 22    # expect 0x00400000  shamt=22
    slli x24, x1, 23    # expect 0x00800000  shamt=23
    slli x25, x1, 24    # expect 0x01000000  shamt=24
    slli x26, x1, 25    # expect 0x02000000  shamt=25
    slli x27, x1, 26    # expect 0x04000000  shamt=26
    slli x28, x1, 27    # expect 0x08000000  shamt=27
    slli x29, x1, 28    # expect 0x10000000  shamt=28
    slli x30, x1, 29    # expect 0x20000000  shamt=29
    slli x31, x1, 30    # expect 0x40000000  shamt=30

    # x1 should still be 0x00000001: slli must not modify its source register

  end:

wfi