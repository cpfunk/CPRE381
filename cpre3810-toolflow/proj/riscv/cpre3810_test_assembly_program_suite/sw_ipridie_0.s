# Isaiah Pridie
# CprE 381 - HW_4
# 3.5.2026, 8:50 PM

# First test program will test sw by:
    # Moving the base address and store value across ALL registers
    # Moving the stored destination sparsely across the entire memory address range
    # Test the FRIST and LAST two accessible memory addresses
    # NO OFFSET YET

# REMEMBER: 
    # RISC-V memory instructions are byte addressable, but mem.vhd is word addressable
    # .text (program memory) starts at 0x1001.0000
    # Last reachable memory address of memory is 0x10010FFC

.data           # (data memory) starts at 0x1001.0000

.text           # (program memory) starts at 0x0040.0000
.global main    

main:

    # Start Test:

    # 1st Store
    lui  x1, 0x10010        # Load x1 with address of beginning of data memory
    addi x2, x0, 0x1        # Load x2 with 0d'1'
    sw   x2, 0(x1)          # Store x2 at x1, no offset

    # 2nd Store
    addi x2, x1, 4          # Load x2 with address 0x1001.007C
    addi x3, x0, 0x2        # Load x3 with 0d'2'
    sw   x3, 0(x2)          # Store x3 at x2

    # 3rd Store
    addi x3, x2, 124        # Load x3 with address 0x1001.00F8
    addi x4, x0, 0x3        # Load x4 with 0d'3'
    sw   x4, 0(x3)          # Store x4 at x3

    # 4th Store
    addi x4, x3, 124        # Load x3 with address 0x1001.0174
    addi x5, x0, 0x4        # Load x4 with 0d'4'
    sw   x5, 0(x4)          # Store x4 at x3

    # 5th Store
    addi x5, x4, 124        # Load x3 with address 0x1001.01F0
    addi x6, x0, 0x5        # Load x4 with 0d'5'
    sw   x6, 0(x5)          # Store x4 at x3

    # 6th Store
    addi x6, x5, 124        # Load x3 with address 0x1001.026C
    addi x7, x0, 0x6        # Load x4 with 0d'6'
    sw   x7, 0(x6)          # Store x4 at x3

    # 7th Store
    addi x7, x6, 124        # Load x3 with address 0x1001.02E8
    addi x8, x0, 0x7        # Load x4 with 0d'7'
    sw   x8, 0(x7)          # Store x4 at x3

    # 8th Store
    addi x8, x7, 124        # Load x3 with address 0x1001.0364
    addi x9, x0, 0x8        # Load x4 with 0d'8'
    sw   x9, 0(x8)          # Store x4 at x3

    # 9th Store
    addi x9, x8, 124        # Load x9 with address 0x1001.03E0
    addi x10, x0, 0x9       # Load x4 with 0d'9'
    sw   x10, 0(x9)         # Store x4 at x3

    # 10th Store
    addi x10, x9, 124       # Load x3 with address 0x1001.045C
    addi x11, x0, 0xA       # Load x4 with 0d'10'
    sw   x11, 0(x10)        # Store x4 at x3

    # 11th Store
    addi x11, x10, 124      # Load x3 with address 0x1001.04D8
    addi x12, x0, 0xB       # Load x4 with 0d'11
    sw   x12, 0(x11)        # Store x4 at x3

    # 12th Store
    addi x12, x11, 124      # Load x3 with address 0x1001.0554
    addi x13, x0, 0xC       # Load x4 with 0d'12'
    sw   x13, 0(x12)        # Store x4 at x3
    
    # 13th Store
    addi x13, x12, 124      # Load x3 with address 0x1001.05D0
    addi x14, x0, 0xD        # Load x4 with 0d'13'
    sw   x14, 0(x13)         # Store x4 at x3

    # 14th Store        
    addi x14, x13, 124      # Load x14 with address 0x1001.064C
    addi x15, x0, 0xE       # Load x15 with 0d'14'
    sw   x15, 0(x14)        # Store x15 at x14

    # 15th Store            
    addi x15, x14, 124      # Load x15 with address 0x1001.06C8
    addi x16, x0, 0xF       # Load x16 with 0d'15'
    sw   x16, 0(x15)        # Store x16 at x15

    # 16th Store            
    addi x16, x15, 124      # Load x16 with address 0x10010.744
    addi x17, x0, 0x10      # Load x17 with 0d'16'
    sw   x17, 0(x16)        # Store x17 at x16

    # 17th Store          
    addi x17, x16, 124      # Load x17 with address 0x1001.07C0
    addi x18, x0, 0x11      # Load x18 with 0d'17'
    sw   x18, 0(x17)        # Store x18 at x17

    # 18th Store         
    addi x18, x17, 124      # Load x18 with address 0x1001.083C
    addi x19, x0, 0x12      # Load x19 with 0d'18'
    sw   x19, 0(x18)        # Store x19 at x18

    # 19th Store       
    addi x19, x18, 124      # Load x19 with address 0x1001.08B8
    addi x20, x0, 0x13      # Load x20 with 0d'19'
    sw   x20, 0(x19)        # Store x20 at x19

    # 20th Store        
    addi x20, x19, 124      # Load x20 with address 0x1001.0934
    addi x21, x0, 0x14      # Load x21 with 0d'20'
    sw   x21, 0(x20)        # Store x21 at x20

    # 21st Store         
    addi x21, x20, 124      # Load x21 with address 0x1001.09B0
    addi x22, x0, 0x15      # Load x22 with 0d'21'
    sw   x22, 0(x21)        # Store x22 at x21

    # 22nd Store         
    addi x22, x21, 124      # Load x22 with address 0x1001.0A2C
    addi x23, x0, 0x16      # Load x23 with 0d'22'
    sw   x23, 0(x22)        # Store x23 at x22

    # 23rd Store       
    addi x23, x22, 124      # Load x23 with address 0x1001.0AA8
    addi x24, x0, 0x17      # Load x24 with 0d'23'
    sw   x24, 0(x23)        # Store x24 at x23

    # 24th Store         
    addi x24, x23, 124      # Load x24 with address 0x1001.0B24
    addi x25, x0, 0x18      # Load x25 with 0d'24'
    sw   x25, 0(x24)        # Store x25 at x24

    # 25th Store         
    addi x25, x24, 124      # Load x25 with address 0x1001.0BA0
    addi x26, x0, 0x19      # Load x26 with 0d'25'
    sw   x26, 0(x25)        # Store x26 at x25

    # 26th Store         
    addi x26, x25, 124      # Load x26 with address 0x1001.0C1C
    addi x27, x0, 0x1A      # Load x27 with 0d'26'
    sw   x27, 0(x26)        # Store x27 at x26

    # 27th Store        
    addi x27, x26, 124      # Load x27 with address 0x1001.0C98
    addi x28, x0, 0x1B      # Load x28 with 0d'27'
    sw   x28, 0(x27)        # Store x28 at x27

    # 28th Store       
    addi x28, x27, 124      # Load x28 with address 0x1001.0D14
    addi x29, x0, 0x1C      # Load x29 with 0d'28'
    sw   x29, 0(x28)        # Store x29 at x28

    # 29th Store         
    addi x29, x28, 124      # Load x29 with address 0x1001.0D90
    addi x30, x0, 0x1D      # Load x30 with 0d'29'
    sw   x30, 0(x29)        # Store x30 at x29

    # 30th Store            # Supposed to be 2nd-to-last address of accessible memory
    addi x30, x29, 736      # Load x30 with address 0x1001.0FF8
    addi x31, x0, 0x1E      # Load x31 with 0d'30'
    sw   x31, 0(x30)        # Store x31 at x30

    # 31st Store            # Supposed to be last address of accessible memory
    addi x31, x30, 4        # Load x31 with address 0x1001.0FFC
    addi x1,  x0, 0x1F      # Load x1 with 0d'31'
    sw   x1, 0(x31)         # Store x1 at x31



wfi