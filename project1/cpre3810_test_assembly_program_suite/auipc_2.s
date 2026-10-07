
.text
.globl main
main:
    # --- Test 1: Large positive immediate (0x7FFFE) ---
    # This should add (0x7FFFE << 12) to PC.
test1:
    auipc x5, 0x7FFFE     # Large positive immediate test

    # --- Test 2: Large negative immediate (-1) ---
    # The immediate field is sign-extended, so imm = -1
    # adds (-1 << 12) = -4096 to PC.
test2:
    auipc x6, -1          # Large negative immediate test

    # --- Test 3: Sign boundary (0x80000) ---
    # Tests transition from positive to negative interpretation.
test3:
    auipc x7, 0x80000

# End program
end:
wfi
   # j end
