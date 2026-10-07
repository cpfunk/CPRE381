.data
.text
.globl main
main:
    # Test 2: testing for overflow and cutoff of extra bits 

    lui x1, 0x40000 # x1 = 0x40000000
                    # places a 1 near top of 32 bits

    slli x2, x1, 1 # 0x40000000 << 1 = 0x80000000
                   # shifts into sign bit slot, expected x2 = 0x80000000

    slli x3, x1, 2 # 0x40000000 << 2 causes bit to shift out of range
                   # expected x3 = 0x00000000

    lui x4, 0xFFFFF # x4 = 0xFFFFF000
                    # upper 20 bits are all set to 1 for next set of tests. 

    slli x5, x4, 1 # left shift x4 by 1
                   # expected x5 = 0xFFFFE000 for one bit less

    slli x6, x4, 4 # larger left shift on x4
                   # checks that multiple bits are discarded correctly (one hex digit)
                   # expected x6 = 0xFFFF0000

wfi