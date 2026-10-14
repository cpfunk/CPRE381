# File: bne_veda_1.s
# Purpose: Stress test for bne instruction 
# Test Case 1: Common-case branching with equal and unequal registers
# - Tests bne with two registers that are equal (0x00000000 vs 0x00000000) and unequal (0x00000000 vs 0x00000001)
# - Uses addi to set up register values and a simple branch target
# - Verifies typical bne behavior where branching occurs only when registers are not equal.
# - Ensures the processor correctly evaluates equality and updates the PC accordingly.
# - Expected Results: x28 = 1 (no branch for equal registers), x29 = 1 (branch for unequal registers)
# - Instructions used: addi (to set registers), bne (under test), j (for halting)

.text
    # Initialize registers
    addi x5, x0, 0         # x5 = 0x00000000
    addi x6, x0, 0         # x6 = 0x00000000
    addi x7, x0, 1         # x7 = 0x00000001

    # Test 1: bne with equal registers 
    bne x5, x6, not_equal1 # Should not branch, continue to next instruction
    addi x28, x0, 1        # x28 = 1 if no branch 
    j end1                 # Skip to end

not_equal1:
    addi x28, x0, 0        # x28 = 0 if branch taken 

end1:
    # Test 2: bne with unequal registers 
    bne x5, x7, not_equal2 # Should branch to not_equal2
    addi x29, x0, 0        # x29 = 0 if no branch 
    j end2

not_equal2:
    addi x29, x0, 1        # x29 = 1 if branch taken 

end2:
    # Infinite loop to allow inspection in RARS
loop:
    wfi
 #   j loop