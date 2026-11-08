.data

.text
.globl main

# add test 2 - overflow and the signed limits
# add doesnt trap on overflow in rv32i, it just wraps. checking that
# lui and addi used for setup, both above add on the list

main:

    # Start Test

    lui x1, 0x80000     # x1 = 0x80000000, most negative
    addi x2, x1, -1     # x2 = 0x7fffffff, most positive
    addi x3, x0, 1      # x3 = 1
    addi x4, x0, -1     # x4 = -1 (0xffffffff)

    add x5, x2, x3      # max + 1, should wrap to 0x80000000. classic overflow
    add x6, x1, x4      # min + -1, should wrap to 0x7fffffff. overflow the other way
    add x7, x2, x2      # max + max, should be 0xfffffffe. biggest positive overflow
    add x8, x1, x1      # min + min, should be 0. carry out of bit 31 just gets dropped
    add x9, x2, x1      # max + min, should be -1 (0xffffffff). no overflow here
    add x10, x4, x3     # -1 + 1, should be 0. carry goes through all 32 bits
    add x11, x4, x4     # -1 + -1, should be -2 (0xfffffffe)
    add x12, x1, x3     # min + 1, should be 0x80000001. no overflow, must not wrap
    add x13, x2, x4     # max + -1, should be 0x7ffffffe. no overflow either

    addi x14, x0, 2     # x14 = 2
    add x15, x5, x14    # 0x80000000 + 2, should be 0x80000002. still running after the overflow above
    add x16, x15, x2    # 0x80000002 + 0x7fffffff, should be 1

    addi x17, x0, 1234  # x17 = 1234 (0x4d2)
    add x18, x17, x1    # 1234 + min, should be 0x800004d2
    add x18, x18, x1    # + min again, should be back to 1234 (0x4d2). added 2^32 total

  end:

wfi