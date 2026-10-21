addi x1, x0, 0
addi x2, x0, 10

# common case 0 < 10
bltu x1, x2, success
success:
end:

wfi