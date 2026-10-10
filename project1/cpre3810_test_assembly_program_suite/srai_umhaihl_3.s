# negative bit preservation (it should preserve the right most bit.)
# the output of this should be still -1

addi t0, zero, -1  
  
srai t1, t0, 30  
wfi