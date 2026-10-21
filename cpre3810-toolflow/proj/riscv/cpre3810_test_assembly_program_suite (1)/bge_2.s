.data
.text
.globl main
main:

    #test 1: -2 >= -5 checks negative number comparison
    addi x5, x0, -2
    addi x6, x0, -5
    addi x10, x0, 1
    bge x5, x6, test1 
    addi x10, x0, 0
test1:

    #test 2: -5 >= -2 checks negative number comparison but this time its reversed!!
    addi x11, x0, 0
    bge x6, x5, test2 
    addi x11, x0, 1
test2:

    #test 3: -5 >= -5 checks negative equals
    addi x5, x0, -5
    addi x12, x0, 1
    bge x5, x6, test3 
    addi x12, x0, 0
test3:

    #test 4: -1 >= 1 checks that negative !> positive
    addi x5, x0, -1
    addi x6, x0, 1
    addi x13, x0, 0
    bge x5, x6, test4 
    addi x13, x0, 1
test4:

    #test 5: 1 >= -1 checks positive > negative
    addi x14, x0, 1
    bge x6, x5, test5 
    addi x14, x0, 0
test5:

    #test 6: 2147483647 >= -2147483648, branch
    # x5 = 0x80000000, x6 = 0x7fffffff
    #looks at twos compliment
    lui x5, 0x80000
    addi x6, x5, -1
    addi x15, x0, 1
    bge x6, x5, test6 
    addi x15, x0, 0
test6:

    #test 7: -2147483648 >= 2147483647 NO BRANCH branch
    #TWO COMPLIMENT but reversed!!!!
    addi x16, x0, 0
    bge x5, x6, test7 
    addi x16, x0, 1
test7:

    #test 8:signed value vs itself, branch
    addi x17, x0, 1
    bge x5, x5, test8 
    addi x17, x0, 0
test8:

    #the end
    addi x0, x0, 0

wfi