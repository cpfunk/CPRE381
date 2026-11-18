# backtracking_problem.s

lui x1, 0x10010
addi x4, x0, 5
addi x5, x0, 10
nop
sw x0, 0(x1)         # Zero-init backtracking memory
sw x0, 4(x1)
lw x2, 0(x1)
sw x0, 8(x1)
addi x8, x0, 20
addi x9, x0, 30
lw x6, 4(x1)
add x3, x2, x2
nop
nop
sub x7, x6, x4
nop
nop
add x10, x4, x5
bne x3, x7, backtrack
nop
nop
sw x5, 8(x1)
wfi

backtrack:
sw x0, 0(x1)
wfi
