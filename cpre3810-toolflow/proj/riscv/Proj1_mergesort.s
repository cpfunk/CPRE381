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
    # rearr: placed lasw3 t0, array_size after la a0 so its 5 instructions hide a0 latency
    lasw3 a0, array # array = array
    lasw3 t0, array_size # get get address for array_size
    nop
    nop
    nop
    lw a1, 0(t0) # size = array_size
    nop
    nop
    nop
    jal ra, print_array # this function doesn't modify a1 or a0
    nop
    nop

    # Call sorting function
    jal ra, sort
    nop
    nop

    lasw3 t0, array_size
    nop
    nop
    nop
    lw a1, 0(t0)
    nop
    nop
    nop
    # print sorted array to output for testing purposes
    jal ra, print_array # this function doesn't modify a1 or a0
    nop
    nop
    
    # Exit program
    li a7, 10
    nop
    nop
    nop
    ecall
    wfi

# TODO: Implement your sorting algorithm here.
# void sort(int* array, int size);
# a0 = base address of array
# a1 = size (number of elements)
# address of sorted array is stored back in a0
.globl sort
sort:
    li t0, 2
    nop
    nop
    nop
    blt a1, t0, sort_ret # if (size < 2) goto sort_ret;
    nop
    nop

    # Save caller's return address
    addi sp, sp, -8
    # rearr: computed a3 (size - 1) and a2 (0) inside the sp hazard window to save 2 NOPs!
    addi a3, a1, -1 # size - 1
    li a2, 0
    nop
    sw ra, 0(sp)
    sw a1, 4(sp)
    
    # a0 = array
    lasw3 a1, temp_array
    nop
    nop
    nop
    jal ra, msort
    nop
    nop

    # restore caller's return address
    lw ra, 0(sp)
    lw a1, 4(sp)
    addi sp, sp, 8
    nop
    nop

    sort_ret: ret # return to caller
    nop
    nop

