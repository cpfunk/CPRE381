#Start Test Case
auipc x3, 10 #Test with a random immediate value
auipc x4, 20 #Test with a random immediate value
auipc x5, 30 #Test with a random immediate value
auipc x6, 40 #Test with a random immediate value
auipc x7, 0x0FFFF #Test with highest positive value to see add behavior
auipc x8, 0xFFFFF #Test with highest unsigned value to see the overflow behavior

#The point of this test is to make sure that the an upper immediate can properly add to the program counter to get a value
#There are also test to check how the overflow logic will work and the behavior of the values
wfi