#
# and_bboldog_3.s
# Unit test for AND -- register usage, data dependencies and register addressing
#
# Instructions used: and (under test), addi, lui (both above "and" in the list)
# There are no branches available above "and", so this test is not self-checking.
# After running, compare the register file to the EXPECTED values in the comments.
# These cases matter most once the processor is pipelined (forwarding/hazards),
# but they also check the single-cycle register file read/write ports.
#

.data

.text
.globl main

main:

    # Start Test

    # ---------- Section A: destination is also a source ----------

    # Case 1: rd == rs1, 0x0F0F0F0F & 0x00FF00FF = 0x000F000F
    # The register must be read before it is overwritten.
    lui  x1, 0x0F0F1        # x1 = 0x0F0F1000
    addi x1, x1, -0x0F1     # x1 = 0x0F0F0F0F
    lui  x2, 0x00FF0        # x2 = 0x00FF0000
    addi x2, x2, 0x0FF      # x2 = 0x00FF00FF
    and  x1, x1, x2         # EXPECTED x1 = 0x000F000F

    # Case 2: rd == rs2, 0x3C & 0x0F = 0x0C
    # Same as case 1 but through the rs2 port.
    addi x3, x0, 0x3C       # x3 = 0x0000003C
    addi x4, x0, 0x0F       # x4 = 0x0000000F
    and  x4, x3, x4         # EXPECTED x4 = 0x0000000C

    # Case 3: rd == rs1 == rs2, 0x5A5 & 0x5A5 = 0x5A5
    # One register read on both ports and written in the same instruction.
    addi x5, x0, 0x5A5      # x5 = 0x000005A5
    and  x5, x5, x5         # EXPECTED x5 = 0x000005A5

    # ---------- Section B: back-to-back dependencies ----------
    # Each instruction uses a result produced 1 or 2 instructions earlier.
    # In a pipeline without correct forwarding/stalling, a stale value (0 here)
    # would be read and the EXPECTED value would not appear.

    # Case 4: rs1 produced 2 instructions back, rs2 produced 1 instruction back
    lui  x10, 0x10          # x10 = 0x00010000
    addi x10, x10, -1       # x10 = 0x0000FFFF
    addi x11, x0, -1        # x11 = 0xFFFFFFFF
    and  x12, x10, x11      # EXPECTED x12 = 0x0000FFFF

    # Case 5: rs1 is the result of the AND immediately before (AND -> AND)
    and  x13, x12, x11      # EXPECTED x13 = 0x0000FFFF

    # Case 6: rs1 produced 1 back by addi, rs2 produced 2 back by an AND
    addi x14, x0, 0x0F0     # x14 = 0x000000F0
    and  x15, x14, x13      # EXPECTED x15 = 0x000000F0

    # Case 7: both operands are the result of the previous instruction
    and  x16, x15, x15      # EXPECTED x16 = 0x000000F0

    # Case 8: rs2 from the previous instruction, rs1 from several instructions back
    and  x17, x13, x16      # EXPECTED x17 = 0x000000F0

    # ---------- Section C: high register numbers ----------
    # x16-x31 need bit 4 of the register address. Using x29-x31 (11101-11111)
    # checks the upper half of the register file decodes and writes correctly.

    # Case 9: largest positive 12-bit immediate value and high registers
    # 0x7FF & 0x555 = 0x555
    addi x31, x0, 0x7FF     # x31 = 0x000007FF
    addi x30, x0, 0x555     # x30 = 0x00000555
    and  x29, x31, x30      # EXPECTED x29 = 0x00000555

    # Case 10: mixing a high register with a lower one
    # 0x7FF & 0xF0 = 0xF0
    and  x28, x31, x16      # EXPECTED x28 = 0x000000F0

  end:

wfi