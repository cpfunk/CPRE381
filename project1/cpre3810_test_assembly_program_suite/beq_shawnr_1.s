#basic test to see if a branch is taken when two registers are equal 

addi x1, x0, 0 
beq x1, x0, target
addi x2, x0, 1 #if failed x2 will equal 1 -- because this should be skipped 

target: 
addi x3, x0, 1 #if successful, x3 should equal 1 


wfi