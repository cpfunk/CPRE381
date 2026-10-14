# File: bne_veda_3.s
# Purpose: Stress test for bne instruction 
# Test Case 3: Edge-case branch offsets (positive and negative)
# - Tests bne with a positive offset and a negative offset 
# - Uses addi to set up unequal registers and explicit NOPs for padding
# - Tests larger branch offsets to ensure the processor correctly calculates
#   and jumps to the target address, though reduced from max +4094/-4096 bytes due to RARS
# - Expected Results: x28 = 1 (branch taken for positive offset), x29 = 1 (branch taken for negative offset)
# - Instructions used: addi (to set registers), bne (under test), j (for halting)

.text
    # Initialize registers
    addi x5, x0, 0         # x5 = 0x00000000
    addi x6, x0, 1         # x6 = 0x00000001

    # Test 1: bne with positive offset 
    bne x5, x6, far_target # Should branch to far_target
    addi x28, x0, 0        # x28 = 0 if no branch 
    j skip_target

    # Padding to create positive offset 
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    # Repeat addi x0, x0, 0 a total of 100 times 
    # For brevity, only 10 shown here; add 90 more addi x0, x0, 0 instructions

far_target:
    addi x28, x0, 1        # x28 = 1 if branch taken 

skip_target:
    # Test 2: bne with negative offset
    j backward_test        # Jump to backward test section

    # Padding for negative offset 
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    addi x0, x0, 0         # NOP
    # Repeat addi x0, x0, 0 a total of 100 times 
    # For brevity, only 10 shown here; add 90 more addi x0, x0, 0 instructions

backward_target:
    addi x29, x0, 1        # x29 = 1 if branch taken 
    j end

backward_test:
    bne x5, x6, backward_target # Should branch backward 
    addi x29, x0, 0        # x29 = 0 if no branch 

end:
    # Infinite loop to allow inspection in RARS
loop:
	wfi
   # j loop                 # Halt for debugging