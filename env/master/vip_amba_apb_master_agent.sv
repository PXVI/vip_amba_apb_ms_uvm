// *******************************************************
// Date Created   : 31 May, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_master_agent extends uvm_agent;

	`uvm_component_utils( vip_amba_apb_master_agent )
    
    // Environment Instance Number
    // ---------------------------
    int env_num;

	// Master Sequencer
	vip_amba_apb_master_sequencer master_sequencer;

	// Master Driver ( Driver_to_BFM or Driver_is_BFM Mode )
	vip_amba_apb_master_driver master_driver;

	// Master BFM
	// TODO : Needs to be connected at the top module using a bfm specific interface or a one merged into the existing one itself.

	function new( string name="vip_amba_apb_master_agent", uvm_component parent );
		super.new( name,parent );
		$display( "Master Agent New Called" );
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );
		$display( "Master Agent Build Phase Called" );

		master_sequencer = vip_amba_apb_master_sequencer::type_id::create( "master_sequencer",this );
        master_sequencer.env_num = env_num;
		master_driver = vip_amba_apb_master_driver::type_id::create( "master_driver",this );
        master_driver.env_num = env_num;
	endfunction

	function void connect_phase( uvm_phase phase );
		super.connect_phase( phase );
	
		master_driver.seq_item_port.connect( master_sequencer.seq_item_export );
	endfunction

endclass
