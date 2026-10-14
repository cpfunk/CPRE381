#after this sequence, the number should be -1 (0xFFFFFFFF)
#because -4096/(2^13) = -1
lui t0, 0xFFFFF

srai t1, t0, 1
srai t1, t0, 2
srai t1, t0, 3
srai t1, t0, 4
srai t1, t0, 5
srai t1, t0, 6
srai t1, t0, 7
srai t1, t0, 8
srai t1, t0, 9
srai t1, t0, 11
srai t1, t0, 12
srai t1, t0, 13


wfi