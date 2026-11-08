
.data
.text
.globl main
main:
#testing basic functionality
# Start
add s0, x0, x0#clear S1
bgeu x0, x0 test1#basic case, should jump when equal
addi s0, s0 1#failure
test1:
addi t1, x0, 10#load 10 into t1
bgeu x0,t1 fail#t1 not <x0, should NOT jump here
j test2
fail:
addi s0, s0, 2#failure
test2:
bgeu t1, x0, test3#t1>x0, should jump
addi s0, s0, 4#failure
test3:

end:

wfi