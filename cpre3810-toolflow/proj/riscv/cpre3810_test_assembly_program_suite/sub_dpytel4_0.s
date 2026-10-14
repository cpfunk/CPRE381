.data

.text
.globl main
# checks negative overflow edge cases
main: 
lui t0, 0x80000 #initialize to 0x80000000
addi t1, x0, 1 #initialize to 1

sub t2, t1, t0 # verify whether sign flips appropriately
sub t3, t0, t1 # verify there is no overflow in system
sub t4, t1, t1 # verify anything minus itself should always be 0
sub t5, t0, t0 # should equal zero as well, testing very large number


end: 

wfi