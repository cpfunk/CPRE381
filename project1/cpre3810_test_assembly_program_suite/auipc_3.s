
.text
.globl main
main:
    # --- Test 1: Compose a full address ---
    # AUIPC loads high part relative to PC, then ADDI adds low bits.
    # Example: x10 = PC(auipc) + (0x123 << 12) + 0x7FF
test1:
    auipc x10, 0x123      # upper part
    addi  x10, x10, 0x7FF # add low part

    # --- Test 2: Compare with absolute LUI constant ---
    # LUI builds similar upper bits but without PC offset.
    lui x11, 0x123
    addi x11, x11, 0x7FF  # x11 = (0x123 << 12) + 0x7FF

    # --- Test 3: Subtract to check relative correctness ---
    # x12 = x10 - x11 = PC(test1)
    sub  x12, x10, x11

# End program
end:
wfi
   # j end
