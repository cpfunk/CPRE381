.data
.text
.globl main
main:
# This test is for checking the LSB dropped. I have made the offset address with the offset an odd number
# The odd number makes it so that the address isn't a multiple of 4 and therefore it is is
# an instruction unalignment  The test should add 3 to x11 to show that it is functioning properly

auipc x1, 0 # Putting the current address into the PC
addi  x2, x1, 21 # Adding to the PC
jalr  x3, 0(x2) # Performing the jump and link using the address in x2, the offset is 4
# target = (base address + 21) & ~1 = base address + 20
addi  x11, x0, 11 # Skipped
addi x11, x0, 22 # Skipped
addi x11, x0, 3 # Makes x11 = 3

end:

wfi