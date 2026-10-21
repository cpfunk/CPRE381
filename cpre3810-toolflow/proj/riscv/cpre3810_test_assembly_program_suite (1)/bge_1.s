.data
.text
.globl main
main:

    #test 1: 7 >= 3, greater than
    addi x5, x0, 7
    addi x6, x0, 3
    addi x10, x0, 1
    bge x5, x6, test1
    addi x10, x0, 0
test1:

    #test 2: 3 >= 7, less than
    addi x11, x0, 0
    bge x6, x5, test2 
    addi x11, x0, 1
test2:

    #test 3: 7 >= 7, checks > instead of >=
    addi x6, x0, 7
    addi x12, x0, 1
    bge x5, x6, test3 
    addi x12, x0, 0
test3:

    #test 4: 0 >= 0 checks equal zeroes
    addi x13, x0, 1
    bge x0, x0, test4 
    addi x13, x0, 0
test4:

    #test 5: 1 >= 0 checks x0 second operand
    addi x5, x0, 1
    addi x14, x0, 1
    bge x5, x0, test5 
    addi x14, x0, 0
test5:

    #test 6: 0 >= 1 checks x0 first operand
    addi x15, x0, 0
    bge x0, x5, test6 
    addi x15, x0, 1
test6:

    #the end
    addi x0, x0, 0

wfi