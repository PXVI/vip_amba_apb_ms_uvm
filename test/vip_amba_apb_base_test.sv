// *******************************************************
// Date Created   : 02 June, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_base_test extends uvm_test;

	`uvm_component_utils( vip_amba_apb_base_test )

	// Add the env instance
	// --------------------
	vip_amba_apb_env env_comp[];

	// Environment Configuration Object
	// --------------------------------
    vip_amba_apb_env_config env_config[];

    // Adding the Test Configuration
    // -----------------------------
    vip_amba_apb_test_config test_config[];

    // Bus Interface
    // -------------
	virtual vip_amba_apb_interface test_bus_intf0[];

	// Debug Log Handles
	// -----------------
	int master_debug[];
	int slave_debug[];
	int monitor_debug[];
	int scoreboard_debug[];

    // Multiple Environemnt Support
    // ----------------------------
    int num_env = 1;

	function new( string name="vip_amba_apb_base_test", uvm_component parent );
		super.new( name,parent );
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );
        
        // Assigning Memory To The Variables
        // ---------------------------------
        env_comp = new[num_env];
        env_config = new[num_env];
        test_config = new[num_env];
        test_bus_intf0 = new[num_env];

	    master_debug = new[num_env];
	    slave_debug = new[num_env];
	    monitor_debug = new[num_env];
	    scoreboard_debug = new[num_env];
        
        // Getting the Bus Interface
        // -------------------------
        for( int i = 0; i < num_env; i++ )
        begin
		    // Get the Bus Interface
		    if( !uvm_config_db#( virtual vip_amba_apb_interface )::get( 	.cntxt( this ),
		    								                                .inst_name( "" ),
		    								                                .field_name( $sformatf( "bus_intf0[%0d]", i ) ),
		    								                                .value( test_bus_intf0[i] ) ) )
		    	`uvm_fatal( "APB_MON_COM", " Failed to get the UVM Bus Interface" )
            else
                $display( " Successfully GOT THE INTF " );
        end
        

        // Multiple Configuration Environments Generation
        // ----------------------------------------------
        for( int i = 0; i < num_env; i++ )
        begin
		    /* -------------------
		    	ENV BUILDING
		      -------------------- */

		    // Creating and Setting the Env Config, for global access
		    // ------------------------------------------------------
            env_config[i] = vip_amba_apb_env_config::type_id::create( $sformatf( "env_config[%0d]", i ) );
            env_config[i].env_num = i;
 
            env_Configuration(  i,
                                test_bus_intf0[i].VIP_MODE_VAL[2],
                                test_bus_intf0[i].VIP_MODE_VAL[1],
                                test_bus_intf0[i].VIP_MODE_VAL[0],
                                1,
                                0 
            );
            env_Reg_Configuration( i );

		    uvm_config_db#( vip_amba_apb_env_config )::set( 		.cntxt( null ),
		    									                    .inst_name( "*" ),
		    									                    .field_name( $sformatf( "env_config[%0d]", i ) ),
		    									                    .value( env_config[i] ) );
		    
            // Creating and Setting the Test Config, for global access
            // -------------------------------------------------------
            test_config[i] = vip_amba_apb_test_config::type_id::create( $sformatf( "test_config[%0d]", i ) );

		    uvm_config_db#( vip_amba_apb_test_config )::set( 		.cntxt( null ),
		    									                    .inst_name( "*" ),
		    									                    .field_name( $sformatf( "test_config[%0d]", i ) ),
		    									                    .value( test_config[i] ) );

            // Creation of the Environment
            // ---------------------------
		    env_comp[i] = vip_amba_apb_env::type_id::create( $sformatf( "env_comp[%0d]", i ),this );
            env_comp[i].env_num = i;
        end
        
	endfunction

	function void end_of_elaboration_phase( uvm_phase phase );
		super.end_of_elaboration_phase( phase );

		/* -------------------
			END OF ELAB
		  -------------------- */
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );

		/* -------------------
			START OF SIM
		  -------------------- */
	endfunction

	task main_phase( uvm_phase phase );
        int end_test_count;

		phase.raise_objection( this );

		/* -------------------
			MAIN PHASE
		  -------------------- */

        // End Test Logic
        // --------------

        // BRIEF : This is a working peice of code. Questa begin an older version definitely has a bug. Using an alternative for now.
        //for( int m = 0; m < num_env; m++ )
        //begin
        //    fork
        //        begin
        //            wait( test_bus_intf0[m].end_test );
        //            end_test_count++;
        //        end
        //    join_none
        //end
        //wait( end_test_count == num_env );

        fork
            begin
                fork
                    wait( test_bus_intf0[0].end_test );
                    //wait( test_bus_intf0[1].end_test );
                join
                phase.drop_objection( this );
            end
        join_none
	endtask

	function void extract_phase( uvm_phase phase );
		super.extract_phase( phase );

		/* -------------------
			EXTRACT
		  -------------------- */
	endfunction

	function void check_phase( uvm_phase phase );
		super.check_phase( phase );

		/* -------------------
			CHECK
		  -------------------- */
	endfunction

	function void report_phase( uvm_phase phase );
		super.report_phase( phase );

		/* -------------------
			REPORT
		  -------------------- */
	endfunction

	function void final_phase( uvm_phase phase );
		super.final_phase( phase );

		/* -------------------
			FINAL
		  -------------------- */
        for( int i = 0; i < num_env; i++ )
        begin
            `ifdef VIP_MASTER_DEBUG
		        if( !uvm_config_db#( int )::get( 	.cntxt( this ),
		        				 	.inst_name( "" ),
		        					.field_name( $sformatf(  "master_debug[%0d]", i ) ),
		        					.value( master_debug[i] ) ) )
		        	`uvm_fatal( "DB_GET_ERR","Failed to get the master_debug handle" )
		        else
		        	$fclose( master_debug[i] );
            `endif

            `ifdef VIP_SLAVE_DEBUG
		        if( !uvm_config_db#( int )::get( 	.cntxt( this ),
		        				 	.inst_name( "" ),
		        					.field_name( $sformatf(  "slave_debug[%0d]", i ) ),
		        					.value( slave_debug[i] ) ) )
		        	`uvm_fatal( "DB_GET_ERR","Failed to get the slave_debug handle" )
		        else
		        	$fclose( slave_debug[i] );
            `endif

            `ifdef VIP_MONITOR_DEBUG
		        if( !uvm_config_db#( int )::get( 	.cntxt( this ),
		        				 	.inst_name( "" ),
		        					.field_name( $sformatf(  "monitor_debug[%0d]", i ) ),
		        					.value( monitor_debug[i] ) ) )
		        	`uvm_fatal( "DB_GET_ERR","Failed to get the monitor_debug handle" )
		        else
		        	$fclose( monitor_debug[i] );
            `endif

            `ifdef VIP_SCOREBOARD_DEBUG
		        if( !uvm_config_db#( int )::get( 	.cntxt( this ),
		        				 	.inst_name( "" ),
		        					.field_name( $sformatf(  "scoreboard_debug[%0d]", i ) ),
		        					.value( scoreboard_debug[i] ) ) )
		        	`uvm_fatal( "DB_GET_ERR","Failed to get the scoreboard_debug handle" )
		        else
		        	$fclose( scoreboard_debug[i] );
            `endif
        end
	endfunction

    function void env_Configuration(    int vip_inst_num = 0, 
                                        bit has_master = 0,
                                        bit has_slave = 0,
                                        bit has_monitor = 0,
                                        bit has_cov_collector = 0,
                                        bit has_scoreboard = 0 );
        // TODO Change this to a multi environment scenario
        env_config[vip_inst_num].has_master = has_master;
        env_config[vip_inst_num].has_slave = has_slave;
        env_config[vip_inst_num].has_monitor = has_monitor;
        env_config[vip_inst_num].has_cov_collector = has_cov_collector;
        env_config[vip_inst_num].has_scoreboard = has_scoreboard;
    endfunction

    function void env_Reg_Configuration( int vip_inst_num = 0 );
        // Set the default values for the configurable registers and other settings
    endfunction
endclass
