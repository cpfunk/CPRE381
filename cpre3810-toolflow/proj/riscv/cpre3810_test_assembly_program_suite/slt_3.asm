.data

.text
.globl main


# slt test 3 Max vs Min test
# This test checks to see if This checks the two max and min integers that are able to held
# This tests that the overflow logic is correctly assigning the correct bits during comparisons.

main:

    # Load values
    lui x1, 0x80000      # Min int in x1
    
    lui x2, 0x80000
    addi x2, x2, -1     # Max int in x2
    
    slt x3, x2, x1 	# Max < Min Expected x3 = 0
    
    slt x4, x1, x2	# Min < Max Expected x4 = 1
 
  end:

wfi