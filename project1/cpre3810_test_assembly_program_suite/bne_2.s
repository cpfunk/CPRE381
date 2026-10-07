# File: bne_veda_2.s
# Stress test for bne instruction 
# Test Case 2: Edge-case register values 
# - Tests bne with max positive (0x7FFFFFFF) vs min negative (0x80000000) and max positive vs itself
# - Uses lui and addi to set up large values
# - Tests bne with extreme 32-bit values to ensure comparison logic handles
#   the full range of register values correctly without overflow or misinterpretation.
# - Expected Results: x28 = 1 (branch for unequal registers), x29 = 1 (no branch for equal registers)
# - Instructions used: lui, addi (to set registers), bne (under test), j (for halting)

.text
    # Initialize registers
    lui  x5, 0x7FFFF       # Load upper 20 bits of 0x7FFFFFFF
    addi x5, x5, -1        # x5 = 0x7FFFFFFF (max positive)
    lui  x6, 0x80000       # x6 = 0x80000000 (min negative)
    lui  x7, 0x7FFFF       # Load upper 20 bits for x7
    addi x7, x7, -1        # x7 = 0x7FFFFFFF (same as x5)

    # Test 1: bne with max positive vs min negative 
    bne x5, x6, not_equal1 # Should branch to not_equal1
    addi x28, x0, 0        # x28 = 0 if no branch 
    j end1

not_equal1:
    addi x28, x0, 1        # x28 = 1 if branch taken 

end1:
    # Test 2: bne with max positive vs itself 
    bne x5, x7, not_equal2 # Should not branch
    addi x29, x0, 1        # x29 = 1 if no branch 
    j end2

not_equal2:
    addi x29, x0, 0        # x29 = 0 if branch taken 

end2:
    # Infinite loop to allow inspection in RARS
loop:
	wfi
   # j loop                 # Halt for debugging