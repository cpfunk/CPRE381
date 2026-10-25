onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_32bit_tb/o_RESULT
add wave -noupdate /alu_32bit_tb/o_OF
add wave -noupdate /alu_32bit_tb/o_LTU
add wave -noupdate /alu_32bit_tb/o_LT
add wave -noupdate /alu_32bit_tb/o_EQUAL
add wave -noupdate /alu_32bit_tb/i_B
add wave -noupdate -radix binary /alu_32bit_tb/i_ALU_CTRL
add wave -noupdate /alu_32bit_tb/i_A
add wave -noupdate /alu_32bit_tb/equal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2465 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {2457 ns} {2479 ns}
