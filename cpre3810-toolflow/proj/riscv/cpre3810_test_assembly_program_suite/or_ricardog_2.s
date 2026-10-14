.data

.text
.global main

main:

#Initalizing
lui t1, 0xfffff
addi t2, t2, 0x7ff
addi t2, t2, 0x7f0
addi t2, t2, 0x10


# Testing 

# Start test

#Testing all bits can be bitwise OR. 
or t3, t1, t2	

end:

wfi