.data
.text
.globl main
main:
# Start Test


# The first tests should loop and test registers 2-25 for the not greater than or equal to case

addi x1, x0, 2		# Using x1 as a holder for ints to compare against
sub x2, x2, x2			# Clear x2
RegTwo:
addi x2, x2, 1			# Adding 1 to x2
bge x1, x2, RegTwo		# Loop back and add everytime 2 >= x2


addi x1, x1, 1			# Adding 1 to x1 giving 3
sub x3, x3, x3			# Clear x3
RegThree:
addi x3, x3, 1			# Add 1 to x3
bge x1, x3, RegThree		# Loop back and add everytime 3 >= x3


addi x1, x1, 1			# Adding 1 to x1 giving 4
sub x4, x4, x4			# Clear x4
RegFour:
addi x4, x4, 1			# Add 1 to x4
bge x1, x4, RegFour		# Loop back and add everytime 4 >= x4


addi x1, x1, 1			# Adding 1 to x1 giving 5
sub x5, x5, x5			# Clear x5
RegFive:
addi x5, x5, 1			# Add 1 to x5
bge x1, x5, RegFive		# Loop back and add everytime 5 >= x5


addi x1, x1, 1			# Adding 1 to x1 giving 6
sub x6, x6, x6			# Clear x6
RegSix:
addi x6, x6, 1			# Add 1 to x6
bge x1, x6, RegSix		# Loop back and add everytime 6 >= x6


addi x1, x1, 1			# Adding 1 to x1 giving 7
sub x7, x7, x7			# Clear x7
RegSeven:
addi x7, x7, 1			# Add 1 to x7
bge x1, x7, RegSeven		# Loop back and add everytime 7 >= x7


addi x1, x1, 1			# Adding 1 to x1 giving 8
sub x8, x8, x8			# Clear x8
RegEight:
addi x8, x8, 1			# Add 1 to x8
bge x1, x8, RegEight		# Loop back and add everytime 8 >= x8


addi x1, x1, 1			# Adding 1 to x1 giving 9
sub x9, x9, x9			# Clear x9
RegNine:
addi x9, x9, 1			# Add 1 to x9
bge x1, x9, RegNine		# Loop back and add everytime 9 >= x9


addi x1, x1, 1			# Adding 1 to x1 giving 10
sub x10, x10, x10		# Clear x10
RegTen:
addi x10, x10, 1		# Add 1 to x10
bge x1, x10, RegTen		# Loop back and add everytime 10 >= x10


addi x1, x1, 1			# Adding 1 to x1 giving 11
sub x11, x11, x11		# Clear x11
RegEleven:
addi x11, x11, 1		# Add 1 to x11
bge x1, x11, RegEleven		# Loop back and add everytime 11 >= x11


addi x1, x1, 1			# Adding 1 to x1 giving 12
sub x12, x12, x12		# Clear x12
RegTwelve:
addi x12, x12, 1		# Add 1 to x12
bge x1, x12, RegTwelve		# Loop back and add everytime 12 >= x12


addi x1, x1, 1			# Adding 1 to x1 giving 13
sub x13, x13, x13		# Clear x13
RegThirteen:
addi x13, x13, 1		# Add 1 to x13
bge x1, x13, RegThirteen	# Loop back and add everytime 13 >= x13


addi x1, x1, 1			# Adding 1 to x1 giving 14
sub x14, x14, x14		# Clear x14
RegFourteen:
addi x14, x14, 1		# Add 1 to x14
bge x1, x14, RegFourteen	# Loop back and add everytime 14 >= x14


addi x1, x1, 1			# Adding 1 to x1 giving 15
sub x15, x15, x15		# Clear x15
RegFifteen:
addi x15, x15, 1		# Add 1 to x15
bge x1, x15, RegFifteen	# Loop back and add everytime 15 >= x15


