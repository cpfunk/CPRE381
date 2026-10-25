# Sorting Algorithm Template in RISC-V Assembly - Tyler Bibus
# This template provides a basic structure for implementing a sorting algorithm (i.e. mergesort) in RISC-V assembly language.

# Note: You MUST put the sorted array back in the SAME memory location as the original array.
#       During grading we will insert our own array and corresponding array_size for testing.
#       The max size will be 512 elements.
.data
    array_size: .word 12
    array: .word 65, 12, 10, 89, 11, 70, 67, 5, 9, 45, 90, 7
    .align 2
    temp_array: .space 2048
.text
.globl main

main:

    # print unsorted array to output for testing purposes
    la a0, array # array = array
    la t0, array_size # get get address for array_size
    lw a1, 0(t0) # size = array_size
    jal ra, print_array # this function doesn't modify a1 or a0

    # Call sorting function
    jal ra, sort

    la t0, array_size
    lw a1, 0(t0)
    # print sorted array to output for testing purposes
    jal ra, print_array # this function doesn't modify a1 or a0
    
    # Exit program
    wfi

    # just in case wfi falls through (for RARS)
    li a7, 10
    ecall

# TODO: Implement your sorting algorithm here.
# void sort(int* array, int size);
# a0 = base address of array
# a1 = size (number of elements)
# address of sorted array is stored back in a0
.globl sort
sort:
    li t0, 2
    blt a1, t0, sort_ret # if (size < 2) goto sort_ret;

    # Save caller's return address
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a1, 4(sp)
    
    # a0 = array
    addi a3, a1, -1 # size - 1
    la a1, temp_array
    li a2, 0
    jal ra, msort

    # restore caller's return address
    lw ra, 0(sp)
    lw a1, 4(sp)
    addi sp, sp, 8

    sort_ret: ret # return to caller

# void msort(int* array, int* temp_array, int left, int right)
# a0 = array
# a1 = temp_array
# a2 = left
# a3 = right
msort:

    bge  a2, a3, msort_done  # if left >= right, return
    
    add  t0, a2, a3         # t0 = left + right
    srli t0, t0, 1          # t0 = mid = (left + right) / 2

    addi sp, sp, -20
    sw   ra,  0(sp)     # save return
    sw   a2,  4(sp)     # save left
    sw   a3,  8(sp)     # save right
    sw   t0, 12(sp)     # save mid
    sw   a1, 16(sp)     # save temp_array

    # msort(array, temp_array, left, mid)
    #    a0,            # array = array 
    #    a1,            # temp_array = temp_array 
    #    a2,            # left = left 
    mv   a3, t0         # right = mid
    jal  ra, msort

    # msort(array, temp_array, mid + 1, right)
    #    a0,            # array = array 
    lw   a1, 16(sp)
    lw   t0, 12(sp)     # load mid
    addi a2, t0, 1      # left = mid + 1
    lw   a3,  8(sp)     # right = right
    jal  ra, msort


    # merge(array, temp_array, mid, right)
    #    a0,            # array = array 
    lw   a1, 16(sp)     # temp_array = temp_array
    lw   a2,  4(sp)     # left = left
    lw   a3, 12(sp)     # mid = mid
    lw   a4,  8(sp)     # right = right
    jal  merge
    
    lw   ra,  0(sp)     # restore return
    lw   a2,  4(sp)     # restore left = left
    lw   a4,  8(sp)     # restore right = right
    lw   a3, 12(sp)     # restore mid = mid
    lw   a1, 16(sp)     # restore temp_array
    addi sp, sp, 20

    msort_done:
    ret

# void merge(int* array, int* temp_array, int left, int mid, int right)
# a0 = array
# a1 = temp_array
# a2 = left
# a3 = mid
# a4 = right
merge:
    mv   t0, a2     # t0 = i = left
    addi t1, a3, 1  # t1 = j = mid + 1
    mv   t2, a2     # t2 = k = left

    merge_loop:
        blt a3, t0, merge_loop_end # if (mid < i 
        blt a4, t1, merge_loop_end # || right < j) goto merge_loop_end;

        # Load array[i] into t3
        slli t3, t0, 2
        add  t3, a0, t3
        lw   t3, 0(t3) # t3 = array[i]

        # Load array[j] into t4
        slli t4, t1, 2
        add  t4, a0, t4
        lw   t4, 0(t4) # t4 = array[j]

        # Compare array[i] and array[j]
        blt  t4, t3, take_right  # if array[j] < array[i], take right element
        take_left:
            slli t5, t2, 2
            add  t5, a1, t5
            sw   t3, 0(t5)           # temp_array[k] = array[i]

            addi t0, t0, 1           # i++
            addi t2, t2, 1           # k++
            j merge_loop
        take_right:
            slli t5, t2, 2
            add  t5, a1, t5
            sw   t4, 0(t5)           # temp_array[k] = array[j]

            addi t1, t1, 1           # j++
            addi t2, t2, 1           # k++
            j merge_loop
    merge_loop_end:

    copy_left:
        blt a3, t0, copy_left_end   # while i <= mid

        slli t3, t0, 2
        add  t3, a0, t3
        lw   t3, 0(t3)           # t3 = array[i]

        slli t4, t2, 2
        add  t4, a1, t4
        sw   t3, 0(t4)           # temp_array[k] = array[i]
        
        addi t0, t0, 1           # i++
        addi t2, t2, 1           # k++
        j copy_left
    copy_left_end:

    copy_right:
        blt a4, t1, copy_right_end   # while j <= right
        slli t3, t1, 2
        add  t3, a0, t3
        lw   t3, 0(t3)           # t3 = array[j]

        slli t4, t2, 2
        add  t4, a1, t4
        sw   t3, 0(t4)           # temp_array[k] = array[j]

        addi t1, t1, 1           # j++
        addi t2, t2, 1           # k++
        j copy_right
    copy_right_end:

    mv t0, a2 # i = left
    copy_back_loop:
        blt a4, t0, merge_ret   # while i <= right

        slli t4, t0, 2
        add  t5, a1, t4
        lw   t3, 0(t5)           # t3 = temp_array[i]

        add  t4, a0, t4
        sw   t3, 0(t4)           # array[i] = temp_array[i]

        addi t0, t0, 1           # i++
        j copy_back_loop

    merge_ret: ret

print_array:
    li t0, 0
    li t1, ','
    li t2, ' '
    li t3, '\n'

    addi sp, sp, -4
    sw a0, 0(sp)
    
    mv t4, a0 
    print_array_cond:
        bge t0, a1, print_array_end
        
        slli t5, t0, 2
        add t5, t4, t5

        lw t5, 0(t5)

        li a7, 1
        addi a0, t5, 0
        ecall

        li a7, 11
        addi a0, t1, 0
        ecall

        addi a0, t2, 0
        ecall

        addi t0, t0, 1

        j print_array_cond
    print_array_end:
    addi a0, t3, 0
    ecall

    lw a0, 0(sp)
    addi sp, sp, 4

    print_array_ret: ret