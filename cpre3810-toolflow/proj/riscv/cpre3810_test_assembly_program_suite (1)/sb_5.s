addi t3, x0, 0xFFFFFFFF
lui x2, 0x10010
sb t3, 10(x2) #verify that ff is stored at 0x1001000A ( value in RARS: 0x10010008 = 0x00FF0000)
#This is a valuable test case for basic functionality of sb
wfi