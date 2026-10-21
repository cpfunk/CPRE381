.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, 0         # clear x1
    lui x1, 0x80000     # verify that one can clear registers and 0+0 works in the ALU   

    addi x2, x0, 0         # clear x2
    addi x2, x1, -1        # x2 = 0x7FFFFFFF (max int)

    slt x3, x1, x2         # test if min_int < max_int
    
  end:

wfi