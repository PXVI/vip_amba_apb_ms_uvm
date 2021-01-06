// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_monitor_agent extends uvm_agent;

	`uvm_component_utils( vip_amba_apb_monitor_agent )

    // Environment Instance Number
    // ---------------------------
    int env_num;

	// Monitor Driver ( Driver_to_BFM or Driver_is_BFM Mode )
	// ------------------------------------------------------
	vip_amba_apb_monitor monitor_inst;

    // Coverage Collector
    // ------------------
    vip_amba_apb_cover_collector cov_collector_inst;

    // Environement Configuration
    // --------------------------
    vip_amba_apb_env_config env_config;

	function new( string name="vip_amba_apb_monitor_agent", uvm_component parent );
		super.new( name,parent );
		$display( "Monitor Agent New Called" );
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );
        
        // Get the Environement Configuration File
        // ---------------------------------------
		if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( this ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf( "env_config[%0d]", env_num ) ),
							                                    .value( env_config ) ) )
        begin
			`uvm_fatal( "DB_GET_ERR","Failed to get the env_config in sequence" )
        end
		$display( "Monitor Agent Build Phase Called" );

        if( env_config.has_monitor )
        begin
		    monitor_inst = vip_amba_apb_monitor::type_id::create( "monitor_inst",this );
            monitor_inst.env_num = env_num;
        end

        if( env_config.has_cov_collector )
        begin
            cov_collector_inst = vip_amba_apb_cover_collector::type_id::create( "cov_collector_inst",this );
            cov_collector_inst.env_num = env_num;
        end
	endfunction

	function void connect_phase( uvm_phase phase );
		super.connect_phase( phase );

        if( env_config.has_monitor && env_config.has_cov_collector )
        begin
            monitor_inst.cov_collector_port.connect( cov_collector_inst.cov_collector_imp );
        end
	endfunction

endclass

