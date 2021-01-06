// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_env_config extends uvm_object;

    // Bus Interface Configuration
    // ---------------------------
    int ADDRESS_WIDTH;
    int DATA_STROBE;
    int SELECT_LINE_WIDTH;
    int DATA_WIDTH;

    rand int wait_state[$];

    bit error_write_data[$];
    bit error_read_data[$];
    bit pslverr_err_inj[$];

    rand bit [32-1:0] data;

    // Environment Creation Control Bits
    // ---------------------------------
    bit has_master;
    bit has_monitor;
    bit has_slave;
    bit has_cov_collector;
    bit has_scoreboard;

    int env_num;

	`uvm_object_utils_begin( vip_amba_apb_env_config )
    // Util Registration
        `uvm_field_queue_int( wait_state, UVM_ALL_ON )
        `uvm_field_int( has_master, UVM_ALL_ON )
        `uvm_field_int( has_monitor, UVM_ALL_ON )
        `uvm_field_int( has_slave, UVM_ALL_ON )
        `uvm_field_int( has_cov_collector, UVM_ALL_ON )
        `uvm_field_int( has_scoreboard, UVM_ALL_ON )
        `uvm_field_int( env_num, UVM_ALL_ON )
	`uvm_object_utils_end

    function new( string name = "vip_amba_apb_env_config" );
        super.new( name );
    endfunction

endclass
