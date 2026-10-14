.text
main:



# test rs1 source and rd from all regs (except x1, as it was tested as rs1 from past inst)

# initialize values
li x2, 0x12345678
li x3, 0x12345678
li x4, 0x12345678
li x5, 0x12345678
li x6, 0x12345678
li x7, 0x12345678
li x8, 0x12345678
li x9, 0x12345678
li x10, 0x12345678
li x11, 0x12345678
li x12, 0x12345678
li x13, 0x12345678
li x14, 0x12345678
li x15, 0x12345678
li x16, 0x12345678
li x17, 0x12345678
li x18, 0x12345678
li x19, 0x12345678
li x20, 0x12345678
li x21, 0x12345678
li x22, 0x12345678
li x23, 0x12345678
li x24, 0x12345678
li x25, 0x12345678
li x26, 0x12345678
li x27, 0x12345678
li x28, 0x12345678
li x29, 0x12345678
li x30, 0x12345678
li x31, 0x12345678

# perform shifts
addi x1, zero, 17 # only testing shift 17, test file 1 covers all shift values
sra x2, x2, x1
sra x3, x3, x1
sra x4, x4, x1
sra x5, x5, x1
sra x6, x6, x1
sra x7, x7, x1
sra x8, x8, x1
sra x9, x9, x1
sra x10, x10, x1
sra x11, x11, x1
sra x12, x12, x1
sra x13, x13, x1
sra x14, x14, x1
sra x15, x15, x1
sra x16, x16, x1
sra x17, x17, x1
sra x18, x18, x1
sra x19, x19, x1
sra x20, x20, x1
sra x21, x21, x1
sra x22, x22, x1
sra x23, x23, x1
sra x24, x24, x1
sra x25, x25, x1
sra x26, x26, x1
sra x27, x27, x1
sra x28, x28, x1
sra x29, x29, x1
sra x30, x30, x1
sra x31, x31, x1

end:

wfi