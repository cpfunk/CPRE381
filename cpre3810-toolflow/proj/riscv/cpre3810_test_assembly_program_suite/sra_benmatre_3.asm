.text
main:



# test all rs2 (excpet x1, as it's been tested previously)

# load inital values
li x2, 1
li x3, 2
li x4, 3
li x5, 4
li x6, 5
li x7, 6
li x8, 7
li x9, 8
li x10, 9
li x11, 10
li x12, 11
li x13, 12
li x14, 13
li x15, 14
li x16, 15
li x17, 16
# shift 17 already tested extensively in test 2
li x18, 18
li x19, 19
li x20, 20
li x21, 21
li x22, 22
li x23, 23
li x24, 24
li x25, 25
li x26, 26
li x27, 27
li x28, 28
li x29, 29
li x30, 30
li x31, 31


# perform shifts
addi x1, zero, 17 # only testing shift 17, test file 1 covers all shift values

# zero shift is important too
sra x1, x1, x0

# all other shifts
sra x2, x1, x2
sra x3, x1, x3
sra x4, x1, x4
sra x5, x1, x5
sra x6, x1, x6
sra x7, x1, x7
sra x8, x1, x8
sra x9, x1, x9
sra x10, x1, x10
sra x11, x1, x11
sra x12, x1, x12
sra x13, x1, x13
sra x14, x1, x14
sra x15, x1, x15
sra x16, x1, x16
sra x17, x1, x17
sra x18, x1, x18
sra x19, x1, x19
sra x20, x1, x20
sra x21, x1, x21
sra x22, x1, x22
sra x23, x1, x23
sra x24, x1, x24
sra x25, x1, x25
sra x26, x1, x26
sra x27, x1, x27
sra x28, x1, x28
sra x29, x1, x29
sra x30, x1, x30
sra x31, x1, x31




end:

wfi