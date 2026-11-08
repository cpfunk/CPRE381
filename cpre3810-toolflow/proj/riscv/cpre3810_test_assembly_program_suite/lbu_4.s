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

addi x11, x10, 16 #Make x11 0x10010010, which is 16 offset from word_array start (value 256).

lbu x5, 0(x11) #EXPECT RESULT: x5 gets value 0x00000000, because first byte of 256 is 0x00,
lbu x6, -4(x11) #EXPECT RESULT: x6 gets value 0x000000FF, because first byte of 255 (0x000000FF) was loaded using negative immediate.

#EXPLANATION: This test was included as to double check that negative immediates are still sign extended in lbu, but the values retrieved are not
##Most implementations should not struggle with this, but it is good to test edge cases for an instruction like this. This is an
## edge-case test.




end:  #In order to halt, this is from the template.

wfi