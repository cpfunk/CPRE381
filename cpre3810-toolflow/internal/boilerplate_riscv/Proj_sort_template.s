# Sorting Algorithm Template in RISC-V Assembly - Tyler Bibus
# This template provides a basic structure for implementing a sorting algorithm (i.e. mergesort) in RISC-V assembly language.

# Note: You MUST put the sorted array back in the SAME memory location as the original array.
#       During grading we will insert our own array and corresponding array_size for testing.
#       The max size will be 512 elements.
.data
    array_size: .word 12
    array: .word 65, 12, 10, 89, 11, 70, 67, 5, 9, 45, 90, 7
    # TODO: You may add additional temporary data here
.text
.globl main

main:
    # Save return address
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Call sorting function
    la a0, array
    lw a1, array_size
    jal ra, sort

    # restore stack
    lw ra, 0(sp)
    addi sp, sp, 4
    
    # Exit program
    wfi

# void sort(int* array, int size);
.globl sort
sort:
# TODO: Implement your sorting algorithm here.
