.text
main:

li x1, 0x0472CE93 # non-sign extended value

# all these test cases test ALL shift values on a non-sign extended value. expects 31 to fully clear reg and 0 and 1 edge cases all to function as expected
addi t0, zero, 0
sra t1, x1, t0
addi t0, zero, 1
sra t1, x1, t0
addi t0, zero, 2
sra t1, x1, t0
addi t0, zero, 3
sra t1, x1, t0
addi t0, zero, 4
sra t1, x1, t0
addi t0, zero, 5
sra t1, x1, t0
addi t0, zero, 6
sra t1, x1, t0
addi t0, zero, 7
sra t1, x1, t0
addi t0, zero, 8
sra t1, x1, t0
addi t0, zero, 9
sra t1, x1, t0
addi t0, zero, 10
sra t1, x1, t0
addi t0, zero, 11
sra t1, x1, t0
addi t0, zero, 12
sra t1, x1, t0
addi t0, zero, 13
sra t1, x1, t0
addi t0, zero, 14
sra t1, x1, t0
addi t0, zero, 15
sra t1, x1, t0
addi t0, zero, 16
sra t1, x1, t0
addi t0, zero, 17
sra t1, x1, t0
addi t0, zero, 18
sra t1, x1, t0
addi t0, zero, 19
sra t1, x1, t0
addi t0, zero, 20
sra t1, x1, t0
addi t0, zero, 21
sra t1, x1, t0
addi t0, zero, 22
sra t1, x1, t0
addi t0, zero, 23
sra t1, x1, t0
addi t0, zero, 24
sra t1, x1, t0
addi t0, zero, 25
sra t1, x1, t0
addi t0, zero, 26
sra t1, x1, t0
addi t0, zero, 27
sra t1, x1, t0
addi t0, zero, 28
sra t1, x1, t0
addi t0, zero, 29
sra t1, x1, t0
addi t0, zero, 30
sra t1, x1, t0
addi t0, zero, 31
sra t1, x1, t0
# additional tests for out of range immedates
addi t0, zero, 32 # effectively a shift 0
sra t1, x1, t0
addi t0, zero, 33 # effectively a shift 1
sra t1, x1, t0
addi t0, zero, -1 # effectively a shift 31
sra t1, x1, t0





li x1, 0xF9CAE217 # sign-extended value

# all these test cases test ALL shift values on a non-sign extended value. expects 31 to fully clear reg and 0 and 1 edge cases all to function as expected
addi t0, zero, 0
sra t1, x1, t0
addi t0, zero, 1
sra t1, x1, t0
addi t0, zero, 2
sra t1, x1, t0
addi t0, zero, 3
sra t1, x1, t0
addi t0, zero, 4
sra t1, x1, t0
addi t0, zero, 5
sra t1, x1, t0
addi t0, zero, 6
sra t1, x1, t0
addi t0, zero, 7
sra t1, x1, t0
addi t0, zero, 8
sra t1, x1, t0
addi t0, zero, 9
sra t1, x1, t0
addi t0, zero, 10
sra t1, x1, t0
addi t0, zero, 11
sra t1, x1, t0
addi t0, zero, 12
sra t1, x1, t0
addi t0, zero, 13
sra t1, x1, t0
addi t0, zero, 14
sra t1, x1, t0
addi t0, zero, 15
sra t1, x1, t0
addi t0, zero, 16
sra t1, x1, t0
addi t0, zero, 17
sra t1, x1, t0
addi t0, zero, 18
sra t1, x1, t0
addi t0, zero, 19
sra t1, x1, t0
addi t0, zero, 20
sra t1, x1, t0
addi t0, zero, 21
sra t1, x1, t0
addi t0, zero, 22
sra t1, x1, t0
addi t0, zero, 23
sra t1, x1, t0
addi t0, zero, 24
sra t1, x1, t0
addi t0, zero, 25
sra t1, x1, t0
addi t0, zero, 26
sra t1, x1, t0
addi t0, zero, 27
sra t1, x1, t0
addi t0, zero, 28
sra t1, x1, t0
addi t0, zero, 29
sra t1, x1, t0
addi t0, zero, 30
sra t1, x1, t0
addi t0, zero, 31
sra t1, x1, t0
# additional tests for out of range immedates
addi t0, zero, 32 # effectively a shift 0
sra t1, x1, t0
addi t0, zero, 33 # effectively a shift 1
sra t1, x1, t0
addi t0, zero, -1 # effectively a shift 31
sra t1, x1, t0


end:

wfi