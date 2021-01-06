// *******************************************************
// Date Created   : 05 June, 2019
// Author         : :P
// *******************************************************

//--------------------------------------------------------
// [001] Description:
// Basic SANITY Test
//--------------------------------------------------------

class vip_amba_apb_master_sanity_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_sanity_test )

	vip_amba_apb_sanity_sequence seq;
	
	function new( string name="vip_amba_apb_master_sanity_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_sanity_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
        // Alternate way of firing a sequence onto a Sequencer
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_sanity_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [002] Description:
// Basic RANDOM Seq Test
//--------------------------------------------------------

class vip_amba_apb_master_random_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_random_test )

	vip_amba_apb_sanity_sequence seq;
	
	function new( string name="vip_amba_apb_master_random_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_random_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_sanity_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [003] Description:
// Basic READ Test
//--------------------------------------------------------

class vip_amba_apb_master_read_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_read_test )

	vip_amba_apb_read_sequence seq;
	
	function new( string name="vip_amba_apb_master_read_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_read_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_read_sequence, 0 )
        seq.stand_alone_seq = 1;

        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [004] Description:
// Basic WRITE Test
//--------------------------------------------------------

class vip_amba_apb_master_write_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_write_test )

	vip_amba_apb_write_sequence seq;
	
	function new( string name="vip_amba_apb_master_write_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_write_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_write_sequence, 0 )
        seq.stand_alone_seq = 1;

        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [005] Description:
// Basic WRITE READ Test
//--------------------------------------------------------

class vip_amba_apb_master_write_read_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_write_read_test )

	vip_amba_apb_write_read_sequence seq;
	
	function new( string name="vip_amba_apb_master_write_read_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_write_read_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_write_read_sequence, 0 )

        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [006] Description:
// Basic Back to Back READ Test
//--------------------------------------------------------

class vip_amba_apb_master_read_to_read_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_read_to_read_test )

	vip_amba_apb_read_to_read_sequence seq;
	
	function new( string name="vip_amba_apb_master_read_to_read_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_read_to_read_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_read_to_read_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [007] Description:
// Basic Back to Back WRITE Test
//--------------------------------------------------------

class vip_amba_apb_master_write_to_write_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_write_to_write_test )

	vip_amba_apb_write_to_write_sequence seq;
	
	function new( string name="vip_amba_apb_master_write_to_write_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_write_to_write_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_write_to_write_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [008] Description:
// Basic Back to Back WRITE to READ Test
//--------------------------------------------------------

class vip_amba_apb_master_write_to_read_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_write_to_read_test )

	vip_amba_apb_write_to_read_sequence seq;
	
	function new( string name="vip_amba_apb_master_write_to_read_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_write_to_read_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_write_to_read_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [009] Description:
// WRITE with Wait States
//--------------------------------------------------------

class vip_amba_apb_master_write_with_wait_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_write_with_wait_test )

	vip_amba_apb_write_with_wait_sequence seq;
	
	function new( string name="vip_amba_apb_master_write_with_wait_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_write_with_wait_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_write_with_wait_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [010] Description:
// READ with Wait States
//--------------------------------------------------------

class vip_amba_apb_master_read_with_wait_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_read_with_wait_test )

	vip_amba_apb_read_with_wait_sequence seq;
	
	function new( string name="vip_amba_apb_master_read_with_wait_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_read_with_wait_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_read_with_wait_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [011] Description:
// Basic WRITE READ with Wait States Test
//--------------------------------------------------------

class vip_amba_apb_master_write_read_with_wait_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_write_read_with_wait_test )

	vip_amba_apb_write_read_with_wait_sequence seq;
	
	function new( string name="vip_amba_apb_master_write_read_with_wait_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_write_read_with_wait_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

		
		`seq_make( seq, vip_amba_apb_write_read_with_wait_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [012] Description:
// Basic WRITE with Error Injection in READ Data of READ
//--------------------------------------------------------

class vip_amba_apb_master_read_err_inj_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_read_err_inj_test )

	vip_amba_apb_read_err_inj_sequence seq;
	
	function new( string name="vip_amba_apb_master_read_err_inj_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_read_err_inj_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
        
        `E_2_I(0,6)

	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );


		`seq_make( seq, vip_amba_apb_read_err_inj_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [013] Description:
// Test to check if PSELx is de-asserted after timeout 
// period in a WRITE transaction
//--------------------------------------------------------

class vip_amba_apb_master_write_pselx_timeout_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_write_pselx_timeout_test )

	vip_amba_apb_write_pselx_timeout_sequence seq;
	
	function new( string name="vip_amba_apb_master_write_pselx_timeout_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_write_pselx_timeout_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

	
		`seq_make( seq, vip_amba_apb_write_pselx_timeout_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [014] Description:
// Test to check if PSELx is de-asserted after timeout 
// period in a READ transaction
//--------------------------------------------------------

class vip_amba_apb_master_read_pselx_timeout_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_read_pselx_timeout_test )

	vip_amba_apb_read_pselx_timeout_sequence seq;
	
	function new( string name="vip_amba_apb_master_read_pselx_timeout_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_read_pselx_timeout_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

	
		`seq_make( seq, vip_amba_apb_read_pselx_timeout_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [015] Description:
// Test to assert the PRESETn during a Read
//--------------------------------------------------------

class vip_amba_apb_presetn_in_read_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_presetn_in_read_test )

	vip_amba_apb_presetn_in_read_sequence seq;
	
	function new( string name="vip_amba_apb_presetn_in_read_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_presetn_in_read_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

	
		`seq_make( seq, vip_amba_apb_presetn_in_read_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [016] Description:
// Test to assert the PRESETn during a Write, followed by
// a Read ( ideally the data should not have changed )
//--------------------------------------------------------

class vip_amba_apb_presetn_in_write_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_presetn_in_write_test )

	vip_amba_apb_presetn_in_write_sequence seq;
	
	function new( string name="vip_amba_apb_presetn_in_write_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_presetn_in_write_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
        
        `E_2_I(0,6)

	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

	
		`seq_make( seq, vip_amba_apb_presetn_in_write_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [017] Description:
// Test to assert the PRESETn during a Read with wait
// state
//--------------------------------------------------------

class vip_amba_apb_presetn_in_read_with_wait_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_presetn_in_read_with_wait_test )

	vip_amba_apb_presetn_in_read_with_wait_sequence seq;
	
	function new( string name="vip_amba_apb_presetn_in_read_with_wait_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_presetn_in_read_with_wait_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

	
		`seq_make( seq, vip_amba_apb_presetn_in_read_with_wait_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [018] Description:
// Test to assert the PRESETn during a Write with wait
// state and the perform a simple Read
//--------------------------------------------------------

class vip_amba_apb_presetn_in_write_with_wait_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_presetn_in_write_with_wait_test )

	vip_amba_apb_presetn_in_write_with_wait_sequence seq;
	
	function new( string name="vip_amba_apb_presetn_in_write_with_wait_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_presetn_in_write_with_wait_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

	
		`seq_make( seq, vip_amba_apb_presetn_in_write_with_wait_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass

//--------------------------------------------------------
// [019] Description:
// Test to assert inject the PSLERR during a simple READ
// transaction, and verify if 0's or X's were latched onto
// the RDATA bus
//--------------------------------------------------------

class vip_amba_apb_master_pslverr_for_read_test extends vip_amba_apb_base_test;

	`uvm_component_utils( vip_amba_apb_master_pslverr_for_read_test )

	vip_amba_apb_pslverr_for_read_sequence seq;
	
	function new( string name="vip_amba_apb_master_pslverr_for_read_test", uvm_component parent );
		super.new( name,parent );
		//$display( "NECCESSARY TEST CREATED--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "vip_amba_apb_master_pslverr_for_read_test Created" ), UVM_LOW )
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );

		//$display( "INSIDE TEST START OF SIM--------------" );
        `UVM_INFO_TST( "AMBA_APB_MASTER_TEST", $sformatf( "BUILD_PHASE Started" ), UVM_LOW )
		
		//uvm_config_db#( uvm_object_wrapper )::set( this,"env_comp[0].master_agent.master_sequencer.main_phase","default_sequence",vip_amba_apb_sanity_sequence::type_id::get() );
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
	endfunction

	task main_phase( uvm_phase phase );
        super.main_phase( phase );

	
		`seq_make( seq, vip_amba_apb_pslverr_for_read_sequence, 0 )
        `seq_fire( 0, seq )

	endtask

endclass
