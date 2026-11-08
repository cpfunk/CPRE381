.data

.text
.globl main


# slt test 1 basic positive negative and comparisons tests.
# Checks if the ALU correctly evaluates less than logic corretly.
# Test 1: positive vs positive,
# Test 2: negative vs negative 
# Test 3: positive vs negative
main:

    # Load values
    addi x1, x0, 50
    addi x2, x0, 100
    addi x3, x0, -50
    addi x4, x0 , -100
    
    # Test 1
    slt x5, x1, x2  # 50 < 100 Expected x5 = 1
    slt x6, x2, x1  # 100 < 50 Expected x6 = 0
    # Test 2
    slt x7, x4, x3 # -100 < -50 Expected x7 = 1
    slt x8, x3, x4 # -50 < -100 Expected x8 = 0
    # Test 3
    slt x9, x1, x3 # 50 < -50 Expected x9 = 0
    slt x10, x3, x1 # -50 < 50 Expected x10 = 1
 
  end:

wfi