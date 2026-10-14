.text

#Overflow
addi t1, zero, -1 # all f's in t1 so it can be shifted off
addi t0, zero, 5 # set t0 to 5
sll t1, t1, t0 #shift t1 left 5 to get 5 1's dropped off
sll t1, t1, t0 #shift t1 left 5 to get 5 1's dropped off
sll t1, t1, t0 #shift t1 left 5 to get 5 1's dropped off
sll t1, t1, t0 #shift t1 left 5 to get 5 1's dropped off
addi t0, t0, 9 #make t0 big enough sto shift more than evrything off
sll t1, t1, t0 #t1 should be cleared


wfi