# void msort(int* array, int* temp_array, int left, int right)
# a0 = array
# a1 = temp_array
# a2 = left
# a3 = right
msort:

    bge  a2, a3, msort_done  # if left >= right, return
    nop
    nop
    
    # rearr: interleaved stack pointer allocation and frame stores with mid (t0) calculation to eliminate 5 NOPs!
    add  t0, a2, a3         # t0 = left + right
    addi sp, sp, -20
    nop
    nop
    srli t0, t0, 1          # t0 = mid = (left + right) / 2
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
    nop
    nop
    nop
    jal  ra, msort
    nop
    nop

    # msort(array, temp_array, mid + 1, right)
    #    a0,            # array = array 
    # rearr: loaded t0 first and placed lw a1 and lw a3 in its hazard window before addi a2, t0, 1
    lw   t0, 12(sp)     # load mid
    lw   a1, 16(sp)
    lw   a3,  8(sp)     # right = right
    nop
    addi a2, t0, 1      # left = mid + 1
    nop
    nop
    nop
    jal  ra, msort
    nop
    nop


    # merge(array, temp_array, mid, right)
    #    a0,            # array = array 
    lw   a1, 16(sp)     # temp_array = temp_array
    lw   a2,  4(sp)     # left = left
    lw   a3, 12(sp)     # mid = mid
    lw   a4,  8(sp)     # right = right
    nop
    nop
    nop
    jal  merge
    nop
    nop
    
    lw   ra,  0(sp)     # restore return
    lw   a2,  4(sp)     # restore left = left
    lw   a4,  8(sp)     # restore right = right
    lw   a3, 12(sp)     # restore mid = mid
    lw   a1, 16(sp)     # restore temp_array
    addi sp, sp, 20

    msort_done:
    ret
    nop
    nop

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
    nop
    nop

    merge_loop:
        blt a3, t0, merge_loop_end # if (mid < i 
        nop
        nop
        blt a4, t1, merge_loop_end # || right < j) goto merge_loop_end;
        nop
        nop

        # Load array[i] into t3
        # rearr: interleaved array[i] (t3) and array[j] (t4) shifts, adds, and loads to eliminate 4 NOPs per iteration!
        slli t3, t0, 2
        slli t4, t1, 2
        nop
        nop
        add  t3, a0, t3
        # Load array[j] into t4
        add  t4, a0, t4
        nop
        nop
        lw   t3, 0(t3) # t3 = array[i]
        lw   t4, 0(t4) # t4 = array[j]
        nop
        nop
        nop

        # Compare array[i] and array[j]
        blt  t4, t3, take_right  # if array[j] < array[i], take right element
        nop
        nop
        take_left:
            slli t5, t2, 2
            # rearr: placed i++ and k++ inside the slli t5 hazard window to save 2 NOPs!
            addi t0, t0, 1           # i++
            addi t2, t2, 1           # k++
            nop
            add  t5, a1, t5
            nop
            nop
            nop
            sw   t3, 0(t5)           # temp_array[k] = array[i]
            j merge_loop
            nop
            nop
        take_right:
            slli t5, t2, 2
            # rearr: placed j++ and k++ inside the slli t5 hazard window to save 2 NOPs!
            addi t1, t1, 1           # j++
            addi t2, t2, 1           # k++
            nop
            add  t5, a1, t5
            nop
            nop
            nop
            sw   t4, 0(t5)           # temp_array[k] = array[j]
            j merge_loop
            nop
            nop
    merge_loop_end:

    copy_left:
        blt a3, t0, copy_left_end   # while i <= mid
        nop
        nop

        # rearr: interleaved t3 and t4 address calculations and placed i++/k++ in the lw t3 hazard window!
        slli t3, t0, 2
        slli t4, t2, 2
        addi t0, t0, 1           # i++
        addi t2, t2, 1           # k++
        add  t3, a0, t3
        add  t4, a1, t4
        nop
        nop
        lw   t3, 0(t3)           # t3 = array[i]
        nop
        nop
        nop
        sw   t3, 0(t4)           # temp_array[k] = array[i]
        
        j copy_left
        nop
        nop
    copy_left_end:

    copy_right:
        blt a4, t1, copy_right_end   # while j <= right
        nop
        nop
        # rearr: interleaved t3 and t4 address calculations and placed j++/k++ in the slli hazard window!
        slli t3, t1, 2
        slli t4, t2, 2
        addi t1, t1, 1           # j++
        addi t2, t2, 1           # k++
        add  t3, a0, t3
        add  t4, a1, t4
        nop
        nop
        lw   t3, 0(t3)           # t3 = array[j]
        nop
        nop
        nop
        sw   t3, 0(t4)           # temp_array[k] = array[j]

        j copy_right
        nop
        nop
    copy_right_end:

    mv t0, a2 # i = left
    nop
    nop
    nop
    copy_back_loop:
        blt a4, t0, merge_ret   # while i <= right
        nop
        nop

        slli t4, t0, 2
        # rearr: placed i++ in slli t4 hazard window and grouped add t5 and add t4 together!
        addi t0, t0, 1           # i++
        nop
        nop
        add  t5, a1, t4
        add  t4, a0, t4
        nop
        nop
        lw   t3, 0(t5)           # t3 = temp_array[i]
        nop
        nop
        nop
        sw   t3, 0(t4)           # array[i] = temp_array[i]

        j copy_back_loop
        nop
        nop

    merge_ret: ret
    nop
    nop

print_array:
    # rearr: interleaved li t0, t1, t2, t3 with addi sp, sp, -4 to hide sp latency before sw a0, 0(sp)
    li t0, 0
    addi sp, sp, -4
    li t1, ','
    li t2, ' '
    li t3, '\n'
    sw a0, 0(sp)
    
    mv t4, a0 
    nop
    print_array_cond:
        bge t0, a1, print_array_end
        nop
        nop
        
        slli t5, t0, 2
        nop
        nop
        nop
        add t5, t4, t5
        nop
        nop
        nop

        lw t5, 0(t5)
        # rearr: placed li a7, 1 inside lw t5 hazard window
        li a7, 1
        nop
        nop
        addi a0, t5, 0
        nop
        nop
        nop
        ecall

        li a7, 11
        addi a0, t1, 0
        nop
        nop
        nop
        ecall

        addi a0, t2, 0
        # rearr: placed loop counter increment addi t0, t0, 1 inside a0 hazard window before ecall
        addi t0, t0, 1
        nop
        nop
        ecall

        j print_array_cond
        nop
        nop
    print_array_end:
    addi a0, t3, 0
    nop
    nop
    nop
    ecall

    lw a0, 0(sp)
    addi sp, sp, 4
    nop
    nop

    print_array_ret: ret
    nop
    nop