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

lbu x5, 1(x10) #EXPECT RESULT: x5 gets value 0x00000022, because second byte was loaded and zero-padded, from little-endian reading
lbu x6, 3(x10) #EXPECT RESULT: x6 gets value 0x00000044, because fourth byte was loaded and zero-padded, from little-endian reading
lbu x7, 6(x10) #EXPECT RESULT: x6 gets value 0x00000077, because thrid byte was of second word was loaded and zero-padded, from little-endian reading

#EXPLANATION: This test was included as a complex but critical test of lbu. It loads one byte from any (technically byte-aligned) address who 
## has positive 2's complement values. Three trials are done to stress this usage. This is another common-case usage of lbu.
## Per the ISA (ch. 2.6) all alignments that are not misaligned must function correctly. Since the natural size of lbu is one byte, any byte offset from
## an address will never be misaligned.




end:  #In order to halt, this is from the template.

wfi