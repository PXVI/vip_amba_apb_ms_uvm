// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

module vip_amba_apb_tb_top `TB_VIP_AMBA_APB_PARAM_DECL ( 	

        // Pins Declaration
      
        // DUT Specific Application Pins
        // -----------------------------
        inout                         apb_ready_for_txn,
        inout   [DATA_WIDTH-1:0]      to_cpu_RDATA,
        inout                         to_cpu_RDATA_valid_WDATA_done,
        inout                         to_cpu_txn_err,
        inout                         to_cpu_txn_timeout,
        
        inout                         from_cpu_resetn,
        inout                         from_cpu_valid_txn,
        inout                         from_cpu_rd_wr,
        inout   [ADDRESS_WIDTH-1:0]   from_cpu_address,
        inout   [DATA_STROBE-1:0]     from_cpu_wr_STRB,
        inout   [DATA_WIDTH-1:0]      from_cpu_wr_WDATA,
        inout                         from_cpu_slave_sel,
        
        // Protocol Specific Pins
        // ----------------------
        inout                         PCLK,
        inout                         PRESETn,
        
        inout                         PREADY,
        inout   [DATA_WIDTH-1:0]      PRDATA,
        inout                         PSLVERR,
        
        inout   [ADDRESS_WIDTH-1:0]   PADDR,
        inout   [3-1:0]               PPROT,
        inout                         PSELx,
        inout                         PENABLE,
        inout                         PWRITE,
        inout  [DATA_WIDTH-1:0]       PWDATA,
        inout  [DATA_STROBE-1:0]      PSTRB

	);

    // ------------------------------
    // Importing AMBA APB VIP Package
    // ------------------------------
    //import vip_amba_apb_pkg::*;

	reg 					GLOBAL_CLK;

	vip_amba_apb_interface bus_intf0(); // :P Contains the Protocol Interface Pins : TODO -> Parameterixe the BUS INterface for Multi Env Models
	vip_amba_apb_bridge_bfm_interface master_bfm_intf0(); // :P Contains Bridge Connection Pins : TODO -> Modifications as in the above case
	vip_amba_apb_slave_bfm_interface slave_bfm_intf0();	// TODO Will contain Slave Bridge Connection Pins

	int master_debug;
	int slave_debug;
	int monitor_debug;
	int scoreboard_debug;

    // :P Driving the VIP_MODE value onto the Bus Interface
    assign bus_intf0.VIP_MODE_VAL = VIP_MODE;

    // Signal Assignments based on the VIP Modes
    // VIP Modes Supported
    // -----------------------------------------
    // VIP MODE   | MASTER | SLAVE | MONITOR
    // -----------------------------------------
    //     1      |   N    |   N   |    Y
    // -----------------------------------------
    //     2      |   N    |   Y   |    N
    // -----------------------------------------
    //     3      |   N    |   Y   |    Y
    // -----------------------------------------
    //     4      |   Y    |   N   |    N
    // -----------------------------------------
    //     5      |   Y    |   N   |    Y
    // -----------------------------------------
    //     7      |   Y    |   Y   |    Y
    // -----------------------------------------

    generate
        if( VIP_MODE inside { 2,3 } )
        begin
            // VIP Behaves like a Slave
            assign PCLK = bus_intf0.PCLK; // Global Clock : TB will generate it as of now 
            
            assign PREADY = bus_intf0.PREADY;
            assign PRDATA = bus_intf0.PRDATA;
            assign PSLVERR = bus_intf0.PSLVERR;
            
            assign bus_intf0.PADDR = PADDR;
            assign bus_intf0.PPROT = PPROT;
            assign bus_intf0.PSELx = PSELx;
            assign bus_intf0.PENABLE = PENABLE;
            assign bus_intf0.PWRITE = PWRITE;
            assign bus_intf0.PWDATA = PWDATA;
            assign bus_intf0.PSTRB = PSTRB;

            assign PRESETn = bus_intf0.PRESETn;

            // --------------------------------------------------------------------------
            // USER SPECIFIC APPLICATION LAYER SINGALS
            // --------------------------------------------------------------------------
            // TODO : Add a method to add user specific application layer signals support
            // --------------------------------------------------------------------------
            // :P These signals are in fact, IP specific and hence cannot be generically used everywhere.
            //    In our case, we need these to transfer the txn_item details to the bfm
            assign bus_intf0.apb_ready_for_txn = apb_ready_for_txn;
            assign bus_intf0.to_cpu_RDATA = to_cpu_RDATA;
            assign bus_intf0.to_cpu_RDATA_valid_WDATA_done = to_cpu_RDATA_valid_WDATA_done;
            assign bus_intf0.to_cpu_txn_err = to_cpu_txn_err;
            assign bus_intf0.to_cpu_txn_timeout = to_cpu_txn_timeout;
            
            assign from_cpu_resetn = bus_intf0.from_cpu_resetn;
            assign from_cpu_valid_txn = bus_intf0.from_cpu_valid_txn;
            assign from_cpu_rd_wr = bus_intf0.from_cpu_rd_wr;
            assign from_cpu_address = bus_intf0.from_cpu_address;
            assign from_cpu_wr_STRB = bus_intf0.from_cpu_wr_STRB;
            assign from_cpu_wr_WDATA = bus_intf0.from_cpu_wr_WDATA;
            assign from_cpu_slave_sel = bus_intf0.from_cpu_slave_sel;

        end
        else if( VIP_MODE inside { 4,5 } )
        begin
            // VIP Behaves like a Master
            assign PCLK = bus_intf0.PCLK; // Global Clock : TB will generate it as of now 
            
            assign bus_intf0.PREADY = PREADY;
            assign bus_intf0.PRDATA = PRDATA;
            assign bus_intf0.PSLVERR = PSLVERR;
            
            assign PADDR = bus_intf0.PADDR;
            assign PPROT = bus_intf0.PPROT;
            assign PSELx = bus_intf0.PSELx;
            assign PENABLE = bus_intf0.PENABLE;
            assign PWRITE = bus_intf0.PWRITE;
            assign PWDATA = bus_intf0.PWDATA;
            assign PSTRB = bus_intf0.PSTRB;

            assign PRESETn = bus_intf0.PRESETn;
        end
        else if( VIP_MODE == 1 )
        begin
            // VIP Behaves like a Passive Checker/Monitor
            assign bus_intf0.PCLK = PCLK; // Global Clock : TB will generate it as of now 
            
            assign bus_intf0.PREADY = PREADY;
            assign bus_intf0.PRDATA = PRDATA;
            assign bus_intf0.PSLVERR = PSLVERR;
            
            assign bus_intf0.PADDR = PADDR;
            assign bus_intf0.PPROT = PPROT;
            assign bus_intf0.PSELx = PSELx;
            assign bus_intf0.PENABLE = PENABLE;
            assign bus_intf0.PWRITE = PWRITE;
            assign bus_intf0.PWDATA = PWDATA;
            assign bus_intf0.PSTRB = PSTRB;

            assign bus_intf0.PRESETn = PRESETn;
        end
        else
        begin
            // VIP is internally connected to the BFMs and not the the wrapper ports
        end
    endgenerate

    generate
        if( VIP_MODE inside { 2,3 } )
        begin
            // VIP Behaves like a Slave
            // :P Slave BFM Instantiation
            vip_amba_apb_slave_bfm `VIP_AMBA_APB_SLAVE_PARAM slave_bfm_inst ( 
                                                                                .PCLK( bus_intf0.PCLK ),
                                                                                .PRESETn( bus_intf0.PRESETn ),
                                                                                .PREADY( bus_intf0.PREADY ),
                                                                                .PRDATA( bus_intf0.PRDATA ),
                                                                                .PSLVERR( bus_intf0.PSLVERR ),
                                                                                .PADDR( bus_intf0.PADDR ),
                                                                                .PPROT( bus_intf0.PPROT ),
                                                                                .PSELx( bus_intf0.PSELx ),
                                                                                .PENABLE( bus_intf0.PENABLE ),
                                                                                .PWRITE( bus_intf0.PWRITE ),
                                                                                .PWDATA( bus_intf0.PWDATA ),
                                                                                .PSTRB( bus_intf0.PSTRB )
            );
        end
        else if( VIP_MODE inside { 4,5 } )
        begin
            // VIP Behaves like a Master
            // :P Master BFM Instantiation
            vip_amba_apb_bridge_bfm `VIP_AMBA_APB_BRIDGE_PARAM master_bfm_inst (
                                                                                    .PCLK( bus_intf0.PCLK ),
                                                                                    .PRESETn( bus_intf0.PRESETn ),
                                                                                    
                                                                                    .PREADY( bus_intf0.PREADY ),
                                                                                    .PRDATA( bus_intf0.PRDATA ),
                                                                                    .PSLVERR( bus_intf0.PSLVERR ),
                                                                                    
                                                                                    // Master Outputs
                                                                                    .PADDR( bus_intf0.PADDR ),
                                                                                    .PPROT( bus_intf0.PPROT ),
                                                                                    .PSELx( bus_intf0.PSELx ),
                                                                                    .PENABLE( bus_intf0.PENABLE ),
                                                                                    .PWRITE( bus_intf0.PWRITE ),
                                                                                    .PWDATA( bus_intf0.PWDATA ),
                                                                                    .PSTRB( bus_intf0.PSTRB ),
                                                                                    
                                                                                    // CPU End's Control Signals
                                                                                    // To CPU ( Outputs )
                                                                                    .apb_ready_for_txn( bus_intf0.apb_ready_for_txn ),
                                                                                    .to_cpu_RDATA( bus_intf0.to_cpu_RDATA ),
                                                                                    .to_cpu_RDATA_valid_WDATA_done( bus_intf0.to_cpu_RDATA_valid_WDATA_done ),
                                                                                    .to_cpu_txn_err( bus_intf0.to_cpu_txn_err ),
                                                                                    .to_cpu_txn_timeout( bus_intf0.to_cpu_txn_timeout ),
                                                                                    
                                                                                    // From CPU ( Inputs )
                                                                                    .from_cpu_resetn( bus_intf0.from_cpu_resetn ),
                                                                                    .from_cpu_valid_txn( bus_intf0.from_cpu_valid_txn ),
                                                                                    .from_cpu_rd_wr( bus_intf0.from_cpu_rd_wr ),
                                                                                    .from_cpu_address( bus_intf0.from_cpu_address ),
                                                                                    .from_cpu_wr_STRB( bus_intf0.from_cpu_wr_STRB ),
                                                                                    .from_cpu_wr_WDATA( bus_intf0.from_cpu_wr_WDATA ),
                                                                                    .from_cpu_slave_sel( bus_intf0.from_cpu_slave_sel) 
            );
        end
        else if( VIP_MODE == 1 )
        begin
            // None of the the BFMs will be instantiated. The Monitor acst as a simple Passive Checker/Monitor.
        end
        else
        begin
            // :P Master BFM Instantiation
            vip_amba_apb_bridge_bfm `VIP_AMBA_APB_BRIDGE_PARAM master_bfm_inst (
                                                                                    .PCLK( bus_intf0.PCLK ),
                                                                                    .PRESETn( bus_intf0.PRESETn ),
                                                                                    
                                                                                    .PREADY( bus_intf0.PREADY ),
                                                                                    .PRDATA( bus_intf0.PRDATA ),
                                                                                    .PSLVERR( bus_intf0.PSLVERR ),
                                                                                    
                                                                                    // Master Outputs
                                                                                    .PADDR( bus_intf0.PADDR ),
                                                                                    .PPROT( bus_intf0.PPROT ),
                                                                                    .PSELx( bus_intf0.PSELx ),
                                                                                    .PENABLE( bus_intf0.PENABLE ),
                                                                                    .PWRITE( bus_intf0.PWRITE ),
                                                                                    .PWDATA( bus_intf0.PWDATA ),
                                                                                    .PSTRB( bus_intf0.PSTRB ),
                                                                                    
                                                                                    // CPU End's Control Signals
                                                                                    // To CPU ( Outputs )
                                                                                    .apb_ready_for_txn( bus_intf0.apb_ready_for_txn ),
                                                                                    .to_cpu_RDATA( bus_intf0.to_cpu_RDATA ),
                                                                                    .to_cpu_RDATA_valid_WDATA_done( bus_intf0.to_cpu_RDATA_valid_WDATA_done ),
                                                                                    .to_cpu_txn_err( bus_intf0.to_cpu_txn_err ),
                                                                                    .to_cpu_txn_timeout( bus_intf0.to_cpu_txn_timeout ),
                                                                                    
                                                                                    // From CPU ( Inputs )
                                                                                    .from_cpu_resetn( bus_intf0.from_cpu_resetn ),
                                                                                    .from_cpu_valid_txn( bus_intf0.from_cpu_valid_txn ),
                                                                                    .from_cpu_rd_wr( bus_intf0.from_cpu_rd_wr ),
                                                                                    .from_cpu_address( bus_intf0.from_cpu_address ),
                                                                                    .from_cpu_wr_STRB( bus_intf0.from_cpu_wr_STRB ),
                                                                                    .from_cpu_wr_WDATA( bus_intf0.from_cpu_wr_WDATA ),
                                                                                    .from_cpu_slave_sel( bus_intf0.from_cpu_slave_sel) 
            );
            // :P Slave BFM Instantiation
            vip_amba_apb_slave_bfm `VIP_AMBA_APB_SLAVE_PARAM slave_bfm_inst ( 
                                                                                .PCLK( bus_intf0.PCLK ),
                                                                                .PRESETn( bus_intf0.PRESETn ),
                                                                                .PREADY( bus_intf0.PREADY ),
                                                                                .PRDATA( bus_intf0.PRDATA ),
                                                                                .PSLVERR( bus_intf0.PSLVERR ),
                                                                                .PADDR( bus_intf0.PADDR ),
                                                                                .PPROT( bus_intf0.PPROT ),
                                                                                .PSELx( bus_intf0.PSELx ),
                                                                                .PENABLE( bus_intf0.PENABLE ),
                                                                                .PWRITE( bus_intf0.PWRITE ),
                                                                                .PWDATA( bus_intf0.PWDATA ),
                                                                                .PSTRB( bus_intf0.PSTRB )
            );
        end
    endgenerate

	initial
	begin
        `ifdef VIP_MASTER_DEBUG
		    master_debug = $fopen( $sformatf( "vip_amba_apb_master_n%0d_debug.log", VIP_INST ) );

		    // Setting the Debug Handles into the UVM Registery
		    uvm_config_db#( int )::set( 	.cntxt( null ),
		    				.inst_name( "" ),
		    				.field_name( $sformatf(  "master_debug[%0d]", VIP_INST ) ),
		    				.value( master_debug ) );
        `endif
        `ifdef VIP_SLAVE_DEBUG
		    slave_debug = $fopen( $sformatf( "vip_amba_apb_slave_n%0d_debug.log", VIP_INST ) );

		    // Setting the Debug Handles into the UVM Registery
		    uvm_config_db#( int )::set( 	.cntxt( null ),
		    				.inst_name( "" ),
		    				.field_name( $sformatf(  "slave_debug[%0d]", VIP_INST ) ),
		    				.value( slave_debug ) );
        `endif
        `ifdef VIP_MONITOR_DEBUG
		    monitor_debug = $fopen( $sformatf( "vip_amba_apb_monitor_n%0d_debug.log", VIP_INST ) );

		    // Setting the Debug Handles into the UVM Registery
		    uvm_config_db#( int )::set( 	.cntxt( null ),
		    				.inst_name( "" ),
		    				.field_name( $sformatf(  "monitor_debug[%0d]", VIP_INST ) ),
		    				.value( monitor_debug ) );
        `endif
        `ifdef VIP_SCOREBOARD_DEBUG
		    scoreboard_debug = $fopen( $sformatf( "vip_amba_apb_scoreboard_n%0d_debug.log", VIP_INST ) );

		    // Setting the Debug Handles into the UVM Registery
		    uvm_config_db#( int )::set( 	.cntxt( null ),
		    				.inst_name( "" ),
		    				.field_name( $sformatf(  "scoreboard_debug[%0d]", VIP_INST ) ),
		    				.value( scoreboard_debug ) );
        `endif
	end

    generate
        if( VIP_MODE != 1 ) // Here every Signal is begin deriven by the TOP_TB's port list
        begin
	        initial
	        begin
	        	GLOBAL_CLK = 1;
	        	forever
	        		#(`time_period) GLOBAL_CLK = ~GLOBAL_CLK;
	        end

            assign bus_intf0.PCLK = GLOBAL_CLK;

            initial
            begin
                bus_intf0.PRESETn = 0;
                #200;
                bus_intf0.PRESETn = 1;
            end
        end
    endgenerate

	initial
	begin
		run_test();
	end

	initial
	begin
		// Setting the VIP Bus Interface, for global access
		uvm_config_db#( virtual vip_amba_apb_interface )::set( 	.cntxt( null ),
									                            .inst_name( "" ),
									                            .field_name( $sformatf( "bus_intf0[%0d]", VIP_INST ) ),
									                            .value( bus_intf0 ) );
	end

	initial
	begin
		// Setting the Master Bus Interface, for global access
		uvm_config_db#( virtual vip_amba_apb_bridge_bfm_interface )::set( 	.cntxt( null ),
											                                .inst_name( "" ),
											                                .field_name( $sformatf( "master_bfm_intf0[%0d]", VIP_INST ) ),
											                                .value( master_bfm_intf0 ) );
	end
	
	initial
	begin
		// Setting the Slave Bus Interface, for global access
		uvm_config_db#( virtual vip_amba_apb_slave_bfm_interface )::set( 		.cntxt( null ),
											                                    .inst_name( "" ),
											                                    .field_name( $sformatf( "slave_bfm_intf0[%0d]", VIP_INST ) ),
											                                    .value( slave_bfm_intf0 ) );
	end

    // -------------------------
    // Assertion Momdule Binding
    // -------------------------
    bind vip_amba_apb_tb_top vip_amba_apb_assertions `TB_VIP_AMBA_APB_PARAM apb_assert_inst ( 
                                                                                                .PCLK( PCLK ),
                                                                                                .PRESETn( PRESETn ),
                                                                                                         
                                                                                                .PREADY( PREADY ),
                                                                                                .PRDATA( PRDATA ),
                                                                                                .PSLVERR( PSLVERR ),
                                                                                                         
                                                                                                .PADDR( PADDR ),
                                                                                                .PPROT( PPROT ),
                                                                                                .PSELx( PSELx ),
                                                                                                .PENABLE( PENABLE ),
                                                                                                .PWRITE( PWRITE ),
                                                                                                .PWDATA( PWDATA ),
                                                                                                .PSTRB( PSTRB )
                                                                                            );

endmodule
