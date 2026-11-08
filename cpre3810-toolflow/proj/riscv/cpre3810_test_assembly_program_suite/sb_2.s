#I want to load a value already into memory, and have sb change a specific part, and leave the rest of the memory bits untouched
lui t0, 0x11223
addi t0, t0, 0x344
#t0: 0x11223344

lui t1, 0x10010
sw t0, 0(t1)

#11223344 is stored into memory at address 0x10010000
lui t2, 0xAAAAA
addi t2, t2, 0x4AD

#t2: AAAAA4AD
sb t2, 1(t1)

#1122AD44 is the expected result in t3
lw t3, 0(t1)









wfi