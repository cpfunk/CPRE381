.data

.text
.globl main

main:

    # Start Test
    # Tests for underflow when subtracting 1 from 0x80000000
    
    addi x31, zero, 1
    
    lui x1, 0x80000
  sub x1, x1, x31
    lui x2, 0x80000
  sub x2, x2, x31
    lui x3, 0x80000
  sub x3, x3, x31
    lui x4, 0x80000
  sub x4, x4, x31
    lui x5, 0x80000
  sub x5, x5, x31
    lui x6, 0x80000
  sub x6, x6, x31
    lui x7, 0x80000
  sub x7, x7, x31
    lui x8, 0x80000
  sub x8, x8, x31
    lui x9, 0x80000
  sub x9, x9, x31
    lui x10, 0x80000
  sub x10, x10, x31
    lui x11, 0x80000
  sub x11, x11, x31
    lui x12, 0x80000
  sub x12, x12, x31
    lui x13, 0x80000
  sub x13, x13, x31
    lui x14, 0x80000
  sub x14, x14, x31
    lui x15, 0x80000
  sub x15, x15, x31
    lui x16, 0x80000
  sub x16, x16, x31
    lui x17, 0x80000
  sub x17, x17, x31
    lui x18, 0x80000
  sub x18, x18, x31
    lui x19, 0x80000
  sub x19, x19, x31
    lui x20, 0x80000
  sub x20, x20, x31
    lui x21, 0x80000
  sub x21, x21, x31
    lui x22, 0x80000
  sub x22, x22, x31
    lui x23, 0x80000
  sub x23, x23, x31
    lui x24, 0x80000
  sub x24, x24, x31
    lui x25, 0x80000
  sub x25, x25, x31
    lui x26, 0x80000
  sub x26, x26, x31
    lui x27, 0x80000
  sub x27, x27, x31
    lui x28, 0x80000
  sub x28, x28, x31
    lui x29, 0x80000
  sub x29, x29, x31
    lui x30, 0x80000
  sub x30, x30, x31
    addi x1, zero, 1
    lui x31, 0x80000
  sub x31, x31, x1


  end:

wfi