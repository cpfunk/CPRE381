.data
# initialize memory
start: .word 0x00000000
.space 0x7F0 # set the alignment to some large value
.half 0xFEED
.half 0xDEAD
.half 0xBEEF

.text
.globl main

main:

  # Start Test
  # this check is to see whether the function works well with large immediate values
  lui a0, %hi(start) # load start address
  addi a0, a0, %lo(start)
  lhu t3, 0x7F4(a0) # should load 0xFEED into x28
  lhu t4, 0x7F6(a0) # should load 0xDEAD into x29
  lhu t5, 0x7F8(a0) # should load 0xBEEF into x30
  end:

wfi