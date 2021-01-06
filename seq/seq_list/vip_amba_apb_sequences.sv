// *******************************************************
// Date Created   : 30 November, 2019
// Author         : :P
// *******************************************************

//--------------------------------------------------------
// [001] Description:
// Sanity sequence which randomly generates a couple of
// basic transaction items.
//--------------------------------------------------------

class vip_amba_apb_sanity_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_sanity_sequence )

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_sanity_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();

        repeat( `COUNT )
        begin
		    vip_amba_apb_txn_item pkt;
		    pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );
		    //$display( "Inside the Sequence BODY-----------" );
            
            void'( this.randomize() with {
                                            Address.size() == 1;
            } );
	
            foreach( Address[i] )
		    begin
		    	start_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )

                pkt.txn_ADDR = Address[i];
                pkt.txn_WDATA = Data[i];
                pkt.txn_rd_wr = WR_RD[i];
                pkt.txn_STRB = WStrobe[i];

		    	finish_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
		    end
        end	
    endtask

endclass

//--------------------------------------------------------
// [002] Description:
// Basic READ Sequence
//--------------------------------------------------------

class vip_amba_apb_read_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_read_sequence )
    
    int presetn_initiate[$];
    int temp_wait_state[$];
    bit pslverr_err_inj;
    bit stand_alone_seq;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_read_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();
        
        repeat( `COUNT )
        begin
		    vip_amba_apb_txn_item pkt;
		    pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );
	
            if( Address.size() == 0 )
            begin
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Randomizing the packet manually!!!" ), UVM_LOW )
                void'( this.randomize() with {
                                                Address.size() == 1;
                                                txn_consecutive[0] == 0;
                } );
            end
	
            foreach( Address[i] )
		    begin
		    	start_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )

                pkt.txn_ADDR = Address[i];
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Address[%0d] : %h", i, Address[i] ), UVM_LOW )
                pkt.txn_WDATA = Data[i];
                pkt.txn_rd_wr = 0;
                pkt.txn_STRB = WStrobe[i];
                pkt.txn_consecutive = txn_consecutive[i];
                
                if( presetn_initiate.size() )
                begin
                    pkt.presetn_initiate.push_front( presetn_initiate.pop_back() );
                end

                if( read_txn_error )
                begin
                    pkt.read_txn_error = 'd1;
                end

                if( temp_wait_state.size() )
                begin
                    int temp_wait_value;

                    temp_wait_value = temp_wait_state[0];
                    env_config.wait_state.push_front( temp_wait_value );
                end

                pkt.pslverr_err_inj = pslverr_err_inj;

		    	finish_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
            end
           
            if( !stand_alone_seq )
            begin
                break;
            end
            else
            begin
                Address.delete();
            end
        end	
    endtask

endclass

//--------------------------------------------------------
// [003] Description:
// Basic WRITE Sequence
//--------------------------------------------------------

class vip_amba_apb_write_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_write_sequence )

    int presetn_initiate[$];
    int temp_wait_state[$];
    bit stand_alone_seq;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_write_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();
        
        repeat(`COUNT)
        begin
		    vip_amba_apb_txn_item pkt;
		    pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );

            if( Address.size() == 0 )
            begin
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Randomizing the packet manually!!!" ), UVM_LOW )
                void'( this.randomize() with {
                                                Address.size() == 1;
                                                txn_consecutive[0] == 0;
                } );
            end
	
            foreach( Address[i] )
		    begin
		    	start_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )

                pkt.txn_ADDR = Address[i];
                pkt.txn_WDATA = Data[i];
                pkt.txn_rd_wr = 1;
                pkt.txn_STRB = WStrobe[i];
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Write : txn_consecutive[%0d] = %0d", 0, txn_consecutive[0] ), UVM_LOW )
                pkt.txn_consecutive = txn_consecutive[i];
                
                if( presetn_initiate.size() )
                begin
                    pkt.presetn_initiate.push_front( presetn_initiate.pop_back() );
                end
                
                if( temp_wait_state.size() )
                begin
                    int temp_wait_value;

                    temp_wait_value = temp_wait_state[0];
                    env_config.wait_state.push_front( temp_wait_value );
                end

		    	finish_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
            end

            if( !stand_alone_seq )
            begin
                break;
            end
            else
            begin
                Address.delete();
            end
        end	
    endtask

endclass

//--------------------------------------------------------
// [004] Description:
// Basic WRITE READ Sequence
//--------------------------------------------------------

class vip_amba_apb_write_read_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_write_read_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_write_read_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();

        repeat( `COUNT )
        begin
            `uvm_create( seq_wr );
            void'( seq_wr.randomize() );
            `uvm_send( seq_wr );
            
            `uvm_create( seq_rd );
            seq_rd.Address[0] = seq_wr.Address[0];
            `uvm_send( seq_rd );
        end	
    endtask

