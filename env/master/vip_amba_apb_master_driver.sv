// *******************************************************
// Date Created   : 31 May, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_master_driver extends uvm_driver#( vip_amba_apb_txn_item );
	
	`uvm_component_utils( vip_amba_apb_master_driver )

	virtual vip_amba_apb_interface driver_bus_intf0;
	virtual vip_amba_apb_bridge_bfm_interface master_bfm_intf0;

    // Environment Instance Number
    // ---------------------------
    int env_num;

    vip_amba_apb_env_config env_config;

    // Driver Variable Declarations
    // ----------------------------
    bit txn_consecutive_prev; // Holds the previous pkt's value for txn_consecutive which will determine if the new pkt will be driven continously or not.
    logic [32-1:0] rdata_local_aa[int];
    logic [32-1:0] pslverr_local_aa[int];
    int ready_rcvd;
    bit got_timeout;
    bit got_reset;

	
	// Debug Log Handle
	int master_debug;

	function new( string name="vip_amba_apb_master_driver", uvm_component parent );
		super.new( name,parent );
		//$display( "Driver Newed" );
	endfunction

	function void build_phase( uvm_phase phase );
		super.build_phase( phase );
		//$display( "Driver Built" );

        // :P TODO
        `ifdef VIP_MASTER_DEBUG
		    if( !uvm_config_db#( int )::get( 	.cntxt( this ),
		    				 	.inst_name( "" ),
		    					.field_name( $sformatf( "master_debug[%0d]", env_num ) ),
		    					.value( master_debug ) ) )
            begin
		    	`uvm_fatal( "APB_MST_DRV"," Failed to get the master_debug handle" )
            end

        `endif
	endfunction

	function void start_of_simulation_phase( uvm_phase phase );
		super.start_of_simulation_phase( phase );
		
		// Get the Bus Interface
		if( !uvm_config_db#( virtual vip_amba_apb_interface )::get( 	.cntxt( this ),
										.inst_name( "" ),
										.field_name( $sformatf( "bus_intf0[%0d]", env_num ) ),
										.value( driver_bus_intf0 ) ) )
        begin
			`uvm_fatal( "APB_MST_DRV", " Failed to get the UVM Bus Interface" )
        end
		
		if( !uvm_config_db#( virtual vip_amba_apb_bridge_bfm_interface )::get( 	.cntxt( this ),
											.inst_name( "" ),
											.field_name( $sformatf ( "master_bfm_intf0[%0d]", env_num ) ),
											.value( master_bfm_intf0 ) ) )
        begin
			`uvm_fatal( "APB_MST_DRV", " Failed to get the UVM BFM Interface" )
        end

        if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( this ),
					 	                                        .inst_name( "*" ),
						                                        .field_name( $sformatf( "env_config[%0d]", env_num ) ),
						                                        .value( env_config ) ) )
        begin
            `uvm_fatal( "APB_SLV_BFM", $sformatf( " Failed to access DB env config object" ) );
        end
	endfunction

	task reset_phase( uvm_phase phase );
		phase.raise_objection( this );
		
        // Initial Reset Logic

		phase.drop_objection( this );
	endtask

	task main_phase( uvm_phase phase );

		vip_amba_apb_txn_item pkt;
		phase.raise_objection( this );
		
        // Waiting for the Initial Reset to De-Assert
        // ------------------------------------------
        wait( !driver_bus_intf0.PRESETn );
        `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Initial Reset Asserted!" ), UVM_LOW )
        wait( driver_bus_intf0.PRESETn );
        `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Initial Reset De-Asserted!" ), UVM_LOW )

		fork : DRIVER_GLUE_LOGIC_DUT_SPECIFIC
			forever
			begin
                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Waiting for packet!" ), UVM_LOW )
				seq_item_port.get_next_item( pkt );
                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Rcvd a packet!" ), UVM_LOW )

                // Driving Logic
                //display_pkt( pkt );
                
                // Error Injection Conditions
                // --------------------------
                if( pkt.read_txn_error )
                begin
                    env_config.error_read_data.push_front( 'd1 );
                    env_config.data = $urandom;
                end
                
                if( pkt.pslverr_err_inj )
                begin
                    env_config.pslverr_err_inj.push_front( 'd1 );
                end

                if( pkt.txn_consecutive )
                begin
                    ready_rcvd = 0;
                    master_glue_logic_driver_task( pkt );

                    wait( ready_rcvd == pkt.txn_ADDR_q.size() );
                    `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Consecutive Received All The Expected Number Of READY Assertions!" ), UVM_LOW )
                    if( pkt.get_data )
                    begin
                        foreach( pkt.txn_ADDR_q[i] )
                        begin
                            if( !pkt.txn_rd_wr_q[i] ) // Read
                            begin
                                if( rdata_local_aa.exists( i ) )
                                begin
                                    pkt.txn_RDATA_q[i] = rdata_local_aa[i];
                                end
                                else
                                begin
                                    pkt.txn_RDATA_q[i] = 'd0;
                                end
                            end
                            if( pslverr_local_aa.exists( i ) )
                            begin
                                pkt.txn_slverr_q[i] = pslverr_local_aa[i];
                            end
                            else
                            begin
                                pkt.txn_slverr_q[i] = 'd0;
                            end
                        end
                        pslverr_local_aa.delete();
                        rdata_local_aa.delete();
                        ready_rcvd = 0;
                    end
                    repeat( 2 )
                    begin
                        @( posedge driver_bus_intf0.PCLK );
                    end
                end
                else
                begin
                    ready_rcvd = 0;
                    master_glue_logic_driver_task( pkt );
                    
                    wait( ready_rcvd == 1 || got_timeout || got_reset );
                    ready_rcvd = 0;
                    `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Non Consecutive Received All The Expected Number Of READY Assertions!" ), UVM_LOW )

                    if( pkt.get_data && !pkt.txn_rd_wr && ready_rcvd == 1 )
                    begin
                        wait( rdata_local_aa.size() );

                        if( rdata_local_aa.exists( 0 ) )
                        begin
                            pkt.txn_RDATA = rdata_local_aa[0];
                        end
                        else
                        begin
                            pkt.txn_RDATA = 'd0;
                        end
                        if( pslverr_local_aa.exists( 0 ) )
                        begin
                            pkt.txn_slverr = pslverr_local_aa[0];
                        end
                        else
                        begin
                            pkt.txn_slverr = 'd0;
                        end
                        pslverr_local_aa.delete();
                        rdata_local_aa.delete();
                    end
                    repeat( 2 )
                    begin
                        @( posedge driver_bus_intf0.PCLK );
                    end
                end

                // TODO Sending this updated transaction back through RSP is still pending

				seq_item_port.item_done(rsp);
                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Item Done called..." ), UVM_LOW )
			end
            begin
                //slave_model_task(); // TODO : More Features Needed. Will someday be connected to a task based Master BFM.
            end
			begin
				//#10000;
				phase.drop_objection( this );
			end
		join : DRIVER_GLUE_LOGIC_DUT_SPECIFIC
	endtask

    function void display_pkt( ref vip_amba_apb_txn_item pkt );
        $display( ":P ---------------------- Packet Details" );
        $display( "   txn_ADDR      ::  %h",pkt.txn_ADDR );                
        $display( "   txn_WDATA     ::  %h",pkt.txn_WDATA );
        $display( "   txn_RDATA     ::  %h",pkt.txn_RDATA );
        $display( "   txn_rd_wr     ::  %d",pkt.txn_rd_wr );
        $display( "   txn_STRB      ::  %b",pkt.txn_STRB );
        $display( "   txn_slave_sel ::  %d",pkt.txn_slave_sel );
        $display( "   txn_slverr    ::  %d",pkt.txn_slverr );
        $display( "\n" );
    endfunction

    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    // USER_MODIFYABLE CODE REGION ( GLUE LOGIC PORTION )
    // --------------------------------------------------
    // Glue Logic will connect the Seqr-Driver to the
    // DUT/BFM.
    // ++++++++++++++++++++++++++++++++++++++++++++++++++


    // Master CPU Driver task to initiate a transaction to the APB Master : NOTE This is a DUT/BFM specific logic. So the person integrating this is responsible for coding this logic.
    // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    task automatic master_glue_logic_driver_task( vip_amba_apb_txn_item pkt );
        bit kill_fork;
        bit reset_detected;
        bit not_first_itr;

        `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Driving a packet..." ), UVM_LOW )

        //display_pkt( pkt );

        got_reset = 0;

        fork
            begin : SIGNAL_DRIVING

                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Forever loops!" ), UVM_LOW )
                got_timeout = 0;

                fork
                    begin
                        if( pkt.presetn_initiate.size() && !kill_fork && !reset_detected )
                        begin
                            reset_detected = 1;
                            `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Resetn Detected! [ %0d ]", pkt.presetn_initiate[0] ), UVM_LOW )
                            
                            repeat( pkt.presetn_initiate[0] + 2 )
                            begin
                                @( posedge driver_bus_intf0.PCLK );
                            end
                            `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Kill fork asserted! [ %0d ]", pkt.presetn_initiate[0] ), UVM_LOW )
                            kill_fork = 1;
                            got_reset = 1;
                        end
                    end
                join_none

                //if( !txn_consecutive_prev )
                //    @( posedge driver_bus_intf0.PCLK );
                //else
                //    ; // Do Nothing

                if( pkt.txn_consecutive )
                begin
                    `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Inside Consecutive Transactions Block" ), UVM_LOW )
                    foreach( pkt.txn_ADDR_q[i] )
                    begin
                        forever
                        begin
                            if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done && not_first_itr )
                            begin
                                break;
                            end
                            else
                            begin
                                if( driver_bus_intf0.apb_ready_for_txn )
                                begin
                                    @( posedge driver_bus_intf0.PCLK );
                                    break;
                                end
                                else
                                begin
                                    @( posedge driver_bus_intf0.PCLK );
                                end
                            end
                        end

                        not_first_itr = 1;

                        begin
                            if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done )
                            begin
                                driver_bus_intf0.from_cpu_slave_sel <= #1 1;
                            end
                            else if( driver_bus_intf0.from_cpu_slave_sel !== 'd1 )
                            begin
                                driver_bus_intf0.from_cpu_slave_sel <= #1 1;
                                @( negedge driver_bus_intf0.PCLK );
                            end
                            else
                            begin
                                driver_bus_intf0.from_cpu_slave_sel <= #1 1;
                            end
                            driver_bus_intf0.from_cpu_rd_wr <= #1 pkt.txn_rd_wr_q[i];
                            driver_bus_intf0.from_cpu_address <= #1 pkt.txn_ADDR_q[i];
                            if( pkt.txn_rd_wr_q[i] )
                            begin
                                driver_bus_intf0.from_cpu_wr_STRB <= #1 pkt.txn_STRB_q[i];
                                driver_bus_intf0.from_cpu_wr_WDATA <= #1 pkt.txn_WDATA_q[i];
                                `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                                `uvm_info( "APB_DRV_MST", " APB Write Transaction", UVM_LOW )
                                `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                            end
                            else
                            begin
                                `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                                `uvm_info( "APB_DRV_MST", " APB Read Transaction", UVM_LOW )
                                `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                            end
                            
                            driver_bus_intf0.from_cpu_valid_txn <= #1 1;

                            @( posedge driver_bus_intf0.PCLK );

                            driver_bus_intf0.from_cpu_valid_txn <= #1 0;
                            driver_bus_intf0.from_cpu_slave_sel <= #1 0;
                        end
                        
                        fork
                            if( !pkt.txn_rd_wr_q[i] )
                            begin
                                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Waiting for READ READY!" ), UVM_LOW );
                                forever
                                begin
                                    if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done )
                                    begin
                                        rdata_local_aa[i] = driver_bus_intf0.to_cpu_RDATA;
                                        pslverr_local_aa[i] = driver_bus_intf0.to_cpu_txn_err;
                                        ready_rcvd++;
                                        break;
                                    end
                                    else
                                    begin
                                        @( posedge driver_bus_intf0.PCLK );
                                    end
                                end
                                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "READY for Read RCVD!" ), UVM_LOW );
                            end
                            else
                            begin
                                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Waiting for WRITE READY!" ), UVM_LOW );
                                forever
                                begin
                                    if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done )
                                    begin
                                        pslverr_local_aa[i] = driver_bus_intf0.to_cpu_txn_err;
                                        ready_rcvd++;
                                        break;
                                    end
                                    else
                                    begin
                                        @( posedge driver_bus_intf0.PCLK );
                                    end
                                end
                                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "READY for Write RCVD!" ), UVM_LOW );
                            end
                        join_none
                    end
                end
                else
                begin
                    `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Inside NON Consecutive Transactions Block" ), UVM_LOW )
                    forever
                    begin
                        if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done && not_first_itr )
                        begin
                            break;
                        end
                        else
                        begin
                            if( driver_bus_intf0.apb_ready_for_txn )
                            begin
                                @( posedge driver_bus_intf0.PCLK );
                                break;
                            end
                            else
                            begin
                                @( posedge driver_bus_intf0.PCLK );
                            end
                        end
                    end

                    not_first_itr = 1;

                    begin
                        if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done )
                        begin
                            driver_bus_intf0.from_cpu_slave_sel <= #1 1;
                        end
                        else if( driver_bus_intf0.from_cpu_slave_sel !== 'd1 )
                        begin
                            driver_bus_intf0.from_cpu_slave_sel <= #1 1;
                            @( negedge driver_bus_intf0.PCLK );
                        end
                        else
                        begin
                            driver_bus_intf0.from_cpu_slave_sel <= #1 1;
                        end
                        driver_bus_intf0.from_cpu_rd_wr <= #1 pkt.txn_rd_wr;
                        driver_bus_intf0.from_cpu_address <= #1 pkt.txn_ADDR;
                        if( pkt.txn_rd_wr )
                        begin
                            driver_bus_intf0.from_cpu_wr_STRB <= #1 pkt.txn_STRB;
                            driver_bus_intf0.from_cpu_wr_WDATA <= #1 pkt.txn_WDATA;
                            `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                            `uvm_info( "APB_DRV_MST", " APB Write Transaction", UVM_LOW )
                            `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                        end
                        else
                        begin
                            `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                            `uvm_info( "APB_DRV_MST", " APB Read Transaction", UVM_LOW )
                            `uvm_info( "APB_DRV_MST", " --------------------------", UVM_LOW )
                        end
                        
                        driver_bus_intf0.from_cpu_valid_txn <= #1 1;

                        @( posedge driver_bus_intf0.PCLK );

                        driver_bus_intf0.from_cpu_valid_txn <= #1 0;
                        driver_bus_intf0.from_cpu_slave_sel <= #1 0;
                    end
                    
                    fork
                        if( !pkt.txn_rd_wr )
                        begin
                            `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Waiting for READ READY!" ), UVM_LOW );
                            forever
                            begin
                                if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done )
                                begin
                                    rdata_local_aa[0] = driver_bus_intf0.to_cpu_RDATA;
                                    pslverr_local_aa[0] = driver_bus_intf0.to_cpu_txn_err;
                                    ready_rcvd++;
                                    break;
                                end
                                else
                                begin
                                    @( posedge driver_bus_intf0.PCLK );
                                end
                            end
                            `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "READY for Read RCVD!" ), UVM_LOW );
                        end
                        else
                        begin
                            `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Waiting for WRITE READY!" ), UVM_LOW );
                            forever
                            begin
                                if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done )
                                begin
                                    pslverr_local_aa[0] = driver_bus_intf0.to_cpu_txn_err;
                                    ready_rcvd++;
                                    break;
                                end
                                else
                                begin
                                    @( posedge driver_bus_intf0.PCLK );
                                end
                            end
                            `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "READY for Write RCVD!" ), UVM_LOW );
                        end
                    join_none
                end
                if( pkt.txn_consecutive )
                begin
                    wait( ready_rcvd == pkt.txn_ADDR_q.size() );
                end
                else
                begin
                    wait( ready_rcvd == 1 );
                end
                if( kill_fork )
                begin
                    wait( kill_fork == 0 );
                end
                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Signal Driving Thread Done!" ), UVM_LOW )
            end : SIGNAL_DRIVING
            begin : PRESETN_LOOP

                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Waiting for kill_fork!" ), UVM_LOW )
                wait( kill_fork == 'd1 );
                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "PRESETn Asserted" ), UVM_LOW )
                driver_bus_intf0.PRESETn <= #4 0; // TODO Configurable Delayed PRESETn Assertion
                `uvm_info( "APB_DRV_MST", " PRESETn Asserted!", UVM_LOW )

                repeat( 20 )
                begin
                    @( posedge driver_bus_intf0.PCLK );
                end

                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "PRESETn De-asserted" ), UVM_LOW )
                driver_bus_intf0.PRESETn <= #1 1;
                `uvm_info( "APB_DRV_MST", " PRESETn De-Asserted!", UVM_LOW )

            end : PRESETN_LOOP
            begin : PRDATA_SAMPLING
                forever
                begin
                    @( posedge driver_bus_intf0.PCLK );
                    if( driver_bus_intf0.to_cpu_RDATA_valid_WDATA_done && !pkt.txn_rd_wr ) // TODO Modification was done here. Review if any unruly behaviour is observed
                    begin
                        if( pkt.txn_consecutive )
                        begin
                            wait( ready_rcvd == pkt.txn_ADDR_q.size() );
                            break;
                        end
                        else
                        begin
                            `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "RDATA placed onto the to_CPU_bus!" ), UVM_LOW )
                            pkt.txn_RDATA = driver_bus_intf0.PRDATA;
                            wait( ready_rcvd == 1 );
                            break;
                        end
                    end
                end
                if( kill_fork )
                begin
                    wait( kill_fork == 0 );
                end
            end : PRDATA_SAMPLING
            begin : TIMEOUT_LOGIC

                // TODO : IMPLEMENT THE TIMEOUT PIN IN RTL AND THEN WAIT FOR IT'S ASSERTION! NEXT KILL THIS ENTIRE THREAD!
                wait( driver_bus_intf0.to_cpu_txn_timeout );
                got_timeout = 1;
                `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "PSELx timeout incurred!" ), UVM_LOW )

            end : TIMEOUT_LOGIC

        join_any

        `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Fork Disabled!" ), UVM_LOW )
        disable fork;

        `UVM_INFO_MST( "VIP_MASTER_DEBUG_INFO", $sformatf( "Finished driving a packet..." ), UVM_LOW )
    endtask

endclass
