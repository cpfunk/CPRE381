# At the end, t0 should be 1, because 0x00100000/(2^20) = 1
lui t0, 0x00100      

srai t1, t0, 1     
srai t1, t0, 2
srai t1, t0, 3    
srai t1, t0, 4   
srai t1, t0, 5
srai t1, t0, 6  
srai t1, t0, 7
srai t1, t0, 8    
srai t1, t0, 9   
srai t1, t0, 10 
srai t1, t0, 11    
srai t1, t0, 12
srai t1, t0, 13    
srai t1, t0, 14    
srai t1, t0, 15 
srai t1, t0, 16    
srai t1, t0, 17
srai t1, t0, 18    
srai t1, t0, 19    
srai t1, t0, 20 

wfi