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
lui x5, 0x10010
addi x6, x0, 50
sw x6, 0(x5)
lw x7, 0(x5)
sw x7, 12(x5)
wfi
