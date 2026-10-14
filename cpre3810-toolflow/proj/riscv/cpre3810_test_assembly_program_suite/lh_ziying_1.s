# lh_ziying_1.s
# Test 1: Positive values / common case
# This checks normal functionality and correct zero/sign extension

.data
vals:
.half 0x0000    # offset 0: zero - boundary between positive and negative
.half 0x0001	# offset 2: smallest positive non-zero halfword
.half 0x1234	# offset 4: typical mixed-nibble positive value
.half 0x7FFF	# offset 6: maximum positive halfword (bit 15 = 0)
.half 0x5555	# offset 8: alternating bits 0101...0101 (positive)
.half 0x2AAA	# offset 10: alternating bits 0010...1010 (positive)

.text
.globl main

main:

    # Build base address into x1 (lui + addi)
    lui x1, %hi(vals)
    addi x1, x1, %lo(vals)
    
    # Test A: Load 0x0000 (offset 0)
    # Justification: zero is the boundary between positive and negative
    # 2's complement values. All 32 bits of the result must be zero
    # Expected: x2 = 0x00000000
    lh x2, 0(x1)
    
    # Test B: Load 0x0001 (offset 2)
    # Justification: smalles positive non-zero halfword; the single set
    # bit must be preserved and bits 31-16 must be zero (no sign extension)
    # Expected: x3 = 0x00000001
    lh x3, 2(x1)

    # Test C: Load 0x1234 (offset 4)
    # Justification: multi-nibble positive value; confirms all 12 lower
    # bits are loaded intact and upper bits remain clear
    # Expected: x4 = 0x00001234
    lh x4, 4(x1)
    
    # Test D: Load 0x7FFF (offset 6)
    # Justification: maximum representable positive halfword (bit 15 = 0,)
    # bits 14=0 all 1). Sign extension must NOT set upper bits - this is
    # the critical upper boundary for the sign-extension logic
    # Expected: x5 = 0x00007FFF
    lh x5, 6(x1)
    
    # Test E: Load 0x5555 (offset 8)
    # Justification: alternating bit pattern 0101...0101 (positive).
    # This catches bit-swap or bit-wiring bugs that simple values like 
    # 0x0001 or 0x7FFF would not expose
    # Expected:x6 = 0x00005555
    lh x6, 8(x1)
    
    # Test F: Load 0x2AAA (offset 10)
    # Justification: complement alternating pattern 0010...1010 (postive).
    # Paired with 0x5555, every bit position is tested in both states
    # across Test E and F, maximizing single-bit fault coverage
    # Expected: x7 = 0x00002AAA
    lh x7, 10(x1)
    
    

wfi