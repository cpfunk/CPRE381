# NET-ID: connerb7
# Stress testing "and"
# and_connerb7_1.s
# this file tests and involving x0

# Case 1: Try writing and to x0, with values that would normally be set to 1.

addi x5, x0, -1		# x5 = 0xFFFFFFFF
addi x6, x0, 0x678	# x6 = 0x00000678

and x0, x5, x6		# x0 should still = 0

# Case 2: Try x0 and x0

and x5, x0, x0		# expect x5 = 0, cleared

# Case 3: Try x0 and x6

and x6, x0, x6		# expect x6 = 0, cleared
wfi