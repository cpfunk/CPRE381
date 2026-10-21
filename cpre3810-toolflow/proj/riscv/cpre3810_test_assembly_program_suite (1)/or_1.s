.data
.text
.globl main
main:

#Aidan Griffith or test 1

#test 1 basic bitwise checks

#check that 0 or 0 equals 0 
#nessecary to use addi to load in values
addi t0, x0, 0
addi t1, x0, 0
or t2, t1, t0 #result should be 0

#checking for full mask all bits work
addi t0, x0, -1
addi t1, x0, 0
or t3, t1, t0 #should result in FFFFFFFF

#alternating pattern testing
lui t0, 0xAAAAA
addi t0, t0, -1366
lui t1, 0x55555
addi t1, t1, 1365
or t4, t0, t1

end:

wfi