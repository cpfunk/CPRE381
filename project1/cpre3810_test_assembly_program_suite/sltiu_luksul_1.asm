.data
.text
.globl main
main:

# rs1=0, imm=1 => expected x2=1 
addi x1, x0, 0
sltiu x2, x1, 1

# rs1=0, imm=0 => expected x3=0 
sltiu x3, x0, 0

# rs1=1, imm=1 => expected x4=0 
addi x1, x0, 1
sltiu x4, x1, 1

# rs1=1, imm=2 => expected x5=1 
sltiu x5, x1, 2

# rs1=5, imm=3 => expected x6=0 
addi x1, x0, 5
sltiu x6, x1, 3

# rd=x0 => x0 must stay 0 
sltiu x0, x1, 3

end:

wfi