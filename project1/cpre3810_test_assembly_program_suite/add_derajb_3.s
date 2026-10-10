# Test 3: Verifies addition of large 32-bit values and overflow handling.
# Justification: Uses lui to load large constants into the upper bits to test 
# if the adder works correctly across all 32 bits and handles wrap-around.

lui  x1, 0x7FFFF     # Load large positive value into upper bits
addi x1, x1, 0x7FF   # x1 is now 0x7FFFF7FF (near max signed 32-bit int)
addi x2, x0, 2       # Load small increment
add  x3, x1, x2      # Test Case: Large positive + small positive. 

lui  x4, 0x80000     # Load most negative possible value (0x80000000)
addi x5, x0, -1      # Load -1
add  x6, x4, x5      # Test Case: Min negative + negative. 
 # Expected result: 0x7FFFFFFF (wrap-around behavior).
wfi