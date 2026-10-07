#some common cases and =/- numbers

#pos + pos = pos
addi x1, x0, 17
addi x2, x0, 936
add x3, x1, x2

#neg + pos = pos
addi x4, x0, -5
addi x5, x0, 37
add x6, x4, x5

#pos+neg = pos
addi x7, x0, 194
addi x8, x0, -26
add x9, x7, x8

#neg + pos = neg
addi x7, x0, -278
addi x8, x0, 59
add x9, x7, x8 

#pose + neg = neg
addi x7, x0, 284
addi x8, x0, -962
add x9, x7, x8


#neg+neg = neg
addi x10, x0, -26
addi x11, x0, -92
add x12, x11, x10

#negative overflow
lui x12, 0x80000
lui x13, 0x80000
add x14, x13, x12

#positive overflow
lui x15, 0x80000
lui x16, 0x80000
addi x15, x15, -1
addi x16, x16, -1
add x17, x15, x16

wfi