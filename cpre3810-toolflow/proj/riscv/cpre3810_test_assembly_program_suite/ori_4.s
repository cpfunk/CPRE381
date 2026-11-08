.data

.text
.globl main
main:
#Start tests
addi t0, x0, 0xF0 #Loading value into t0
ori t1, t0, 0x0F #Test for non overlaps

addi t0, x0, 0x1F #Loaidng value into t0
ori t2, t0, 0x20 #Test with overlapping bit

ori t3, x0, 0x44 #Or with zero

ori t4, t3, 0 #Should stay same as t3 since it is ORed with 0
wfi