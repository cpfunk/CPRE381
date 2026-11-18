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
    
    
    
    lw a1, 0(t0) # size = array_size
    
    
    
    jal ra, print_array # this function doesn't modify a1 or a0
    
    

    # Call sorting function
    jal ra, sort
    
    

    lasw3 t0, array_size
    
    
    
    lw a1, 0(t0)
    
    
    
    # print sorted array to output for testing purposes
    jal ra, print_array # this function doesn't modify a1 or a0
    
    
    
    # Exit program
    li a7, 10
    
    
    
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
    
    
    
    blt a1, t0, sort_ret # if (size < 2) goto sort_ret;
    
    

    # Save caller's return address
    addi sp, sp, -8
    # rearr: computed a3 (size - 1) and a2 (0) inside the sp hazard window to save 2 s!
    addi a3, a1, -1 # size - 1
    li a2, 0
    
    sw ra, 0(sp)
    sw a1, 4(sp)
    
    # a0 = array
    lasw3 a1, temp_array
    
    
    
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
    
    
    
    # rearr: interleaved stack pointer allocation and frame stores with mid (t0) calculation to eliminate 5 s!
    add  t0, a2, a3         # t0 = left + right
    addi sp, sp, -20
    
    
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
    
    
    
    jal  ra, msort
    
    

    # msort(array, temp_array, mid + 1, right)
    #    a0,            # array = array 
    # rearr: loaded t0 first and placed lw a1 and lw a3 in its hazard window before addi a2, t0, 1
    lw   t0, 12(sp)     # load mid
    lw   a1, 16(sp)
    lw   a3,  8(sp)     # right = right
    
    addi a2, t0, 1      # left = mid + 1
    
    
    
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
        # rearr: interleaved array[i] (t3) and array[j] (t4) shifts, adds, and loads to eliminate 4 s per iteration!
        slli t3, t0, 2
        slli t4, t1, 2
        
        
        add  t3, a0, t3
        # Load array[j] into t4
        add  t4, a0, t4
        
        
        lw   t3, 0(t3) # t3 = array[i]
        lw   t4, 0(t4) # t4 = array[j]
        
        
        

        # Compare array[i] and array[j]
        blt  t4, t3, take_right  # if array[j] < array[i], take right element
        
        
        take_left:
            slli t5, t2, 2
            # rearr: placed i++ and k++ inside the slli t5 hazard window to save 2 s!
            addi t0, t0, 1           # i++
            addi t2, t2, 1           # k++
            
            add  t5, a1, t5
            
            
            
            sw   t3, 0(t5)           # temp_array[k] = array[i]
            j merge_loop
            
            
        take_right:
            slli t5, t2, 2
            # rearr: placed j++ and k++ inside the slli t5 hazard window to save 2 s!
            addi t1, t1, 1           # j++
            addi t2, t2, 1           # k++
            
            add  t5, a1, t5
            
            
            
            sw   t4, 0(t5)           # temp_array[k] = array[j]
            j merge_loop
            
            
    merge_loop_end:

    copy_left:
        blt a3, t0, copy_left_end   # while i <= mid
        
        

        # rearr: interleaved t3 and t4 address calculations and placed i++/k++ in the lw t3 hazard window!
        slli t3, t0, 2
        slli t4, t2, 2
        addi t0, t0, 1           # i++
        addi t2, t2, 1           # k++
        add  t3, a0, t3
        add  t4, a1, t4
        
        
        lw   t3, 0(t3)           # t3 = array[i]
        
        
        
        sw   t3, 0(t4)           # temp_array[k] = array[i]
        
        j copy_left
        
        
    copy_left_end:

    copy_right:
        blt a4, t1, copy_right_end   # while j <= right
        
        
        # rearr: interleaved t3 and t4 address calculations and placed j++/k++ in the slli hazard window!
        slli t3, t1, 2
        slli t4, t2, 2
        addi t1, t1, 1           # j++
        addi t2, t2, 1           # k++
        add  t3, a0, t3
        add  t4, a1, t4
        
        
        lw   t3, 0(t3)           # t3 = array[j]
        
        
        
        sw   t3, 0(t4)           # temp_array[k] = array[j]

        j copy_right
        
        
    copy_right_end:

    mv t0, a2 # i = left
    
    
    
    copy_back_loop:
        blt a4, t0, merge_ret   # while i <= right
        
        

        slli t4, t0, 2
        # rearr: placed i++ in slli t4 hazard window and grouped add t5 and add t4 together!
        addi t0, t0, 1           # i++
        
        
        add  t5, a1, t4
        add  t4, a0, t4
        
        
        lw   t3, 0(t5)           # t3 = temp_array[i]
        
        
        
        sw   t3, 0(t4)           # array[i] = temp_array[i]

        j copy_back_loop
        
        

    merge_ret: ret
    
    

print_array:
    # rearr: interleaved li t0, t1, t2, t3 with addi sp, sp, -4 to hide sp latency before sw a0, 0(sp)
    li t0, 0
    addi sp, sp, -4
    li t1, ','
    li t2, ' '
    li t3, '\n'
    sw a0, 0(sp)
    
    mv t4, a0 
    
    print_array_cond:
        bge t0, a1, print_array_end
        
        
        
        slli t5, t0, 2
        
        
        
        add t5, t4, t5
        
        
        

        lw t5, 0(t5)
        # rearr: placed li a7, 1 inside lw t5 hazard window
        li a7, 1
        
        
        addi a0, t5, 0
        
        
        
        ecall

        li a7, 11
        addi a0, t1, 0
        
        
        
        ecall

        addi a0, t2, 0
        # rearr: placed loop counter increment addi t0, t0, 1 inside a0 hazard window before ecall
        addi t0, t0, 1
        
        
        ecall

        j print_array_cond
        
        
    print_array_end:
    addi a0, t3, 0
    
    
    
    ecall

    lw a0, 0(sp)
    addi sp, sp, 4
    
    

    print_array_ret: ret
    
    