// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

// NOTE
// -------------------------------------------------------
// Here we will keep track of the component level progress.
// Features that have been implemented in the monitor:
// 1. Basic Scoreboardig
// 2. Read transaction PADDR, PWRITE values check in access phase.
// 3. Write transaction PADDR, PWRITE, PSTRB % PWDATA values check in access phase.
// 4. Use of error ids and their definition in the error definitios file.
// 5. Read transaction protocol check.
//  a. PSEL timeout check.
// 6. Write transaction protocol check.
//  a. PSEL timeout check.
//
// Features Pending Implementation:
// 1. Read transaction protocol check.
// 2. Write transaction protocol check.
// -------------------------------------------------------

class vip_amba_apb_monitor extends uvm_monitor;

	`uvm_component_utils( vip_amba_apb_monitor )
    
    uvm_analysis_port #( vip_amba_apb_txn_item ) cov_collector_port;

	virtual vip_amba_apb_interface monitor_bus_intf0;

    int env_num;
    
    // Monitor Masking Control Bits
    // ----------------------------
    bit [2:0] EID[];

    //// Monitor Error Expectation
    //// -------------------------
    //int EID_expected_count[$];
    //int EID_active_count[$];
    
    // Test Configuration
    // ------------------
    vip_amba_apb_test_config test_config;

	// Debug Log Handle
	// ----------------
	int monitor_debug;

    // Varibals Declarations
    // ---------------------
    logic [8-1:0] data_q[bit [32-1:0]]; // :P -> Byte Addressed Memory
    logic          data_rd_wr_q[$]; // :P -> 0 : READ, 1 : WRITE
    int read_transactions_initiated, read_transactions_completed, read_transactions_pending, read_timeouts;
    int write_transactions_initiated, write_transactions_completed, write_transactions_pending, write_timeouts;
    int resets_asserted, resets_deasserted;
    bit global_txn_ongoing;

	function new( string name="vip_amba_apb_monitor", uvm_component parent );
		super.new( name,parent );
		$display( "Monitor Inst New Called" );

        cov_collector_port = new( "cov_collector_port",this );
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );
		$display( "Monitor Inst Build Phase Called" );

        `ifdef VIP_MONITOR_DEBUG
		    if( !uvm_config_db#( int )::get( 	.cntxt( this ),
		    				 	.inst_name( "" ),
		    					.field_name( $sformatf( "monitor_debug[%0d]", env_num ) ),
		    					.value( monitor_debug ) ) )
		    	`uvm_fatal( "APB_MON_COM"," Failed to get the monitor_debug handle" )
        `endif
	endfunction

	function void connect_phase( uvm_phase phase );
		super.connect_phase( phase );
	endfunction
	
    function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
		
		// Get the Bus Interface
		if( !uvm_config_db#( virtual vip_amba_apb_interface )::get( 	.cntxt( this ),
										.inst_name( "" ),
										.field_name( $sformatf( "bus_intf0[%0d]", env_num ) ),
										.value( monitor_bus_intf0 ) ) )
			`uvm_fatal( "APB_MON_COM", " Failed to get the UVM Bus Interface" )
		
        // Get the test config file
        // ------------------------
		if( !uvm_config_db#( vip_amba_apb_test_config )::get( 	.cntxt( this ),
						 	                                    .inst_name( "" ),
							                                    .field_name( $sformatf( "test_config[%0d]", env_num ) ),
							                                    .value( test_config ) ) )
        begin
			`uvm_fatal( "DB_GET_ERR","Failed to get the test_config in sequence" )
            EID = new[1000];
        end
        else
        begin
            // BUG TODO
            EID = test_config.EID;
        end

	endfunction

    task main_phase( uvm_phase phase );
		phase.raise_objection( this );

        `mdisplay( " Monitor_Master & Monitor_Slave Task Started...",0 )

        fork
            begin
                monitor_preset_counter();
            end
            forever
            begin
                fork
                    begin
                        @( posedge `PRESETn );
                        `mdisplay( $sformatf( " PRESETn signal de-asserted!" ), 0 )
                    end
                    monitor_master_task();
                    monitor_runtime_checks();
                    monitor_transaction_counter();
                    //monitor_slave_task();
                    monitor_scorboarding();
                join_none
                
                @( negedge `PRESETn );
                `mdisplay( $sformatf( " PRESETn signal asserted!" ), 0 )
                disable fork;
                global_txn_ongoing = 0;
            end
        join_none

		phase.drop_objection( this );
    endtask

    // Extract Phase
    // -------------
    function void extract_phase( uvm_phase phase );
		super.extract_phase( phase );
		
        `mdisplay( $sformatf( " [ AMBA_APB_EID_ERR ] Extract Phase Called! Error Count Checking ---" ), 0 )

        // Error Expectation Checking Logic
        // --------------------------------
        foreach( test_config.EID_expected_count[i] )
        begin
            if( test_config.EID_expected_count[i] != test_config.EID_actual_count[i] )
            begin
                `uvm_error( "APB_MON_COM", $sformatf( " [ AMBA_APB_EID_ERR ] Total number of expected errors and received errors mismatch : EID [ %0d ] - Expected ( %0d ) vs Received ( %0d ) | EID[ %0d ] = %2d", i, test_config.EID_expected_count[i], test_config.EID_actual_count[i], i, test_config.EID[i] ) )
            end
            else
            begin
                `mdisplay( $sformatf( " [ AMBA_APB_EID_ERR ] Total number of expected errors and received errors matched  : EID [ %0d ] - Expected ( %0d ) vs Received ( %0d ) | EID[ %0d ] = %2d", i, test_config.EID_expected_count[i], test_config.EID_actual_count[i], i, test_config.EID[i] ), 0 )
            end
        end
        
        // Transaction Expectation Result
        // ------------------------------
        $display( $sformatf( "# " ) );
        $display( $sformatf( "# ==================================================================" ) );
        $display( $sformatf( "# =                  Monitor Transaction Details                   =" ) );
        $display( $sformatf( "# ==================================================================" ) );
        $display( $sformatf( "#  Total Read Transactions Initiated  : %0d                         ", read_transactions_initiated ) );
        $display( $sformatf( "#  Total Read Transactions Finished   : %0d                         ", read_transactions_completed ) );
        $display( $sformatf( "#  Total Read Transactions Timeouts   : %0d                         ", read_timeouts ) );
        $display( $sformatf( "# ==================================================================" ) );
        $display( $sformatf( "#  Total Write Transactions Initiated : %0d                          ", write_transactions_initiated ) );
        $display( $sformatf( "#  Total Write Transactions Finished  : %0d                          ", write_transactions_completed ) );
        $display( $sformatf( "#  Total Write Transactions Timeouts  : %0d                          ", write_timeouts ) );
        $display( $sformatf( "# ==================================================================" ) );
        $display( $sformatf( "#  Total PRESETn Assertions           : %0d                          ", resets_asserted ) );
        $display( $sformatf( "#  Total PRESETn De-Assertions        : %0d                          ", resets_deasserted ) );
        $display( $sformatf( "# ==================================================================" ) );


	endfunction
    

    // Monitor Scorboarding Task
    task monitor_scorboarding();
    begin
        vip_amba_apb_txn_item pkt_item;

        forever
        begin
            `mdisplay( $sformatf( " Waiting for read and write data queues to become non zero" ), 0 )
            wait( data_rd_wr_q.size() );
            `mdisplay( $sformatf( " Done waiting for read and write data queues to become non zero" ), 0 )

            pkt_item = new;
            pkt_item.txn_ADDR = `PADDR;
            pkt_item.txn_rd_wr = data_rd_wr_q[0];
            
            if( !data_rd_wr_q[0] ) // :P -> READ
            begin
                bit [4-1:0] mem_exist;

                begin
                    logic [32-1:0] temp_data;

                    if( `PSLVERR !== 1 )
                    begin
                        foreach( `PSTRB[i] ) // Simply usgin PSTRB to iterate through the number of bytes in memory per base address
                        begin
                            if( data_q.exists( `PADDR+i ) )
                            begin
                                temp_data[i*8+:8] = data_q[`PADDR+i];
                            end
                            else
                            begin
                                temp_data[i*8+:8] = 'dx;
                            end
                        end
                    end
                    else if( `PSLVERR === 'd1 )
                    begin
                        if( `PSLVERR_RDATA_VALUE == 0 )
                        begin
                            temp_data = 'd0;
                        end
                        else
                        begin
                            temp_data = 'dx;
                        end
                    end

                    // Coverage pkt Trasnmission
                    // -------------------------
                    pkt_item.txn_slverr = `PSLVERR;
                    pkt_item.txn_slave_sel = `PSELx;
                    pkt_item.txn_RDATA = `PRDATA;

                    if( `PSLVERR === 'd1 && ( `PRDATA !== temp_data ) )
                    begin
                        `AMBA_APB_EID_8
                    end
                    else if( temp_data === `PRDATA )
                    begin
                        if( `PSLVERR )
                        begin
                            `mdisplay( $sformatf( " [SB] READ Data Match : Scoreboard and Slave Read ( When PSLVERR is High ) ( Expected Data : %h , Received Data : %h )", temp_data, `PRDATA ), 0 )
                        end
                        else
                        begin
                            `mdisplay( $sformatf( " [SB] READ Data Match : Scoreboard and Slave Read ( Expected Data : %h , Received Data : %h )", temp_data, `PRDATA ), 0 )
                        end
                    end
                    else
                    begin
                        `mdisplay( $sformatf( " [SB] READ Data Mismatch : Expected Data - %h, Received Data - %h", temp_data, `PRDATA ), 0 )
                        `AMBA_APB_EID_6
                    end
                end
                //else
                //begin
                //    //`AMBA_APB_EID_7 TODO
                //    `mdisplay( $sformatf( " [SB] READ Data on an uninitialised or unwritten memory location" ), 0 )
                //end
            end
            else if( data_rd_wr_q[0] ) // :P -> WRITE
            begin
                logic [32-1:0] temp_data;

                foreach( `PSTRB[i] )
                begin
                    if( `PSTRB[i] )
                    begin
                        data_q[`PADDR+i] = `PWDATA[i*8+:8];
                        temp_data[i*8+:8] = `PWDATA[i*8+:8];
                    end
                end

                // Coverage pkt Trasnmission
                // -------------------------
                pkt_item.txn_slverr = `PSLVERR;
                pkt_item.txn_slave_sel = `PSELx;
                pkt_item.txn_WDATA = `PWDATA;
                pkt_item.txn_STRB = `PSTRB;

                `mdisplay( $sformatf( " [SB] WRITE Data to the Scroeboard's Memory" ), 0 )
                `mdisplay( $sformatf( " [SB] Data Written : %h", temp_data ), 0 )
            end

            cov_collector_port.write( pkt_item );

            data_rd_wr_q.delete();
        end
    end
    endtask

    // Monitor Master Task
    task monitor_master_task();
    begin
        logic [32-1:0]  master_address;
        logic [4-1:0]   master_strobe;
        logic [32-1:0]  master_data;
        logic           master_rd_wr;

        bit             check_for_write;
        bit             check_for_read;
        bit             psel_set;
        bit             direct_to_access;

        forever
        begin
            direct_to_access = 0;

            fork
                begin
                    psel_timeout_check(); // PSELx Timeout Check
                end
                forever
                begin
                    @( posedge `PCLK ); // :P Sampling on positive edge
                    //`mdisplay( $sformatf( " [BFM] posedge" ), 0 )

                    if( `PSELx )
                    begin
                        `mdisplay( $sformatf( " [BFM] PSELx Sampled" ), 0 )
                        check_for_read = 0;
                        check_for_write = 0;

                        //if( !direct_to_access ) // :P -> If True,  Idle to Setup else Access to Setup
                        //begin
                        //    @( posedge `PCLK ); 
                        //    direct_to_access = 1;
                        //end

                        begin
                            master_address = `PADDR;
                            master_rd_wr = `PWRITE;
                            if( master_rd_wr )
                            begin
                                `mdisplay( $sformatf( " [BFM] Write detected as High" ), 0 )
                                master_data = `PWDATA;
                                master_strobe = `PSTRB;
                                check_for_write = 1;
                                check_for_read = 0;
                            end
                            else
                            begin
                                `mdisplay( $sformatf( " [BFM] Read detected as High" ), 0 )
                                check_for_write = 0;
                                check_for_read = 1;
                            end
                            
                            `mdisplay( $sformatf( " [BFM] Inside Access Phase" ), 0 )
                            @( posedge `PCLK ); // Moving into Access Phase
                        end

                        forever
                        begin
                            if( !(master_address === `PADDR && master_data === `PWDATA && master_strobe === `PSTRB && master_rd_wr === `PWRITE ) && check_for_write ) // :P CHECK
                            begin
                                if( master_address !== `PADDR )
                                begin
                                    `AMBA_APB_EID_1
                                end
                                if( master_data !== `PWDATA )
                                begin
                                    `AMBA_APB_EID_2
                                end
                                if( master_strobe !== `PSTRB)
                                begin
                                    `AMBA_APB_EID_3
                                end
                                if( master_rd_wr !== `PWRITE )
                                begin
                                    `AMBA_APB_EID_4
                                end

                                `mdisplay( $sformatf( " [BFM] Write break called" ), 0 )
                            end
                            
                            if( check_for_write && `PREADY && `PENABLE )
                            begin
                                `mdisplay( $sformatf( " [BFM] Write PUSHED" ), 0 )
                                data_rd_wr_q.push_front( `PWRITE );
                                break;
                            end
                            
                            if( !( master_address === `PADDR && master_rd_wr === `PWRITE ) && check_for_read ) // :P CHECK
                            begin
                                if( master_address !== `PADDR )
                                begin
                                    `AMBA_APB_EID_1
                                end
                                if( master_rd_wr !== `PWRITE )
                                begin
                                    `AMBA_APB_EID_4
                                end

                                `mdisplay( $sformatf( " [BFM] Read break called" ), 0 )
                            end
                            
                            if( check_for_read && `PREADY && `PENABLE )
                            begin
                                `mdisplay( $sformatf( " [BFM] Read PUSHED" ), 0 )
                                data_rd_wr_q.push_front( `PWRITE );
                                break;
                            end
                            
                            @( posedge `PCLK ); // :P Still in Access Phase
                        end
                    end
                end
                forever
                begin
                    @( posedge `PCLK );
                    if( `PSELx )
                    begin
                        break;
                    end
                end
            join_any

            forever
            begin
                @( posedge `PCLK );
                if( !`PSELx )
                begin
                    @( negedge `PCLK );
                    break;
                end
            end
            // :P Disable this transaction iteration because PSELx is low
            //    again
            disable fork;
        end
    end
    endtask

    // Monitor Runtime Checks
    task monitor_runtime_checks();
        fork
            // Setup Phase Check
            forever
            begin
                @( posedge `PCLK );
                if( `PSELx && !`PENABLE )
                begin
                    @( posedge `PCLK );
                    if( !( `PSELx && `PENABLE ) )
                    begin
                        `AMBA_APB_EID_12
                    end
                end
            end
            // Minimim 2 Clocks PSELx Check
            forever
            begin
                @( posedge `PCLK );
                if( `PSELx && !`PENABLE )
                begin
                    if( !`PSELx )
                    begin
                        `AMBA_APB_EID_11
                    end
                end
            end
            // PENABLE cannot be high without PSELx Asserted
            forever
            begin
                @( posedge `PCLK );
                if( !`PSELx && `PENABLE )
                begin
                    `AMBA_APB_EID_10
                end
            end
            // PSTRB must be low for READ transfers
            forever
            begin
                @( posedge `PCLK );
                if( `PSELx && !`PENABLE )
                begin
                    if( !`PWRITE && `PSTRB )
                    begin
                        `AMBA_APB_EID_9                       
                    end
                end
            end
            // Runnaway PREADY Received, ie unexpected PREADY
            forever
            begin
                @( posedge `PCLK );
                if( global_txn_ongoing && `PREADY && !( `PSELx && `PENABLE ) )
                begin
                    `AMBA_APB_EID_13
                end
            end
        join
    endtask
 
    // Monitor Transaction Counter
    task monitor_transaction_counter();
        int timeout_counter;
        bit rd, wr;
        bit txn_ongoing;

        fork
            // Transaction Counter
            forever
            begin
                @( posedge `PCLK );
                if( `PSELx && `PENABLE )
                begin
                    if( `PWRITE && !txn_ongoing )
                    begin
                        write_transactions_initiated++;
                        wr = 1;
                        rd = 0;
                        timeout_counter++;
                        txn_ongoing = 1;
                        global_txn_ongoing = 1;
                    end
                    if( !`PWRITE && !txn_ongoing )
                    begin
                        read_transactions_initiated++;
                        wr = 0;
                        rd = 1;
                        timeout_counter++;
                        txn_ongoing = 1;
                        global_txn_ongoing = 1;
                    end
                    if( `PWRITE && `PREADY )
                    begin
                        write_transactions_completed++;
                        wr = 0;
                        rd = 0;
                        timeout_counter = 0;
                        txn_ongoing = 0;
                        global_txn_ongoing = 0;
                    end
                    if( !`PWRITE && `PREADY )
                    begin
                        read_transactions_completed++;
                        wr = 0;
                        rd = 0;
                        timeout_counter = 0;
                        txn_ongoing = 0;
                        global_txn_ongoing = 0;
                    end
                end
                else if( !`PSELx && !`PENABLE && txn_ongoing )
                begin
                    //if( timeout_counter == ( `PSELx_TIMEOUT + 'd1 ) && txn_ongoing ) // TODO Test Later
                    begin
                        timeout_counter = 0;
                        if( rd )
                        begin
                            read_timeouts++;
                        end
                        if( wr )
                        begin
                            write_timeouts++;
                        end
                        wr = 0;
                        rd = 0;
                        txn_ongoing = 0;
                        global_txn_ongoing = 0;
                    end
                end
            end
        join_none
    endtask

    // Monitor PRESETn Counter
    task monitor_preset_counter();
        fork
            // Reset Assertion Counter
            forever
            begin
                @( negedge `PRESETn );
                resets_asserted++;
            end
            // Reset De-Assertion Counter
            forever
            begin
                @( posedge `PRESETn );
                resets_deasserted++;
            end
        join_none
    endtask

    // Monitor Slave Task TODO Maybe I won't need this
    task monitor_slave_task();
    begin
        logic [32-1:0]  slave_address;
        logic [4-1:0]   slave_strobe;
        logic [32-1:0]  slave_data;

        forever
        begin
            @( negedge `PCLK ); // :P Sampling on positive edge in order to keep synchronization simple
        end
    end
    endtask

    task psel_timeout_check();
        int psel_timeout_counter;

        psel_timeout_counter = 0;

        `mdisplay( $sformatf( " PSEL Timeout Check Started..." ), 0 )

        forever
        begin
            @( posedge `PCLK );

            if( `PSELx && `PENABLE && `PREADY )
            begin
                psel_timeout_counter = 0;
            end
            else if( `PSELx )
            begin
                if( psel_timeout_counter == (`PSELx_TIMEOUT+1) )
                begin
                    psel_timeout_counter = 0;

                    `AMBA_APB_EID_5
                    break;
                end
                else
                begin
                    psel_timeout_counter++;
                end
            end
            else
            begin
                psel_timeout_counter = 0;
            end
        end
    endtask

endclass

