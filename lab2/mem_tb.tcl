vsim -voptargs=+acc work.mem_tb

mem load -infile hex/dmem.hex -format hex -startaddress 0 /mem_tb/dut/ram

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mem_tb/clk
add wave -noupdate /mem_tb/be
add wave -noupdate /mem_tb/we
add wave -noupdate /mem_tb/dut/addr
add wave -noupdate /mem_tb/q
add wave -noupdate /mem_tb/REGFILE_RST
add wave -noupdate /mem_tb/REGFILE_WE
add wave -noupdate /mem_tb/REGFILE_W_ADDR
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(10)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(9)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(8)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(7)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(6)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(5)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(4)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(3)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(2)
add wave -noupdate /mem_tb/reg_file_inst/REGS0/o_DATA(1)
add wave -noupdate /mem_tb/reg_file_inst/o_DATA
add wave -noupdate /mem_tb/dut/ram(265)
add wave -noupdate /mem_tb/dut/ram(264)
add wave -noupdate /mem_tb/dut/ram(263)
add wave -noupdate /mem_tb/dut/ram(262)
add wave -noupdate /mem_tb/dut/ram(261)
add wave -noupdate /mem_tb/dut/ram(260)
add wave -noupdate /mem_tb/dut/ram(259)
add wave -noupdate /mem_tb/dut/ram(258)
add wave -noupdate /mem_tb/dut/ram(257)
add wave -noupdate /mem_tb/dut/ram(256)
add wave -noupdate /mem_tb/dut/ram(9)
add wave -noupdate /mem_tb/dut/ram(8)
add wave -noupdate /mem_tb/dut/ram(7)
add wave -noupdate /mem_tb/dut/ram(6)
add wave -noupdate /mem_tb/dut/ram(5)
add wave -noupdate /mem_tb/dut/ram(4)
add wave -noupdate /mem_tb/dut/ram(3)
add wave -noupdate /mem_tb/dut/ram(2)
add wave -noupdate /mem_tb/dut/ram(1)
add wave -noupdate /mem_tb/dut/ram(0)
add wave -noupdate /mem_tb/dut/ram  

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {1969 ns}

run -all
