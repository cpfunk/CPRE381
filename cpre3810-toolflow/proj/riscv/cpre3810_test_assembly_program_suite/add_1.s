.data

.text
.globl main

# add test 1 - basic stuff and the register file
# only addi used for setup since its above add on the list

main:

    # Start Test

    addi x1, x0, 5      # x1 = 5
    addi x2, x0, 7      # x2 = 7
    addi x3, x0, -3     # x3 = -3

    add x4, x0, x0      # 0 + 0, should be 0. simplest possible add
    add x5, x0, x1      # 0 + 5, should be 5. x0 on rs1 has to read as 0
    add x6, x1, x0      # 5 + 0, should be 5. same thing for rs2
    add x7, x1, x2      # 5 + 7, should be 12 (0xc). normal case
    add x8, x2, x1      # 7 + 5, should be 12. swapped, both ports work either way
    add x9, x2, x3      # 7 + -3, should be 4. negative operand, result positive
    add x10, x3, x3     # -3 + -3, should be -6 (0xfffffffa). both negative
    add x11, x2, x2     # 7 + 7, should be 14 (0xe). same reg on both ports

    addi x12, x0, 1     # x12 = 1
    add x12, x12, x1    # 1 + 5, should be 6. dest is also a source
    add x12, x12, x1    # 6 + 5, should be 11 (0xb). again, makes sure write doesnt mess up the read
    add x12, x12, x12   # 11 + 11, should be 22 (0x16). dest same as both sources

    add x0, x1, x2      # 5 + 7 into x0, x0 should stay 0
    add x13, x0, x2     # 0 + 7, should be 7. if x0 got written this would be 19

    addi x30, x0, 100   # x30 = 100
    addi x31, x0, 23    # x31 = 23
    add x29, x30, x31   # 100 + 23, should be 123 (0x7b). high register numbers
    add x31, x31, x30   # 23 + 100, should be 123. x31 as dest and source

    add x14, x7, x11    # 12 + 14, should be 26 (0x1a). chain of results
    add x15, x14, x12   # 26 + 22, should be 48 (0x30)
    add x16, x15, x9    # 48 + 4, should be 52 (0x34). if any earlier add was wrong this is wrong too

  end:

wfi