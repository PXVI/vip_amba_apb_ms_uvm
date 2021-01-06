// *******************************************************
// Date Created   : 31 May, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_master_sequencer extends uvm_sequencer#( vip_amba_apb_txn_item );

	`uvm_component_utils( vip_amba_apb_master_sequencer )

    // Environment Instance Number
    // ---------------------------
    int env_num;

	function new( string name="vip_amba_apb_master_sequencer",uvm_component parent );
		super.new( name,parent );
		$display( "Sequencer Newed" );
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );
		$display( "Sequencer Built" );
	endfunction

endclass
