// *******************************************************
// Date Created   : 02 June, 2019
// Author         : :P
// *******************************************************

// Global Clock Time Period
// ------------------------

`ifndef time_period
	`define time_period				10
`endif

`ifdef COMMON_TB_DEFINES_PARAMS

// Defines Section
// ---------------

`define ADDRESS_WIDTH               32
`define DATA_STROBE                 4
`define DATA_WIDTH                  8 * `DATA_STROBE
`define SELECT_LINE_WIDTH           1

`define PSELx_TIMEOUT               20

// Slave Configuration
// -------------------
`define PSLVERR_RDATA_VALUE         0 // 0 is for all 0's and 1 is for all x's

`endif

// Dump Creation Define
// --------------------

`define DUMP_VAR					\
    `ifdef MAKEFILE_DUMP_SWITCH \
							initial	\
							begin \
								$dumpfile( "apb_dump.vcd" ); \
								$dumpvars( 0,integration_top ); \
							end \
    `endif

// Debug Displays
// --------------

`ifdef VIP_DEBUG
    `define VIP_MONITOR_DEBUG
`endif

`define UVM_INFO_MST( tag, str, uvm_verbosity ) \
    `ifdef VIP_MASTER_DEBUG \
        `uvm_info( tag, str, uvm_verbosity ) \
    `endif

`define UVM_INFO_SEQ( tag, str, uvm_verbosity ) \
    `ifdef VIP_SEQUENCE_DEBUG \
        `uvm_info( tag, str, uvm_verbosity ) \
    `endif

`define UVM_INFO_TST( tag, str, uvm_verbosity ) \
    `ifdef VIP_TEST_DEBUG \
        `uvm_info( tag, str, uvm_verbosity ) \
    `endif

`define UVM_INFO_NF( ID, MSG, VERBOSITY ) \
    begin \
        if( uvm_report_enabled( VERBOSITY, UVM_INFO, ID ) ) \
            uvm_report_info( ID, MSG, UVM_LOW, "", 0 ); \
    end

`define uvm_info( ID, MSG, VERBOSITY ) \
    begin \
        if( uvm_report_enabled( VERBOSITY, UVM_INFO, ID ) ) \
            uvm_report_info( ID, MSG, UVM_LOW, "", 0 ); \
    end

`define uvm_warning( ID, MSG ) \
    begin \
        if( uvm_report_enabled( UVM_NONE, UVM_WARNING, ID ) ) \
            uvm_report_warning( ID, MSG, UVM_NONE, "", 0 ); \
    end

`define uvm_error( ID, MSG ) \
    begin \
        if( uvm_report_enabled( UVM_NONE, UVM_ERROR, ID ) ) \
            uvm_report_error( ID, MSG, UVM_NONE, "", 0 ); \
    end

// Count & SCount Defines
//-----------------------

`ifndef COUNT
    `define COUNT 10
`endif

// Sequence Specific Reusable Defines
// ----------------------------------
`define seq_make( w,x,y ) \
    w = x::type_id::create( "pkt" ); \
    w.env_num = y;
`define seq_fire( i,x ) \
    if( env_comp[i].env_config.has_master ) \
    begin \
		x.start( env_comp[i].master_agent.master_sequencer ); \
    end

// Test Specific Reuable Define
// ----------------------------

`define expected_err_count(env_num,x,y) begin  test_config.EID_expected_count[x] = y; end
`define E_2_I(env_num,x) test_config[env_num].EID[x] = 'd2;
`define E_2_W(env_num,x) test_config[env_num].EID[x] = 'd1;

// Test Timeout Value
//-------------------

`ifndef TIMEOUT
    `define TIMEOUT 3000
`endif