addi x1, x1, 1			# Adding 1 to x1 giving 16
sub x16, x16, x16		# Clear x16
RegSixteen:
addi x16, x16, 1		# Add 1 to x16
bge x1, x16, RegSixteen	# Loop back and add everytime 16 >= x16


addi x1, x1, 1			# Adding 1 to x1 giving 17
sub x17, x17, x17		# Clear x17
RegSeventeen:
addi x17, x17, 1		# Add 1 to x17
bge x1, x17, RegSeventeen	# Loop back and add everytime 17 >= x17


addi x1, x1, 1			# Adding 1 to x1 giving 18
sub x18, x18, x18		# Clear x18
RegEighteen:
addi x18, x18, 1		# Add 1 to x18
bge x1, x18, RegEighteen	# Loop back and add everytime 18 >= x18


addi x1, x1, 1			# Adding 1 to x1 giving 19
sub x19, x19, x19		# Clear x19
RegNineteen:
addi x19, x19, 1		# Add 1 to x19
bge x1, x19, RegNineteen	# Loop back and add everytime 19 >= x19


addi x1, x1, 1			# Adding 1 to x1 giving 20
sub x20, x20, x20		# Clear x20
RegTwenty:
addi x20, x20, 1		# Add 1 to x20
bge x1, x20, RegTwenty		# Loop back and add everytime 20 >= x20


addi x1, x1, 1			# Adding 1 to x1 giving 21
sub x21, x21, x21		# Clear x21
RegTwentyOne:
addi x21, x21, 1		# Add 1 to x21
bge x1, x21, RegTwentyOne	# Loop back and add everytime 21 >= x21


addi x1, x1, 1			# Adding 1 to x1 giving 22
sub x22, x22, x22		# Clear x22
RegTwentyTwo:
addi x22, x22, 1		# Add 1 to x22
bge x1, x22, RegTwentyTwo	# Loop back and add everytime 22 >= x22


addi x1, x1, 1			# Adding 1 to x1 giving 23
sub x23, x23, x23		# Clear x23
RegTwentyThree:
addi x23, x23, 1		# Add 1 to x23
bge x1, x23, RegTwentyThree	# Loop back and add everytime 23 >= x23


addi x1, x1, 1			# Adding 1 to x1 giving 24
sub x24, x24, x24		# Clear x24
RegTwentyFour:
addi x24, x24, 1		# Add 1 to x24
bge x1, x24, RegTwentyFour	# Loop back and add everytime 24 >= x24


addi x1, x1, 1			# Adding 1 to x1 giving 25
sub x25, x25, x25		# Clear x25
RegTwentyFive:
addi x25, x25, 1		# Add 1 to x25
bge x1, x25, RegTwentyFive	# Loop back and add everytime 25 >= x25


# Here we switch to specific case testing as the first 24 registers likely caught register based bugs


# Testing an always skip case (same register in both sides)
addi x26, x0, 1			# Loading x26 with 1
bge x0, x0, RegTwentySeven	# Should always skip to RegTwentySeven
addi x26, x26, 102		# Should never run but leaves a trace if it does


# Testing 0 >= 1 (Should not jump)
RegTwentySeven:
addi x27, x0, 1			# Loading x27 with 1
bge x0, x27, RegTwentyEight	# Should not jump to RegTwentyEight
addi x27, x27, 1055		# Should update x27


# Testing -1 >= -2 (Confirms that the bge implementation understands negatives >= rules)(Should jump)
RegTwentyEight:
addi x28, x0, -1		# Put -1 in x28
addi x29, x0, -2		# Put -2 in x29
bge x28, x29, RegThirty	# Should jump to RegThirty
addi x29, x29, 0x47		# Should never run but leaves a trace if it does


# Testing -1 >= 1 (Confirms that the bge implementation understands negatives >= positives rules)(Should not jump)
RegThirty:
addi x30, x0, -1		# Put -1 in x30
addi x31, x0, 1			# Put 1 in x31
bge x30, x31, end		# Should not jump to MiniFail
addi x31, x31, 531		# Should update x31

end:

wfi