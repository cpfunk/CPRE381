.data
.text
.globl main
main:

# rs1=1, imm=-1 => expected x2=1 (1 < 0xFFFFFFFF unsigned)
addi x1, x0, 1
sltiu x2, x1, -1

# rs1=0xFFFFFFFF, imm=-1 => expected x3=0 (equal)
addi x1, x0, -1
sltiu x3, x1, -1

# rs1=0, imm=-1 => expected x4=1 (0 < 0xFFFFFFFF)
sltiu x4, x0, -1

# rs1=0x7FFFFFFF, imm=-1 => expected x5=1
lui  x1, 0x80000
addi x1, x1, -1
sltiu x5, x1, -1

# rs1=0x80000000, imm=1 => expected x6=0
lui  x1, 0x80000
sltiu x6, x1, 1

end:

wfi