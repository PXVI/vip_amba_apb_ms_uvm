onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /integration_top/to_cpu_RDATA_w
add wave -noupdate /integration_top/from_cpu_address_w
add wave -noupdate /integration_top/from_cpu_wr_STRB_w
add wave -noupdate /integration_top/from_cpu_wr_WDATA_w
add wave -noupdate /integration_top/PRESETn_w
add wave -noupdate /integration_top/PCLK_w
add wave -noupdate /integration_top/PRDATA_w
add wave -noupdate /integration_top/PADDR_w
add wave -noupdate /integration_top/PWDATA_w
add wave -noupdate /integration_top/PSTRB_w
add wave -noupdate /integration_top/PSELx_w
add wave -noupdate /integration_top/PENABLE_w
add wave -noupdate /integration_top/PWRITE_w
add wave -noupdate /integration_top/PREADY_w
add wave -noupdate /integration_top/PSLVERR_w
add wave -noupdate /integration_top/PPROT_w
add wave -noupdate /integration_top/from_cpu_slave_sel_w
add wave -noupdate /integration_top/from_cpu_rd_wr_w
add wave -noupdate /integration_top/from_cpu_valid_txn_w
add wave -noupdate /integration_top/from_cpu_resetn_w
add wave -noupdate /integration_top/to_cpu_txn_err_w
add wave -noupdate /integration_top/apb_ready_for_txn_w
add wave -noupdate /integration_top/to_cpu_RDATA_valid_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {300 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1306 ns}
