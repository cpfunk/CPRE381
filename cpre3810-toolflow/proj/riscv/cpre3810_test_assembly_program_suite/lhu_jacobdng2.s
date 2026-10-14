.data
test_array:
    .half 0xAAAA # Offset 0
    .half 0x5555 # Offset 2
    .half 0x1111 # Offset 4

.text
.globl main
main:

lui x1, 0x10010

# Test 1: Load with zero offset - base address access
lhu x2, 0(x1) # x2 = 0x0000AAAA

# Test 2: Load with offset +2 - next halfword access
lhu x3, 2(x1)  # x3 = 0x00005555

# Test 3: Load with computed address using add - dynamic addressing
addi x4, x0, 4 # x4 = 4 (offset)
add x5, x1, x4 # x5 = base + 4
lhu x6, 0(x5) # x6 = 0x00001111

end:

wfi