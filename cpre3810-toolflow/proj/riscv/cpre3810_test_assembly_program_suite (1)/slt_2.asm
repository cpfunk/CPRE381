.data

.text
.globl main


# slt test 2 Zero and Equal tests.
# This test checks to see if identical inputs return 0 it also checks 
# comparisons with zero
main:

    # Load values
    addi x1, x0, 1
    addi x2, x0, -1
    
    # Test 1
    slt x3, x1, x1  # 1 < 1 Expected x3 = 0
    slt x4, x0, x0  # 0 < 0 Expected x4 = 0
    slt x5, x2, x2  # -1 < -1 Expected x5 = 0
    
    # Test 2
    slt x6, x2, x0 # -1 < 0 Expected x6 = 1
    slt x7, x1, x0 # 1 < 0 Expected x7 = 0
    
    slt  x8, x0, x1 # 0 < 1 Expected x8 = 1
    slt x9, x0, x2 # 0 < -1 Expected x9 = 0
 
  end:

wfi