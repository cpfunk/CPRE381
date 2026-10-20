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

# TODO: Implement your sorting algorithm here.
# void sort(int* array, int size);
# a0 = base address of array
# a1 = size (number of elements)
.globl sort
sort:
    # Base case: if size <= 1, return immediately
    addi t0, x0, 1
    bge  t0, a1, sort_ret

    # Save callee-saved registers and return address
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8(sp)
    sw   s1, 4(sp)
    sw   s2, 0(sp)

    add  s0, a0, x0          # s0 = array base pointer
    add  s1, a1, x0          # s1 = n (total elements)
    slli t0, s1, 2           # t0 = n * 4 bytes
    add  s2, s0, t0          # s2 = temp_array base pointer (immediately after array)

    # Recursive Merge Sort: msort(left = 0, right = n - 1)
    add  a0, x0, x0          # a0 = left = 0
    addi a1, s1, -1          # a1 = right = n - 1
    jal  ra, msort

    # Restore registers and return
    lw   s2, 0(sp)
    lw   s1, 4(sp)
    lw   s0, 8(sp)
    lw   ra, 12(sp)
    addi sp, sp, 16
sort_ret:
    jalr x0, ra, 0

# void msort(int left, int right)
# Uses s0 = array base, s2 = temp_array base
# a0 = left, a1 = right
msort:
    bge  a0, a1, msort_done  # if left >= right, return

    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   a0, 8(sp)           # save left
    sw   a1, 4(sp)           # save right

    add  t0, a0, a1          # t0 = left + right
    srli t0, t0, 1           # t0 = mid = (left + right) / 2
    sw   t0, 0(sp)           # save mid

    # msort(left, mid)
    add  a1, t0, x0          # a1 = mid
    jal  ra, msort

    # msort(mid + 1, right)
    lw   t0, 0(sp)           # restore mid
    addi a0, t0, 1           # a0 = mid + 1
    lw   a1, 4(sp)           # restore right
    jal  ra, msort

    # merge(left, mid, right)
    lw   a0, 8(sp)           # a0 = left
    lw   a1, 0(sp)           # a1 = mid
    lw   a2, 4(sp)           # a2 = right
    jal  ra, merge

    lw   ra, 12(sp)
    addi sp, sp, 16
msort_done:
    jalr x0, ra, 0

# void merge(int left, int mid, int right)
# a0 = left, a1 = mid, a2 = right
# s0 = array base, s2 = temp_array base
merge:
    add  t0, a0, x0          # t0 = i = left
    addi t1, a1, 1           # t1 = j = mid + 1
    add  t2, a0, x0          # t2 = k = left

merge_loop:
    blt  a1, t0, copy_right  # if i > mid, left half exhausted
    blt  a2, t1, copy_left   # if j > right, right half exhausted

    # Load array[i] into t5
    slli t3, t0, 2
    add  t3, s0, t3
    lw   t5, 0(t3)

    # Load array[j] into t6
    slli t4, t1, 2
    add  t4, s0, t4
    lw   t6, 0(t4)

    # Compare array[i] and array[j]
    blt  t6, t5, take_right  # if array[j] < array[i], take right element

take_left:
    slli t3, t2, 2
    add  t3, s2, t3
    sw   t5, 0(t3)           # temp_array[k] = array[i]
    addi t0, t0, 1           # i++
    addi t2, t2, 1           # k++
    jal  x0, merge_loop

take_right:
    slli t4, t2, 2
    add  t4, s2, t4
    sw   t6, 0(t4)           # temp_array[k] = array[j]
    addi t1, t1, 1           # j++
    addi t2, t2, 1           # k++
    jal  x0, merge_loop

copy_left:
    blt  a1, t0, copy_back   # while i <= mid
    slli t3, t0, 2
    add  t3, s0, t3
    lw   t5, 0(t3)           # t5 = array[i]
    slli t4, t2, 2
    add  t4, s2, t4
    sw   t5, 0(t4)           # temp_array[k] = array[i]
    addi t0, t0, 1           # i++
    addi t2, t2, 1           # k++
    jal  x0, copy_left

copy_right:
    blt  a2, t1, copy_back   # while j <= right
    slli t4, t1, 2
    add  t4, s0, t4
    lw   t6, 0(t4)           # t6 = array[j]
    slli t3, t2, 2
    add  t3, s2, t3
    sw   t6, 0(t3)           # temp_array[k] = array[j]
    addi t1, t1, 1           # j++
    addi t2, t2, 1           # k++
    jal  x0, copy_right

copy_back:
    add  t0, a0, x0          # t0 = i = left
    slli t3, a0, 2           # t3 = left * 4
    add  t3, s2, t3          # t3 points to temp_array[left]
    add  t4, s0, x0          # t4 points to array[0]
    slli t6, a0, 2
    add  t4, t4, t6          # t4 points to array[left]

copy_back_loop:
    blt  a2, t0, merge_done  # while i <= right
    lw   t5, 0(t3)           # t5 = temp_array[i]
    sw   t5, 0(t4)           # array[i] = temp_array[i]
    addi t3, t3, 4           # temp_array ptr++
    addi t4, t4, 4           # array ptr++
    addi t0, t0, 1           # i++
    j    copy_back_loop

merge_done:
    jalr x0, ra, 0
#########################################
# // In .data:
# // int temp_array[512]; 
# 
# void sort(int* array, int size) {
#     if (size <= 1) return;          // bge t0, a1, sort_ret (where t0 = 1)
#     msort(array, temp_array, 0, size - 1);
# }
# 
# void msort(int* array, int* temp_array, int left, int right) {
#     if (left >= right) return;      // bge a0, a1, msort_done (base case)
# 
#     int mid = (left + right) >> 1;  // add t0, a0, a1 -> srli t0, t0, 1
# 
#     // Recursive calls (saves ra, left, right, mid on the stack)
#     msort(array, temp_array, left, mid);       // jal ra, msort (left half)
#     msort(array, temp_array, mid + 1, right);  // jal ra, msort (right half)
# 
#     // Merge the two sorted halves
#     merge(array, temp_array, left, mid, right); // jal ra, merge
# }
# 
# void merge(int* array, int* temp_array, int left, int mid, int right) {
#     int i = left;       // t0 = i
#     int j = mid + 1;    // t1 = j
#     int k = left;       // t2 = k
# 
#     // merge_loop: compare elements from left and right halves
#     while (i <= mid && j <= right) {
#         if (array[j] < array[i]) {  // blt t6, t5, take_right
#             temp_array[k] = array[j];
#             j++;
#             k++;
#         } else {                    // take_left
#             temp_array[k] = array[i];
#             i++;
#             k++;
#         }
#     }
# 
#     // copy_left: copy any remaining elements from left half
#     while (i <= mid) {
#         temp_array[k] = array[i];
#         i++;
#         k++;
#     }
# 
#     // copy_right: copy any remaining elements from right half
#     while (j <= right) {
#         temp_array[k] = array[j];
#         j++;
#         k++;
#     }
# 
#     // copy_back_loop: copy merged elements from temp_array back into original array
#     for (i = left; i <= right; i++) {
#         array[i] = temp_array[i];
#     }
# }