.data
.text
.globl main

#--------------------------------------
# This is a basic test of the jal instruction,
# consisting of several backward jump
# instructions (to check to see if we can
# do negative offsets).
#--------------------------------------

main:
    jal x1, location1
    jal x0, failure

location4:
    jal x5, end
    jal x0, failure

location3:
    jal x4, location4
    jal x0, failure 

location2:
    jal x3, location3
    jal x0, failure

location1:
    jal x2, location2
    jal x0, failure

failure:
    jal x0, failure

end:

wfi