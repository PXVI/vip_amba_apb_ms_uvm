// *******************************************************
// Date Created   : 04 December, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_cover_collector extends uvm_subscriber#( vip_amba_apb_txn_item );

	`uvm_component_utils( vip_amba_apb_cover_collector )
    
    uvm_analysis_imp #( vip_amba_apb_txn_item, vip_amba_apb_cover_collector ) cov_collector_imp;
    
    // Environment Instance Number
    // ---------------------------
    int env_num;

    // Component & Object Declarations
    // -------------------------------
    vip_amba_apb_txn_item cov_pkt;

    // Test Configuration
    // ------------------
    vip_amba_apb_env_config env_config;

	// Debug Log Handle
	// ----------------
	int monitor_debug;

    // Varibals Declarations
    // ---------------------

    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Coverage Bins & Groups
    // ----------------------
    covergroup apb_pkt;
        Address : coverpoint cov_pkt.txn_ADDR {
                                                bins VALID_ADDRESS = { [32'h0:32'hFFFF_FFFF] };
        }
        Strobe : coverpoint cov_pkt.txn_STRB {
                                                bins strobe_bits[] = { [8'd0:8'hFF] };
                                                bins others = default;
        }
    endgroup

    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	function new( string name="vip_amba_apb_cover_collector", uvm_component parent );
		super.new( name,parent );
		$display( "Coverage Collector Instance New Called" );

        cov_collector_imp = new( "cov_collector_imp",this );
        cov_pkt = new();

        // Cover Group Creation
        // --------------------
        apb_pkt = new();
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );
        
        // Get the Environment Config File
        // -------------------------------
		if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( this ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf( "env_config[%0d]", env_num ) ),
							                                    .value( env_config ) ) )
        begin
			`uvm_fatal( "DB_GET_ERR","Failed to get the env_config in sequence" )
        end

		$display( "Coverage Instance Build Phase Called" );
	endfunction

	function void connect_phase( uvm_phase phase );
		super.connect_phase( phase );
	endfunction
	
    function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
		
        // Get the Monitor Debug Handle
        // ----------------------------
        `ifdef VIP_MONITOR_DEBUG
		    if( !uvm_config_db#( int )::get( 	.cntxt( this ),
		    				 	.inst_name( "" ),
		    					.field_name( $sformatf( "monitor_debug[%0d]", env_num ) ),
		    					.value( monitor_debug ) ) )
            begin
		    	`uvm_fatal( "APB_MON_COM"," Failed to get the monitor_debug handle" )
            end
        `endif
	endfunction

    task main_phase( uvm_phase phase );
		phase.raise_objection( this );

        `cdisplay( " Coverage Collector Task Started...",0 )

        fork
        join_none

		phase.drop_objection( this );
    endtask

    // Final Phase
    // -----------
    function void extract_phase( uvm_phase phase );
		super.extract_phase( phase );
	endfunction
    
    // Write Function
    virtual function void write( vip_amba_apb_txn_item t );
        `cdisplay( " Coverage COLLECTOR WRITE Called! ",0 )
        cov_pkt = t;
        apb_pkt.sample();
    endfunction
    
endclass

