.data
.text
.globl main

#--------------------------------------
# This is a test of the jal instruction,
# consisting of several forward and
# backward jump instructions
# (to check to see if we can do both
# positive and negative offsets one
# after another).
#--------------------------------------

main:
    jal x1, location1
    jal x0, failure

location2:
    jal x5, location3
    jal x0, failure

location1:
    jal x4, location2
    jal x0, failure 

location4:
    jal x3, end
    jal x0, failure

location3:
    jal x2, location4
    jal x0, failure

failure:
    jal x0, failure

end:

wfi