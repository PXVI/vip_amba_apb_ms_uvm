// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

interface vip_amba_apb_interface `TB_VIP_AMBA_APB_PARAM_DECL;

	// TB - DUT Interface Signals
	// --------------------------

    logic                         apb_ready_for_txn;
    logic   [DATA_WIDTH-1:0]      to_cpu_RDATA;
    logic                         to_cpu_RDATA_valid_WDATA_done;
    logic                         to_cpu_txn_err;
    logic                         to_cpu_txn_timeout;
    
    logic                         from_cpu_resetn;
    logic                         from_cpu_valid_txn;
    logic                         from_cpu_rd_wr;
    logic   [ADDRESS_WIDTH-1:0]   from_cpu_address;
    logic   [DATA_STROBE-1:0]     from_cpu_wr_STRB;
    logic   [DATA_WIDTH-1:0]      from_cpu_wr_WDATA;
    logic                         from_cpu_slave_sel;
 
    
    // Protocol Signals
    // ----------------
    
    logic                         PCLK;
    logic                         PRESETn;
    
    logic                         PREADY;
    logic   [DATA_WIDTH-1:0]      PRDATA;
    logic                         PSLVERR;
    
    logic   [ADDRESS_WIDTH-1:0]   PADDR;
    logic   [3-1:0]               PPROT;
    logic                         PSELx;
    logic                         PENABLE;
    logic                         PWRITE;
    logic  [DATA_WIDTH-1:0]       PWDATA;
    logic  [DATA_STROBE-1:0]      PSTRB;

    // VIP Configuration Signals
    // -------------------------
    int VIP_MODE_VAL;

    // Clocking Block // NOTE Redundant
    // --------------
    clocking apb_cb @( posedge PCLK );
        default input #1step;
        input PSELx;
        input PENABLE;
        input PWRITE;
        input PWDATA;
        input PRDATA;
        input PADDR;
        input PSTRB;
        input PREADY;
        input PPROT;
        input PSLVERR;
    endclocking

    // End Test Logic // TODO
    // ------------------
    bit end_test;
    int end_test_obj_pool;

    initial
    begin
        #0;
        end_test_obj_pool = 'd1;
    end

    // End Test Logic Implementation // TODO For now calling `uvm_fatal. Later
    // use this method to call the end_test logic which wil drop all the uvm
    // objection

    initial
    begin
        logic                           PCLK_old;
        logic                           PRESETn_old;
        
        logic                           PREADY_old;
        logic   [DATA_WIDTH-1:0]        PRDATA_old;
        logic                           PSLVERR_old;
        
        logic   [ADDRESS_WIDTH-1:0]     PADDR_old;
        logic   [3-1:0]                 PPROT_old;
        logic                           PSELx_old;
        logic                           PENABLE_old;
        logic                           PWRITE_old;
        logic  [DATA_WIDTH-1:0]         PWDATA_old;
        logic  [DATA_STROBE-1:0]        PSTRB_old;

        int                             time_out_counter; 
        
        forever
        begin
            #(2 * `time_period);
            if( PCLK === PCLK_old &&
                PRESETn === PRESETn_old &&
                PREADY === PREADY_old &&
                PRDATA === PRDATA_old &&
                PSLVERR === PSLVERR_old &&
                PADDR === PADDR_old &&
                PPROT === PPROT_old &&
                PSELx === PSELx_old &&
                PENABLE === PENABLE_old &&
                PWRITE === PWRITE_old &&
                PWDATA === PWDATA_old &&
                PSTRB === PSTRB_old )
            begin
                time_out_counter++;
                if( time_out_counter == `TIMEOUT )
                begin
                    //`uvm_fatal( "APB_INF_ERR", $sformatf( " Timeout Occured! TIMEOUT VALUE : %6d", `TIMEOUT ) )
                    end_test = 'd1;
                end
            end
            else
            begin
                time_out_counter = 0;
                end_test = 'd0;
            end

            PCLK_old = PCLK;
            PRESETn_old = PRESETn;
            PREADY_old = PREADY;
            PRDATA_old = PRDATA;
            PSLVERR_old = PSLVERR;
            PADDR_old = PADDR;
            PPROT_old = PPROT;
            PSELx_old = PSELx;
            PENABLE_old = PENABLE;
            PWRITE_old = PWRITE;
            PWDATA_old = PWDATA;
            PSTRB_old = PSTRB;
        end
    end
endinterface