endclass

//--------------------------------------------------------
// [005] Description:
// Basic Back to Back READ Sequence
//--------------------------------------------------------

class vip_amba_apb_read_to_read_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_read_to_read_sequence )

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_read_to_read_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();

        repeat( `COUNT )
        begin
		    vip_amba_apb_txn_item pkt;
		    pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );
	
            if( Address.size() == 0 )
                void'( this.randomize() with {
                                                Address.size() == 2;
                } );

            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )
		    start_item( pkt );
            foreach( Address[i] )
		    begin

                pkt.txn_ADDR_q[i] = Address[i];
                pkt.txn_WDATA_q[i] = Data[i];
                pkt.txn_rd_wr_q[i] = 0;
                pkt.txn_STRB_q[i] = WStrobe[i];
                pkt.txn_consecutive = 'd1;

            end
		    finish_item( pkt );
            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
        end	
    endtask

endclass

//--------------------------------------------------------
// [006] Description:
// Basic WRITE after WRITE Sequence
//--------------------------------------------------------

class vip_amba_apb_write_to_write_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_write_to_write_sequence )

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_write_to_write_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();

        repeat( `COUNT )
        begin
		    vip_amba_apb_txn_item pkt;
		    pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );

            if( Address.size() == 0 )
                void'( this.randomize() with {
                                                Address.size() == 2;
                } );

            txn_consecutive[0] = 1;
	
            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )
		    start_item( pkt );
            foreach( Address[i] )
		    begin

                pkt.txn_ADDR_q[i] = Address[i];
                pkt.txn_WDATA_q[i] = Data[i];
                pkt.txn_rd_wr_q[i] = 1;
                pkt.txn_STRB_q[i] = WStrobe[i];
                pkt.txn_consecutive = 'd1;

            end
		    finish_item( pkt );
            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
        end
	endtask

endclass

//--------------------------------------------------------
// [007] Description:
// Basic READ after WRITE consecutively Sequence
//--------------------------------------------------------

class vip_amba_apb_write_to_read_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_write_to_read_sequence )

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_write_to_read_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();

        repeat( `COUNT )
        begin
		    vip_amba_apb_txn_item pkt;
		    pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );

            void'( this.randomize() with {
                                            Address.size() == 2;
            } );

            void'( pkt.randomize() with {
                                            txn_ADDR_q.size() == Address.size();
            } );

            txn_consecutive[0] = 1;
	
            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )
		    start_item( pkt );
		    begin

                pkt.txn_ADDR_q[0] = Address[0];
                pkt.txn_rd_wr_q[0] = 1;
                pkt.txn_consecutive = 'd1;
                
                pkt.txn_ADDR_q[1] = Address[0];
                pkt.txn_rd_wr_q[1] = 0;
                pkt.txn_consecutive = 'd1;

            end
		    finish_item( pkt );
            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
        end
	endtask

endclass

//--------------------------------------------------------
// [008] Description:
// WRITE with wait states
//--------------------------------------------------------

class vip_amba_apb_write_with_wait_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_write_with_wait_sequence )

    vip_amba_apb_write_sequence seq_wr;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_write_with_wait_sequence Created." ), UVM_LOW )
	endfunction

	task body();
        super.body();

        // Get the env config file
		if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( uvm_root::get() ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf( "env_config[%0d]", env_num ) ),
							                                    .value( env_config ) ) )
			`uvm_fatal( "db_get_err","failed to get the env_config in sequence" )

        repeat( `COUNT )
        begin
            int temp_wait_value;

            `uvm_create( seq_wr );
            void'( seq_wr.randomize() with {
                                                txn_consecutive[0] == 1'b0;
            } );

            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "txn_consecutive[%0d] = %0d", 0, txn_consecutive[0] ), UVM_LOW )

            temp_wait_value = $urandom_range( 1, `PSELx_TIMEOUT-3 );
            env_config.wait_state.push_front( temp_wait_value );
            `uvm_info( "APB_MST_SEQ", $sformatf( " WAIT_STATE : %3d", temp_wait_value ), UVM_LOW )
            `uvm_send( seq_wr );
            `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "txn_consecutive[%0d] = %0d", 0, txn_consecutive[0] ), UVM_LOW )
        end
	endtask

endclass

