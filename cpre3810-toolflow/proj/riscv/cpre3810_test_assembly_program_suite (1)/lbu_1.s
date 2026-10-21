.data

word_array: .word 0x44332211 0x88776655 0xFFFFFFFF 255 256 -2

.text
.globl main

main:
#start test
lui x10 0x10010 #Load upper part of base data address to x10
addi x10, x10, 0x000 #load lower part of base data address
addi x5, x0, 0 #Clear x5
addi x6, x0, 0 #clear x6

lbu x5, 0(x10) #EXPECT RESULT: x5 gets value 0x00000011, because first byte was loaded and zero-padded, from little-endian reading
lbu x6, 4(x10) #EXPECT RESULT: x6 gets value 0x00000055, because first byte was loaded and zero-padded, from little-endian reading

#EXPLANATION: This test was included as a most basic test of lbu. It loads one byte from word-aligned addresses who have positive 2's 
## complement values. Two trials are done to help emphasize consistent results. This tests a common-case of lbu usage.




end:  #In order to halt, this is from the template.

wfi