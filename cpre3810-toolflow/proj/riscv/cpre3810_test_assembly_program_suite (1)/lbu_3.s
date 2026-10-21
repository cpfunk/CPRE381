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
addi x7, x0, 0 #clear x7

lbu x5, 8(x10) #EXPECT RESULT: x5 gets value 0x000000FF, because first byte was loaded and zero-padded as unsigned, from little-endian reading,
lbu x6, 20(x10) #EXPECT RESULT: x6 gets value 0x000000FE, because first byte ""   "", and first byte of -1 is 0xFE
lbu x7, 21(x10) #EXPECT RESULT: x6 gets value 0x000000FF, because second byte ""   "", and second byte of -1 is 0xFF

#EXPLANATION: This test was included as to emphasize the unsigned part of lbu. It ensures that values that would be sign extended in lb
## are instead zero-padded here. It tests multiple situations that may be encounted in a real program, such as words defined explicitly
## or translated from integers in assembling. This is a common-case test.




end:  #In order to halt, this is from the template.

wfi