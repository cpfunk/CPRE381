vsim -voptargs=+acc work.data_path1_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /data_path1_tb/i_CLK
add wave -noupdate /data_path1_tb/i_RST
add wave -noupdate /data_path1_tb/i_WE
add wave -noupdate /data_path1_tb/i_ADD_SUB_N
add wave -noupdate /data_path1_tb/i_ALU_SRC
add wave -noupdate /data_path1_tb/s_IMM
add wave -noupdate /data_path1_tb/i_RD
add wave -noupdate /data_path1_tb/i_RS
add wave -noupdate /data_path1_tb/i_IMM
add wave -noupdate /data_path1_tb/data_path1_inst/s_DATA
add wave -noupdate /data_path1_tb/data_path1_inst/REG_FILE/REGS0/o_DATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {49 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 265
configure wave -valuecolwidth 82
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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