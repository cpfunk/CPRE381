.data

.text
.globl main
#tests positive overflow edge case behavior 
main: 
lui t0, 0x80000
addi t0, t0, -1 #initialize to 0x7FFFFFFF
addi t1, x0, -1 #initialize to -1

sub t2, t1, t0 # should yield smallest number without overflow
sub t3, t0, x0 # ensure subtracting by 0 behaves correctly
sub t4, t0, t1 # should overflow into negatives
sub t5, x0, t1 # verifies double negative cancels properly

end: 

wfi