// *******************************************************
// Date Created   : 05 June, 2019
// Author         : :P
// *******************************************************

// TODO Add these in a seperate sequence include file.
`define display( strx ) \
    `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ", strx, UVM_LOW )


//--------------------------------------------------------
// [000] Description:
// Simple base sequence for the other sequences
//--------------------------------------------------------

class vip_amba_apb_base_sequence extends uvm_sequence#( vip_amba_apb_txn_item );

	`uvm_object_utils( vip_amba_apb_base_sequence )
    
    rand logic [32-1:0]     Address[$];
    rand logic [32-1:0]     Data[$];
    rand logic              WR_RD[$];
    rand logic [8-1:0]      WStrobe[$];
    rand bit                txn_consecutive[$];

    bit                     read_txn_error;

    int env_num;
    
    vip_amba_apb_env_config env_config;
    vip_amba_apb_test_config test_config;
    
    // Bus Interface
    // -------------
	virtual vip_amba_apb_interface seq_bus_intf0;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_base_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();

		// Get the Bus Interface
		// ---------------------
		if( !uvm_config_db#( virtual vip_amba_apb_interface )::get( 	.cntxt( uvm_root::get() ),
										                                .inst_name( "" ),
										                                .field_name( $sformatf( "bus_intf0[%0d]", env_num ) ),
										                                .value( seq_bus_intf0 ) ) )
			`uvm_fatal( "APB_MON_COM", " Failed to get the UVM Bus Interface" )

        // Get the test config file
        // ------------------------
		if( !uvm_config_db#( vip_amba_apb_test_config )::get( 	.cntxt( uvm_root::get() ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf ( "test_config[%0d]", env_num ) ),
							                                    .value( test_config ) ) )
			`uvm_fatal( "DB_GET_ERR","Failed to get the test_config in sequence" )

        // Get the env config file
        // -----------------------
		if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( uvm_root::get() ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf ( "env_config[%0d]", env_num ) ),
							                                    .value( env_config ) ) )
			`uvm_fatal( "db_get_err","failed to get the env_config in sequence" )


    endtask

	task body();
		//vip_amba_apb_txn_item pkt;
		//pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );
		//$display( "Inside the Sequence BODY-----------" );
	
		//repeat( 5 )
		//begin
		//	start_item( pkt );

		//	assert( pkt.randomize() with { 
        //                                    txn_ADDR == 32'h44_44_22_22;    
        //                                    } );

		//	finish_item( pkt );
		//end

        // Get the env config file
        // -----------------------
		if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( uvm_root::get() ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf( "env_config[%0d]", env_num ) ),
							                                    .value( env_config ) ) )
			`uvm_fatal( "db_get_err","failed to get the env_config in sequence" )
	endtask

    task post_body();
    endtask

    constraint txn_q_sizes { 
                                Address.size() == Data.size();
                                Data.size() == WR_RD.size();
                                WR_RD.size() == WStrobe.size();
                                WStrobe.size() == txn_consecutive.size();
    };

    constraint txn_q_default_size { 
                                        soft Address.size() == 1;
                                        foreach( txn_consecutive[i] )
                                            soft txn_consecutive[i] == 1'b0;
    };

endclass