//--------------------------------------------------------
// [009] Description:
// READ with wait states
//--------------------------------------------------------

class vip_amba_apb_read_with_wait_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_read_with_wait_sequence )

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_read_with_wait_sequence Created." ), UVM_LOW )
	endfunction

	task body();
		vip_amba_apb_txn_item pkt;

        super.body();

		if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( uvm_root::get() ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf( "env_config[%0d]", env_num ) ),
							                                    .value( env_config ) ) )
			`uvm_fatal( "DB_GET_ERR","Failed to get the env_config in sequence" )

        repeat( `COUNT )
        begin
            int temp_wait_value;

            pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );
	
            if( Address.size() == 0 )
                void'( this.randomize() with {
                                                Address.size() == 1;
                } );
	
            foreach( Address[i] )
		    begin
		    	start_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )

                pkt.txn_ADDR = Address[i];
                pkt.txn_WDATA = Data[i];
                pkt.txn_rd_wr = 0;
                pkt.txn_STRB = WStrobe[i];
                pkt.txn_consecutive = txn_consecutive[i];

                temp_wait_value = $urandom_range( 1, `PSELx_TIMEOUT-3 );
                env_config.wait_state.push_front( temp_wait_value );
                `uvm_info( "APB_MST_SEQ", $sformatf( " WAIT_STATE : %3d", temp_wait_value ), UVM_LOW )

		    	finish_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
            end
        end
	endtask

endclass

//--------------------------------------------------------
// [010] Description:
// Basic WRITE READ with wait state Sequence
//--------------------------------------------------------

class vip_amba_apb_write_read_with_wait_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_write_read_with_wait_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_write_read_with_wait_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
		if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( uvm_root::get() ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf( "env_config[%0d]", env_num ) ),
							                                    .value( env_config ) ) )
			`uvm_fatal( "DB_GET_ERR","Failed to get the env_config in sequence" )
    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin
            int temp_wait_value;

            temp_wait_value = $urandom_range( 1, `PSELx_TIMEOUT-3 );
            env_config.wait_state.push_front( temp_wait_value );

            `uvm_create( seq_wr );
            void'( seq_wr.randomize() );
            `uvm_send( seq_wr );
            
            temp_wait_value = $urandom_range( 1, `PSELx_TIMEOUT-3 );
            env_config.wait_state.push_front( temp_wait_value );

            `uvm_create( seq_rd );
            seq_rd.Address[0] = seq_wr.Address[0];
            `uvm_send( seq_rd );
        end
	endtask

endclass

//--------------------------------------------------------
// [011] Description:
// Basic WRITE with Error Injection in READ Data of READ
//--------------------------------------------------------

class vip_amba_apb_read_err_inj_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_read_err_inj_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_read_err_inj_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        `expected_err_count( 0, 6, 'd1*`COUNT )

        repeat( `COUNT )
        begin

            `uvm_create( seq_wr );
            void'( seq_wr.randomize() );
            `uvm_send( seq_wr );
            
            `uvm_create( seq_rd );
            seq_rd.Address[0] = seq_wr.Address[0];
            seq_rd.read_txn_error = 1;
            `uvm_send( seq_rd );
        end
	endtask

endclass

//--------------------------------------------------------
// [012] Description:
// Test to check if PSELx is de-asserted after timeout 
// period in a WRITE transaction
//--------------------------------------------------------

class vip_amba_apb_write_pselx_timeout_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_write_pselx_timeout_sequence )

    vip_amba_apb_write_sequence seq_wr;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_write_pselx_timeout_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin

            int temp_wait_value;

            `uvm_create( seq_wr );
            void'( seq_wr.randomize() with {
                                                txn_consecutive[0] == 1'b0;
            } );

            temp_wait_value = `PSELx_TIMEOUT + 'd30;
            env_config.wait_state.push_front( temp_wait_value );
            `uvm_info( "APB_MST_SEQ", $sformatf( " WAIT_STATE : %3d", temp_wait_value ), UVM_LOW )
            `uvm_send( seq_wr );
        end
	endtask

endclass

//--------------------------------------------------------
// [013] Description:
// Test to check if PSELx is de-asserted after timeout 
// period in a READ transaction
//--------------------------------------------------------

class vip_amba_apb_read_pselx_timeout_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_read_pselx_timeout_sequence )

    vip_amba_apb_txn_item pkt;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_read_pselx_timeout_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin

            int temp_wait_value;

            pkt = vip_amba_apb_txn_item::type_id::create( "pkt" );
	
            if( Address.size() == 0 )
                void'( this.randomize() with {
                                                Address.size() == 1;
                } );
	
            foreach( Address[i] )
		    begin
		    	start_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Start item called..." ), UVM_LOW )

                pkt.txn_ADDR = Address[i];
                pkt.txn_WDATA = Data[i];
                pkt.txn_rd_wr = 0;
                pkt.txn_STRB = WStrobe[i];
                pkt.txn_consecutive = txn_consecutive[i];

                temp_wait_value = `PSELx_TIMEOUT + 'd30;
                env_config.wait_state.push_front( temp_wait_value );
                `uvm_info( "APB_MST_SEQ", $sformatf( " WAIT_STATE : %3d", temp_wait_value ), UVM_LOW )

		    	finish_item( pkt );
                `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "Finish item called..." ), UVM_LOW )
            end
        end
	endtask

