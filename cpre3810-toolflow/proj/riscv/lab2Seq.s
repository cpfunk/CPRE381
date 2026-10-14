.data
.word 0xFFFFFFFF
.word 0x00000002
.word 0xFFFFFFFD
.word 0x00000004
.word 0x00000005
.word 0x00000006
.word 0xFFFFFFF9
.word 0xFFFFFFF7
.word 0x00000009
.word 0xFFFFFFF6
.word 0x00000000
.word 0x00000000
.word 0x00000000
.word 0x00000000
.word 0x00000000
.word 0x0000a000
.word 0x0000b000

.text
lui x27, 0x10010
lui x25, 0x10010
addi x25,x25,0 # Load &A into x25, assuming x25 initially has 0x10010000 and a[0] is at 0x10010000 
lui x26, 0x10010
addi x26,x26,256 # Load &B into x26, assuming x26 initially has 0x10010000 and b[0] is at 0x10010100
lw x1, 0(x25) # Load A[0] into x1
lw x2, 4(x25) # Load A[1] into x2,
add x1, x1, x2 # x1 = x1 + x2
sw x1, 0(x26) # Store x1 value into B[0]
lw x2, 8(x25) # Load A[2] into x2
add x1, x1, x2 # x1 = x1 + x2
sw x1, 4(x26) # Store x1 value into B[1]
lw x2, 12(x25) # Load A[3] into x2
add x1, x1, x2 # x1 = x1 + x2
sw x1, 8(x26) # Store x1 value into B[2]
lw x2, 16(x25) # Load A[4] into x2
add x1, x1, x2 # x1 = x1 + x2
sw x1, 12(x26) # Store x1 value into B[3]
lw x2, 20(x25) # Load A[5] into x2
add x1, x1, x2 # x1 = x1 + x2
sw x1, 16(x26) # Store x1 value into B[4]
lw x2, 24(x25) # Load A[6] into x2
add x1, x1, x2 # x1 = x1 + x2
addi x27, x27, 512 # Load &B[64] into x27, assumuning x27 initially has 0x10010000 and b[0] is at 0x10010100
sw x1,-4(x27) # Store x1 into B[63]
sw x1,-4(x27) # Store x1 into B[63]
wfi
