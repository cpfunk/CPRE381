.data
.text
.globl main
main:
#Aidan Griffith or test 3 
#checks that mutiple ors work back to back
addi t0, x0, 0x55
addi t1, x0, 0xAA
addi t2, x0 0x100
or t3, t1, t0 #0x0FF
or t4, t3, t2 #0x1FF
or t1, t0, t4 #0x1FF

#checks most and least signifigant bits
lui s0, 0x80000
addi s1, x0, 1
or s2, s0, s1 # 0x80000001
end:

wfi