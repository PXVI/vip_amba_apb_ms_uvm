// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

// ------------------------------
// Importing AMBA APB VIP Package
// ------------------------------
`include "vip_amba_apb_pkg.sv"

// ---------------------------
// Including The DUT Top/Files
// ---------------------------
//`include "ip_amba_apb_master_top.v"

module integration_top `TB_VIP_AMBA_APB_PARAM_DECL;

	// Wires Declarations
    wire                         apb_ready_for_txn_w;
    wire   [DATA_WIDTH-1:0]      to_cpu_RDATA_w;
    wire                         to_cpu_RDATA_valid_WDATA_done_w;
    wire                         to_cpu_txn_err_w;
    wire                         to_cpu_txn_timeout_w;
    
    wire                         from_cpu_resetn_w;
    wire                         from_cpu_valid_txn_w;
    wire                         from_cpu_rd_wr_w;
    wire   [ADDRESS_WIDTH-1:0]   from_cpu_address_w;
    wire   [DATA_STROBE-1:0]     from_cpu_wr_STRB_w;
    wire   [DATA_WIDTH-1:0]      from_cpu_wr_WDATA_w;
    wire                         from_cpu_slave_sel_w;
    
    wire                         PCLK_w;
    wire                         PRESETn_w;
    
    wire                         PREADY_w;
    wire   [DATA_WIDTH-1:0]      PRDATA_w;
    wire                         PSLVERR_w;
    
    wire   [ADDRESS_WIDTH-1:0]   PADDR_w;
    wire   [3-1:0]               PPROT_w;
    wire                         PSELx_w;
    wire                         PENABLE_w;
    wire                         PWRITE_w;
    wire  [DATA_WIDTH-1:0]       PWDATA_w;
    wire  [DATA_STROBE-1:0]      PSTRB_w;

	// DUT Instantiation
    //ip_amba_apb_master_top DUT (  

    //                              // APB Interface Side Signals
    //                              // Global Inputs
    //                              .PCLK( PCLK_w ),
    //                              .PRESETn( PRESETn_w ),

    //                              // Master Inputs
    //                              .PREADY( PREADY_w ),
    //                              .PRDATA( PRDATA_w ),
    //                              .PSLVERR( PSLVERR_w ),

    //                              // Master Outputs
    //                              .PADDR( PADDR_w ),
    //                              .PPROT( PPROT_w ),
    //                              .PSELx( PSELx_w ),
    //                              .PENABLE( PENABLE_w ),
    //                              .PWRITE( PWRITE_w ),
    //                              .PWDATA( PWDATA_w ),
    //                              .PSTRB( PSTRB_w ),

    //                              // CPU End's Control Signals
    //                              // TODO
    //                              // To CPU ( Outputs )
    //                              .apb_ready_for_txn( apb_ready_for_txn_w ),
    //                              .to_cpu_RDATA( to_cpu_RDATA_w ),
    //                              .to_cpu_RDATA_valid_WDATA_done( to_cpu_RDATA_valid_WDATA_done_w ),
    //                              .to_cpu_txn_err( to_cpu_txn_err_w ),
    //                              .to_cpu_txn_timeout( to_cpu_txn_timeout_w ),

    //                              // From CPU ( Inputs )
    //                              .from_cpu_resetn( from_cpu_resetn_w ),
    //                              .from_cpu_valid_txn( from_cpu_valid_txn_w ),
    //                              .from_cpu_rd_wr( from_cpu_rd_wr_w ),
    //                              .from_cpu_address( from_cpu_address_w ),
    //                              .from_cpu_wr_STRB( from_cpu_wr_STRB_w ),
    //                              .from_cpu_wr_WDATA( from_cpu_wr_WDATA_w ),
    //                              .from_cpu_slave_sel( from_cpu_slave_sel_w )
    //);

	// VIP TB Instantiation
	vip_amba_apb_tb_top `TB_VIP_AMBA_APB_PARAM vip_tb_inst	(	
        
                                                                // Pins Mapping
                                                                .PCLK( PCLK_w ),
                                                                .PRESETn( PRESETn_w ),

                                                                // Master Inputs
                                                                .PREADY( PREADY_w ),
                                                                .PRDATA( PRDATA_w ),
                                                                .PSLVERR( PSLVERR_w ),

                                                                // Master Outputs
                                                                .PADDR( PADDR_w ),
                                                                .PPROT( PPROT_w ),
                                                                .PSELx( PSELx_w ),
                                                                .PENABLE( PENABLE_w ),
                                                                .PWRITE( PWRITE_w ),
                                                                .PWDATA( PWDATA_w ),
                                                                .PSTRB( PSTRB_w ),

                                                                // CPU End's Control Signals
                                                                // TODO
                                                                // To CPU ( Outputs )
                                                                .apb_ready_for_txn( apb_ready_for_txn_w ),
                                                                .to_cpu_RDATA( to_cpu_RDATA_w ),
                                                                .to_cpu_RDATA_valid_WDATA_done( to_cpu_RDATA_valid_WDATA_done_w ),
                                                                .to_cpu_txn_err( to_cpu_txn_err_w ),
                                                                .to_cpu_txn_timeout( to_cpu_txn_timeout_w ),

                                                                // From CPU ( Inputs )
                                                                .from_cpu_resetn( from_cpu_resetn_w ),
                                                                .from_cpu_valid_txn( from_cpu_valid_txn_w ),
                                                                .from_cpu_rd_wr( from_cpu_rd_wr_w ),
                                                                .from_cpu_address( from_cpu_address_w ),
                                                                .from_cpu_wr_STRB( from_cpu_wr_STRB_w ),
                                                                .from_cpu_wr_WDATA( from_cpu_wr_WDATA_w ),
                                                                .from_cpu_slave_sel( from_cpu_slave_sel_w )

	);

	initial
	begin
		$display( "This is Working and here needs to be edited." );
	end

	`DUMP_VAR

endmodule
