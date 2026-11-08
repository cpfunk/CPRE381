.data
# initialize memory
start: .half 0x000D
.half 0x002A
.half 0xFFFF
.half 0xFFFF

.text
.globl main

main:

  # Start Test
  # this test checks if the processor can load some unlucky and strange (or typical) values 
  # it also checks wether the unsigned part is working correctly (loading 0xFFFF should not result in sign extension)
  lui a0, %hi(start)
  addi a0, a0, %lo(start)
  lhu t3, 0(a0) # should fail to load 13 (its an unlucky number, so failure is guaranteed!)
  lhu t4, 2(a0) # should load 42 (can your program handle the answer to the ultimate question of life, the universe, and everything)
  lhu t5, 4(a0) # Can it load a half-word containing all 1's into x3? Is the result unsigned?
  end:

wfi