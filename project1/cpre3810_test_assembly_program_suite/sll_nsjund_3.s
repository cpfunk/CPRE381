.text

#Shifting more than 31
#I'm not sure if this behavior is supposed to be defined. If it isn't then it shouldn't be included in the test suite
lui t0, 0xABCDF
addi t0, t0, 0xffffff11 #Load ABCDEF11 into t0
addi t1, zero, 33
sll t0, t0, t1 #should act like a shift by 1


wfi