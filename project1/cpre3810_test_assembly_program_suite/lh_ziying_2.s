# lh_ziying_2.s
# Test 2: Negative values

.data
vals:
.half 0x8000    # offset 0: most-negative halfword (-32768)
.half 0xFFFF	# offset 2: -1 in two's complement
.half 0x8001	# offset 4: one above most-negative (-32767)
.half 0xFF00	# offset 6: upper byte all-ones, lower byte zero (-256)
.half 0xAAAA	# offset 8: alternating bits 1010...1010 (negative)
.half 0xD555	# offset 10: alternating bits 1101...0101 (negative)

.text
.globl main

main:  

    # Build base address into x1 (lui + addi)
    lui x1, %hi(vals)
    addi x1, x1, %lo(vals)
    
    # Test A: Load 0x8000 (offset 0)
    # Justification: most-negative halfword
    # Sign extension ust replicate bit 15 into bits 31-16.
    # A single bit triggers a full upper-word fill.
    # Expected: x2 = 0xFFFF8000
    lh x2, 0(x1)
    
    # Test B: Load 0xFFFF (offset 2)
    # Justification: all bits of the halfword are 1 (represents -1).
    # After sign extension all 32 bits must be 1.
    # Easy to mis-handle if sign extension is off by one bit.
    # Expected: x3 = 0xFFFFFFFF
    lh x3, 2(x1)

    # Test C: Load 0x8001 (offset 4)
    # Justification: one above most-negative; confirms the low byte is
    # preserved while upper 16 are still sign-extended to 1.
    # Tests that sign extension doesn't corrupt the lower bits.
    # Expected: x4 = 0xFFFF8001
    lh x4, 4(x1)
    
    # Test D: Load 0xFF00 (offset 6)
    # Justification: lower byte is all zeros, upper byte all ones.
    # Confirms zero lower byte is not corrupted by sign extensions and that
    # bit 15 still correctly triggers the extension.
    # Expected: x5 = 0xFFFFFF00
    lh x5, 6(x1)
    
    # Test E: Load 0xAAAA (offset 8)
    # Justification: alternating bit pattern 1010...1010 (negative).
    # Direct complement of 0x5555 from Test 1. Together they ensure every
    # bit position is tested in both on/off states.
    # Expected: x6 = 0xFFFFAAAA
    lh x6, 8(x1)
    
    # Test F: Load 0xD555 (offset 10)
    # Justification: complement alternating pattern 1101...0101 (negative).
    # Paired with 0xAAAA, maximizes bit-level fault coverage for the nagtive
    # sign-extending halfword range.
    # Expected: x7 = 0xFFFFD555
    lh x7, 10(x1)
    
    

wfi