endclass

//--------------------------------------------------------
// [014] Description:
// Test to check if after PRESETn during Read
//--------------------------------------------------------

class vip_amba_apb_presetn_in_read_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_presetn_in_read_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_presetn_in_read_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin
            `uvm_create( seq_rd );
            void'( seq_rd.randomize() );
            
            seq_rd.presetn_initiate[0] = 1;

            `uvm_send( seq_rd );
        end
	endtask

endclass

//--------------------------------------------------------
// [015] Description:
// Test to check if after PRESETn during Write, then
// perform a simple Read
//--------------------------------------------------------

class vip_amba_apb_presetn_in_write_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_presetn_in_write_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_presetn_in_write_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin

            `uvm_create( seq_wr );
            void'( seq_wr.randomize() );
            seq_wr.presetn_initiate[0] = 1;

            `uvm_send( seq_wr );
            
            `uvm_create( seq_rd );
            seq_rd.Address[0] = seq_wr.Address[0];
            `uvm_send( seq_rd );
        end
	endtask

endclass

//--------------------------------------------------------
// [016] Description:
// Test to check if after PRESETn during Read with wait
// state
//--------------------------------------------------------

class vip_amba_apb_presetn_in_read_with_wait_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_presetn_in_read_with_wait_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_presetn_in_read_with_wait_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin
            
            `uvm_create( seq_rd );
            void'( seq_rd.randomize() );
            seq_rd.temp_wait_state[0] = $urandom_range( 1, `PSELx_TIMEOUT - 3 );
            seq_rd.presetn_initiate[0] = $urandom_range( 1, seq_rd.temp_wait_state[0] );
            `uvm_send( seq_rd );
        end
	endtask

endclass

//--------------------------------------------------------
// [017] Description:
// Test to check if after PRESETn during Write with wait
// state and then do a simple Read
//--------------------------------------------------------

class vip_amba_apb_presetn_in_write_with_wait_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_presetn_in_write_with_wait_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_presetn_in_write_with_wait_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin

            `uvm_create( seq_wr );
            void'( seq_wr.randomize() );
            seq_wr.temp_wait_state[0] = $urandom_range( 1, `PSELx_TIMEOUT - 3 );
            seq_wr.presetn_initiate[0] = $urandom_range( 1, seq_wr.temp_wait_state[0] );
            `uvm_send( seq_wr );
            
            `uvm_create( seq_rd );
            seq_rd.Address[0] = seq_wr.Address[0];
            `uvm_send( seq_rd );
        end
	endtask

endclass

//--------------------------------------------------------
// [018] Description:
// Test to assert inject the PSLERR during a simple READ
// transaction, and verify if 0's or X's were latched onto
// the RDATA bus
//--------------------------------------------------------

class vip_amba_apb_pslverr_for_read_sequence extends vip_amba_apb_base_sequence;

	`uvm_object_utils( vip_amba_apb_pslverr_for_read_sequence )

    vip_amba_apb_write_sequence seq_wr;
    vip_amba_apb_read_sequence seq_rd;

	function new( string name="" );
		super.new( name );
		//$display( "Base Sequence CREATED -------------" );
        `UVM_INFO_SEQ( "AMBA_APB_MASTER_SEQ",$sformatf( "vip_amba_apb_pslverr_for_read_sequence Created." ), UVM_LOW )
	endfunction

    task pre_body();
        super.pre_body();

    endtask

	task body();
        super.body();

        repeat( `COUNT )
        begin

            `uvm_create( seq_wr );
            void'( seq_wr.randomize() );
            `uvm_send( seq_wr );
            
            `uvm_create( seq_rd );
            seq_rd.Address[0] = seq_wr.Address[0];
            seq_rd.pslverr_err_inj = 'd1;
            `uvm_send( seq_rd );
        end
	endtask

endclass
