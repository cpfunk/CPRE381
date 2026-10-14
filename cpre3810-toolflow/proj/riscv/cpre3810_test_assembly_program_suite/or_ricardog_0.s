.data

.text
.global main

main:

#Initalizing registers for test
addi x5, x5, 8		# Give register some value
addi x6, x0, 0		# Clearing register
addi x7, x6, 9		# Set another register for test	
 

# Testing 

#Start test
# Test verifies a value bitwise with zero returns the value. 
or x6, x5, x0		#Expect result x6 = x5	

#Second test
#Test verifies that OR will not overwrite register zero.
or x0, x5, x0		# Expected result x0 = 0


addi x6, x0, 0		#Clear x6 for next case in this test

#Third test
# Test further shows OR instruction working correctly. First test in this file could have instead worked if or was behaving like add.
# For this case, values inside x5, x6 are 8 and 9. Bitwise Or gives 9, showing expected result.
or x6, x5, x7		



end:

wfi