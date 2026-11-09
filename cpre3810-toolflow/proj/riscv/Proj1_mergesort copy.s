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
    # Rearr loaded array_size address via lasw3 and derived array address via addi a0, t0, 4 to hide lw a1 latency
    lasw3 t0, array_size # get get address for array_size
    nop
    nop
    nop
    lw a1, 0(t0) # size = array_size
    addi a0, t0, 4 # array = array
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
    # Rearr computed a3 (size - 1) and a2 (0) early to fill the hazard window between li t0 and blt
    addi a3, a1, -1 # size - 1
    li a2, 0
    nop
    blt a1, t0, sort_ret # if (size < 2) goto sort_ret;
    nop
    nop

    # Save caller's return address
    addi sp, sp, -8
    # Rearr placed lasw3 a1, temp_array right after addi sp so its 4 instructions completely hide sp latency
    lasw3 a1, temp_array
    sw ra, 0(sp)
    sw a3, 4(sp)
    
    # a0 = array
    nop
    jal ra, msort
    nop
    nop

    # restore caller's return address
    lw ra, 0(sp)
    lw a3, 4(sp)
    addi sp, sp, 8
    nop
    addi a1, a3, 1

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
    
    # Rearr interleaved stack pointer allocation and frame stores with mid (t0) calculation to eliminate extra NOPs
    addi sp, sp, -20
    add  t0, a2, a3         # t0 = left + right
    nop
    nop
    srli t0, t0, 1          # t0 = mid = (left + right) / 2
    sw   ra,  0(sp)     # save return
    sw   a2,  4(sp)     # save left
    sw   a3,  8(sp)     # save right
    sw   a1, 16(sp)     # save temp_array
    sw   t0, 12(sp)     # save mid

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
    # Rearr loaded t0 first and placed lw a1 and lw a3 in its hazard window before addi a2, t0, 1
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
        # Rearr placed slli t3 and slli t4 in the blt delay slots and interleaved t3, t4, and t5 address math
        slli t3, t0, 2
        slli t4, t1, 2
        slli t5, t2, 2
        nop

        # Load array[i] into t3
        add  t3, a0, t3
        # Load array[j] into t4
        add  t4, a0, t4
        add  t5, a1, t5
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
            sw   t3, 0(t5)           # temp_array[k] = array[i]
            # Rearr placed i++ and k++ into the 2 delay slots after j merge_loop
            j merge_loop
            addi t0, t0, 1           # i++
            addi t2, t2, 1           # k++
        take_right:
            sw   t4, 0(t5)           # temp_array[k] = array[j]
            # Rearr placed j++ and k++ into the 2 delay slots after j merge_loop
            j merge_loop
            addi t1, t1, 1           # j++
            addi t2, t2, 1           # k++
    merge_loop_end:
    nop

    copy_left:
        blt a3, t0, copy_left_end   # while i <= mid
        # Rearr placed slli t3 and slli t4 in the blt delay slots, interleaved add t3/t4, and put i++/k++ in the jump delay slots
        slli t3, t0, 2
        slli t4, t2, 2
        nop
        nop
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
        addi t0, t0, 1           # i++
        addi t2, t2, 1           # k++
    copy_left_end:
    nop

    copy_right:
        blt a4, t1, copy_right_end   # while j <= right
        # Rearr placed slli t3 and slli t4 in the blt delay slots, interleaved add t3/t4, and put j++/k++ in the jump delay slots
        slli t3, t1, 2
        slli t4, t2, 2
        nop
        nop
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
        addi t1, t1, 1           # j++
        addi t2, t2, 1           # k++
    copy_right_end:

    mv t0, a2 # i = left
    nop
    nop
    nop
    copy_back_loop:
        blt a4, t0, merge_ret   # while i <= right
        # Rearr placed slli t4 in blt delay slot, grouped add t5 and add t4, and moved i++ into j delay slot
        slli t4, t0, 2
        nop
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
        addi t0, t0, 1           # i++
        nop

    merge_ret: ret
    nop
    nop

print_array:
    # Rearr moved addi sp, sp, -4 before li t0/t1/t2 to hide sp latency before sw a0, 0(sp)
    addi sp, sp, -4
    li t0, 0
    li t1, ','
    li t2, ' '
    sw a0, 0(sp)
    li t3, '\n'
    
    mv t4, a0 
    nop
    print_array_cond:
        bge t0, a1, print_array_end
        # Rearr placed slli t5 in the 1st delay slot of bge
        slli t5, t0, 2
        nop
        nop
        nop
        add t5, t4, t5
        nop
        nop
        nop

        lw t5, 0(t5)
        # Rearr placed li a7, 1 during lw t5 latency
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
        # Rearr moved loop increment addi t0, t0, 1 before ecall to hide a0 latency
        addi t0, t0, 1
        nop
        nop
        ecall

        j print_array_cond
        nop
        nop
    print_array_end:
    # Rearr interleaved stack restore (lw t4, 0(sp) and addi sp, sp, 4) before ecall to hide latency
    li a7, 11
    addi a0, t3, 0
    lw t4, 0(sp)
    addi sp, sp, 4
    nop
    ecall
    mv a0, t4

    print_array_ret: ret
    nop
    nop