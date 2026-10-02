vsim -voptargs=+acc work.data_path2_tb

mem load -infile hex/datapath2_dmem.hex -format hex -startaddress 0 /data_path2_tb/data_path2_inst/mem0/ram

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /data_path2_tb/i_CLK
add wave -noupdate /data_path2_tb/i_RST
add wave -noupdate /data_path2_tb/i_REG_WE
add wave -noupdate /data_path2_tb/i_ADD_SUB_N
add wave -noupdate /data_path2_tb/i_ALU_SRC
add wave -noupdate /data_path2_tb/i_MEM_WRITE
add wave -noupdate /data_path2_tb/i_MEM_READ
add wave -noupdate /data_path2_tb/i_IMM
add wave -noupdate /data_path2_tb/i_REG_W_ADDR
add wave -noupdate /data_path2_tb/i_REG_R_ADDR
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/addr
add wave -noupdate /data_path2_tb/data_path2_inst/s_MEM_WE
add wave -noupdate /data_path2_tb/data_path2_inst/s_MEM_BE
add wave -noupdate /data_path2_tb/data_path2_inst/s_SUM_RES
add wave -noupdate /data_path2_tb/data_path2_inst/s_SIGN_EXT_DATA
add wave -noupdate /data_path2_tb/data_path2_inst/SIGN_EXTENDER_12B_0/i_CTRL
add wave -noupdate /data_path2_tb/data_path2_inst/REG_FILE/REGS0/o_DATA(27)
add wave -noupdate /data_path2_tb/data_path2_inst/REG_FILE/REGS0/o_DATA(26)
add wave -noupdate /data_path2_tb/data_path2_inst/REG_FILE/REGS0/o_DATA(25)
add wave -noupdate /data_path2_tb/data_path2_inst/REG_FILE/REGS0/o_DATA(2)
add wave -noupdate /data_path2_tb/data_path2_inst/REG_FILE/REGS0/o_DATA(1)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(127)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(65)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(68)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(67)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(66)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(65)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(64)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(6)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(5)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(4)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(3)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(2)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(1)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram(0)
add wave -noupdate /data_path2_tb/data_path2_inst/mem0/ram

TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 265
configure wave -valuecolwidth 82
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
WaveRestoreZoom {0 ns} {144 ns}

run -all