.text
    .globl main
main:

    #test 1 

    addi x1, x0, -1        # rg1 = -1

    addi x5, x0, 0         
    sra  x10, x1, x5       #  -1

    addi x5, x0, 1         
    sra  x11, x1, x5       # -1

    addi x5, x0, 31       
    sra  x12, x1, x5       # -1


 
    # test 2 


    lui  x2, 0x80000       # x2 = 0x80000000

    addi x5, x0, 1
    sra  x13, x2, x5       #0xC0000000 

    addi x5, x0, 31
    sra  x14, x2, x5       #0xFFFFFFFF 



    # test 3
  

    lui  x6, 0x80000
    addi x6, x6, -1        #x6 = 0x7FFFFFFF

    addi x5, x0, 1
    sra  x15, x6, x5       # 0x3FFFFFFF

    addi x5, x0, 31
    sra  x16, x6, x5       #0x00000000


   #test 4

    addi x7, x0, 0         # rs1 = 0

    addi x5, x0, 31
    sra  x17, x7, x5       #0


    addi x0, x0, 0   
wfi