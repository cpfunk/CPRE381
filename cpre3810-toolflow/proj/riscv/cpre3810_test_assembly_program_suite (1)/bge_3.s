.data
.text
.globl main
main:
    #count down from 3, loop stops when x5 turns to -1
    addi x5, x0, 3
    addi x6, x0, 0
back:
    addi x6, x6, 1
    addi x5, x5, -1
    bge x5, x0, back

    #4 >= 0, goes past x10 = 0, normal greater equal than behavior
    addi x10, x0, 1
    bge x6, x0, forth
    addi x10, x0, 0
forth:
    #-1 >= 0, sets x11 to 1, tests negative number i guess
    addi x11, x0, 0
    bge x5, x0, end
    addi x11, x0, 1
end:
    #end, bye bye now
    addi x0, x0, 0

wfi