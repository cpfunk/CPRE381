# lh_ziying_3.s
# Test 3: Offset Arithmetic, Alignment & Register Coverage Test

.data
vals:
.half 0x0011    # offset 0: small positive value
.half 0xFFFF	# offset 2: all 1s neighbor - tests lh doesn't over-read into this
.half 0x0033	# offset 4
.half 0x0044	# offset 6
.half 0x0055	# offset 8
.half 0x0066	# offset 10
.half 0x8AAA	# offset 12: negative - tests offset + sign-ext together

.text
.globl main

main:

    # Build base address into x1 (lui + addi)
    lui x1, %hi(vals)
    addi x1, x1, %lo(vals)
    
    # Test A: offset = 0, neighbor halfword is 0xFFFF
    # Justification: the halfword at offset 0 is 0x0011, but its immediate
    # neighbor at offset 2 is 0xFFFF. If lh accidentally reads 4 bytes instead
    # of 2 (word-width bug), the result would be corrupted by the 0xFFFF neighbor.
    # Expected: x2 = 0x00000011 (NOT 0xFFFF0011)
    lh x2, 0(x1)
    
    # Test B: offset = 2 (the all 1s neighbor itself)
    # Justification: loads the 0xFFFF value directly to confirm sign
    # extended correctly when loading the neighbor halfword
    # Expected: x3 = 0xFFFFFFFF
    lh x3, 2(x1)

    # Test C: offset = 8 (skipping several halfwords)
    # Justification: tests a larger positive positive offset; ensures multi-byte strides
    # are computed correctly by the address adder.
    # Expected: x4 = 0x00000055
    lh x4, 8(x1)
    
    # Test D: negative immediate offset
    # Advance x1 by 12 so a -12 offset reaches back to the start.
    # Justification:  negative offsets are legal in lh (imm12 is signed).
    # Checks that the sign-extended immediate is correctly added to rs1.
    # Expected: x5 = 0x00000011 (same as Test A)
    addi x1, x1, 12
    lh x5, -12(x1)
    
    # Test E: same address, three different destination registers
    # Justification: a register-file wiring bug may only affect specific rd encodings.
    # Loading the same address into x7, x10, x15 lets us compare and detect such bugs
    # Expected: x7 = x10 = x15 = 0x00000033 (offset 4 from vals)
    lh x7, -8(x1)
    lh x10, -8(x1)
    lh x15, -8(x1)
    
    # Test F: register overwrite
    # Justification: verifies a second lh to the same rd completely overwrites the previous
    # value with no partial-write or latch issue.
    # x2 held 0x0011 from Test A; it must now become 0x0066.
    # Expected: x2 = 0x00000066 (offset 10 from vals)
    lh x2, -2(x1)
    
    # Test G: non-trivial offset combined with sign extension
    # Justification: compound check - address computation must be correct AND
    # sign extended because bit 15 = 1.
    # Expected: x6 = 0xFFFF8AAA (offset 12 from vals = 0(x1) now)
    lh x6, 0(x1) 
    
    

wfi