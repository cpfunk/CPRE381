.data

.text
.globl main
main:
#Start tests
ori t0, x0, 0x7FF #Testing the largest positive immediate

lui t1, 0x54321
ori t1, t1, 0x234 #Testing with LUI to make sure upper 20 bits are preserved

lui t2, 0x7FFFF
ori t2, t2, 0x7FF #Almost the largest positive value

ori t2, t2, 0 #Making sure zero doesn't change anything
wfi