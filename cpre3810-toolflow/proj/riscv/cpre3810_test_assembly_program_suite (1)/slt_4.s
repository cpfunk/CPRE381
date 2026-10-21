.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, 0     # clear x1
    addi x1, x1, 1     # load 1 into x0 
    slt  x2, x0, x1    # verify that common case of 0 < 1  

  end:

wfi