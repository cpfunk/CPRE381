
.data
.text
.globl main
main:
#testing edge cases
# Start
add s0, x0, x0#clear S1
lui t0, 0x80000#extreme ends of signed
addi t1, t0, -1
bgeu t1, t1 test1#basic case, should jump when equal
addi s0, s0 1#failure
test1:
bgeu t1,t0 fail#t1 not <x0, should NOT jump here, would jump if bge
j test2
fail:
addi s0, s0, 2#failure
test2:
bgeu t0,t1 test3#t1>x0, should jump, would not if bge
addi s0, s0, 4#failure
test3:

end:

wfi