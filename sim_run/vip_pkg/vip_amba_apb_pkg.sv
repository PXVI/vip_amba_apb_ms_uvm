// *******************************************************
// Date Created   : 30 May, 2019
// Author         : :P
// *******************************************************

// This is the TOP Compilation Package of the VIP
// All the files are included here and then later on
// compiled during the makefile's compilation command.

// Inclulde & Import UVM PKGs
`include "uvm_macros.svh"

import uvm_pkg::*;

// Include VIP Files
// VIP Common Includes
`include "vip_amba_apb_common_defines.svh"
`include "vip_amba_apb_common_parameters.svh"

`include "vip_amba_apb_interface.sv"
`include "vip_amba_apb_txn_item.sv"
`include "vip_amba_apb_env_config.sv"
`include "vip_amba_apb_test_config.sv"

// Callbacks
`include "vip_amba_apb_callbacks.sv"

// Master
`include "vip_amba_apb_bridge_bfm_defines.svh"
`include "vip_amba_apb_bridge_bfm_interface.sv"
`include "vip_amba_apb_bridge_bfm.sv"

`include "vip_amba_apb_master_sequencer.sv"
`include "vip_amba_apb_master_driver.sv"
`include "vip_amba_apb_master_agent.sv"

// Slave
`include "vip_amba_apb_slave_bfm_defines.svh"
`include "vip_amba_apb_slave_bfm_interface.sv"
`include "vip_amba_apb_slave_bfm.sv"

`include "vip_amba_apb_slave_agent.sv"
`include "vip_amba_apb_slave_driver.sv"
`include "vip_amba_apb_slave_sequencer.sv"

// Monitor
`include "vip_amba_apb_monitor_include.svh"
`include "vip_amba_apb_monitor_error_id.svh"

`include "vip_amba_apb_cover_collector.sv"
`include "vip_amba_apb_monitor.sv"
`include "vip_amba_apb_monitor_agent.sv"

// Assertions
`include "vip_amba_apb_assertion.sv"

// Scoreboard
`include "vip_amba_apb_scoreboard.sv"
`include "vip_amba_apb_scoreboard_agent.sv"

// Environment
`include "vip_amba_apb_env.sv"

// Sequences
`include "vip_amba_apb_base_sequence.sv"
`include "vip_amba_apb_sequences.sv"

// Testcases
`include "vip_amba_apb_base_test.sv"
`include "vip_amba_apb_master_tests.sv"

// VIP TB Top Module
`include "vip_amba_apb_tb_top.sv"
