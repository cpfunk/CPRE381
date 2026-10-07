.data
.text
.globl main
main:

# sltiu rd, rs1, 1 sets rd=1 if and only if rs1==0 (only 0 is unsigned less than 1)
# rs1=0, imm=1 => expected x2=1
sltiu x2, x0, 1

# rs1=7, imm=1 => expected x3=0 (nonzero input)
addi x1, x0, 7
sltiu x3, x1, 1

# rd==rs1, rs1=3, imm=10 => expected x1=1 
addi x1, x0, 3
sltiu x1, x1, 10

# rd==rs1, rs1=15, imm=5 => expected x1=0
addi x1, x0, 15
sltiu x1, x1, 5

# imm=2047 (max positive 12-bit): rs1=2046 => expected x4=1
addi x1, x0, 2046
sltiu x4, x1, 2047

# imm=2047: rs1=2047 => expected x5=0 
addi x1, x0, 2047
sltiu x5, x1, 2047

# imm=-2048 (min 12-bit, extends to 0xFFFFF800): rs1=0 => expected x6=1
sltiu x6, x0, -2048

# imm=-2048: rs1=0xFFFFF800 => expected x7=0 
addi x1, x0, -2048
sltiu x7, x1, -2048

end:

wfi