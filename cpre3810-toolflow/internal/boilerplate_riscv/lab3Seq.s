#
# First part of the Lab 3 test program
#

# data section
.data

# code/instruction section
.text
addi  x1,  x0,  1    # Place 1  in $1
addi  x2,  x0,  2    # Place 2  in $2
addi  x3,  x0,  3    # Place 3  in $3
addi  x4,  x0,  4    # Place 4  in $4
addi  x5,  x0,  5    # Place 5  in $5
addi  x6,  x0,  6    # Place 6  in $6
addi  x7,  x0,  7    # Place 7  in $7
addi  x8,  x0,  8    # Place 8  in $8
addi  x9,  x0,  9    # Place 9  in $9
addi  x10, x0,  10   # Place 10 in $10

add   x11, x1,  x2   # x11 = x1  + x2
sub   x12, x11, x3   # x12 = x11 - x3
add   x13, x12, x4   # x13 = x12 + x4
sub   x14, x13, x5   # x14 = x13 - x5
add   x15, x14, x6   # x15 = x14 + x6
sub   x16, x15, x7   # x16 = x15 - x7
add   x17, x16, x8   # x17 = x16 + x8
sub   x18, x17, x9   # x18 = x17 - x9
add   x19, x18, x10  # x19 = x18 + x10
addi  x20, x0,  35   # Place 35 in x20
add   x21, x19, x20  # x21 = x19 + x20

wfi
