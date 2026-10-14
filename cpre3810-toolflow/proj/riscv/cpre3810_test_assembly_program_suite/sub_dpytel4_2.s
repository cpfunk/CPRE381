.data

.text
.globl main
#tests more common cases
main: 
#start test
addi t0, x0, 4
addi t1, x0, -4

sub t2, t0, t1 #verify standard subtraction, "double negative"
sub t3, t1, t0 #verify that a negative can be subtracted from appropriately
sub t1, t1, t3 #verify that a register can be both source and destination
sub t4, t1, t0 #yields 0

end: 

wfi