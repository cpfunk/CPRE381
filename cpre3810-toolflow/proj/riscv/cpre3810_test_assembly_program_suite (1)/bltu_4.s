addi x1, x0, -1
addi x2, x0, 0

# 0xFFFF FFFF < 0x0000 0000
# if it compares signed values it will fail so it must use unsigned
bltu x1, x2, failure
failure:
end:

wfi