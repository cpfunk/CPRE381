.data
# initialize memory
.space 0x5 # offset by five bytes to keep it unaligned
start: .byte 0xD
.half 0xBEEF
.half 0xF00D
.space 0x30 # offset
.half 0xDEAD
.space 0x700 # offset 
.half 0xFEED
.half 0xFFFF

.text
.globl main

main:

  # Start Test
  # this check is to see whether the function works with odd immediate values
  # this also checks loading from random places in memory
  # it also checks for some possible unintended laches, since there are some random operations sprinkled in between
  lui a0, %hi(start) # load start address
  addi a0, a0, %lo(start)
  lhu t3, 0x737(a0) # should load 0xFEED into x28
  # just to keep things interesting -> do some other operations in between
  lw t1, 3(a0)
  xori t1, t1, 0x00D
  lw t2, 3(a0)
  lhu t4, 0x35(a0) # should load 0xDEAD into x29
  lhu t5, 0x1(a0) # should load 0xBEEF into x30
  
  end:

wfi