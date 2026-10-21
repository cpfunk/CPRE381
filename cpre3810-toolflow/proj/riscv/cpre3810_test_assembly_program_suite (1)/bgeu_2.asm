
.data
.text
.globl main
main:
#testing unsigned functionality
# Start
add s0, x0, x0#clear S1
addi t1, x0, -1#set t1 to 0xFF...FF, -1 if unsigned
bgeu t1, t1 test1#basic case, should jump when equal
addi s0, s0 1#failure
test1:
bgeu x0,t1 fail#t1 not <x0, should NOT jump here, would jump if bge
j test2
fail:
addi s0, s0, 2#failure
test2:
bgeu t1, x0, test3#t1>x0, should jump, would not if bge
addi s0, s0, 4#failure
test3:

end:

wfi