// ***********************************
// ************** :P *****************
// ***********************************
// Date Created : 22 May, 2019

// -------------------------
// BFM Non Sythesizable Code
// -------------------------

module vip_amba_apb_slave_bfm `VIP_AMBA_APB_SLAVE_DECL (	
							
                // Pins Declaration
                input                         PCLK,
                input                         PRESETn,
                
                output   reg                  PREADY,
                output   reg [DATA_WIDTH-1:0] PRDATA,
                output   reg                  PSLVERR,
                
                input   [ADDRESS_WIDTH-1:0]   PADDR,
                input   [3-1:0]               PPROT,
                input                         PSELx,
                input                         PENABLE,
                input                         PWRITE,
                input  [DATA_WIDTH-1:0]       PWDATA,
                input  [DATA_STROBE-1:0]     PSTRB

							);

    vip_amba_apb_env_config env_config;

    initial
    begin
        forever
        begin
            //wait( uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( uvm_root::get() ),
			//			 	                                        .inst_name( "*" ),
			//				                                        .field_name( "env_config" ),
			//				                                        .value( env_config ) ) );
            
            uvm_config_db#( vip_amba_apb_env_config )::wait_modified(   .cntxt( uvm_root::get() ),
                                                                        .inst_name( "*" ),
                                                                        .field_name( $sformatf( "env_config[%0d]", VIP_INST ) ) );
            if( !uvm_config_db#( vip_amba_apb_env_config )::get( 	.cntxt( uvm_root::get() ),
						 	                                        .inst_name( "*" ),
							                                        .field_name( $sformatf( "env_config[%0d]", VIP_INST ) ),
							                                        .value( env_config ) ) )
            begin
                `uvm_fatal( "APB_SLV_BFM", $sformatf( " Failed to access DB env config object" ) );
            end
            else
            begin
                `uvm_info( "APB_SLV_BFM", $sformatf( " Successfully got the CONFIG OBJECT" ), UVM_LOW );
            end
        end
    end

    // Verilog/SV BFM Code ( SV Non Synthesizable Piece of Code 
    initial
    begin
        `uvm_info( "APB_SLV_BFM", $sformatf( " AMBA APB SLAVE BFM Initialized..." ), UVM_LOW );
        slave_model_task();
    end

    // Slave Model Task that replicates an expected slaves behaviour
    task slave_model_task();

        // Psuedo Bus Variables
        logic [ADDRESS_WIDTH-1:0] PADDR_v; 
        logic [DATA_WIDTH-1:0] PWDATA_v; 
        logic [DATA_STROBE-1:0] PSTRB_v;
        logic PWRITE_v;

        // Memory Model
        logic [8-1:0] Mem_Model[logic [ADDRESS_WIDTH-1:0]]; // NOTE This Memory Model is now Byte Addressable

        // Initial Signal Values
        // ---------------------
        PSLVERR <= 'd0;

        forever
        begin
            fork // Running Parellel Processes for PRESETn and the Regular BFM Thread
                forever
                begin
                    wait( !PRESETn );
                    PSLVERR <= 0;
                    PREADY <= 0;
                    wait( PRESETn );
                end
                begin
                    wait( !PRESETn );
                    wait( PRESETn );
                    wait( !PRESETn );
                    PSLVERR <= 0;
                    PREADY <= 0;
                    `uvm_info( "APB_SLV_BFM", $sformatf( " AMBA APB SLAVE BFM PRESETn Assertion Encountered!" ), UVM_LOW );
                end
                forever
                begin
                    @( posedge PCLK );
                    //if( PENABLE && PREADY )
                    //    PREADY <= 0;
                    //else
                    if( PSELx == 1 && PENABLE == 0 && PRESETn )
                    begin
                        automatic int wait_state_delay = 0; // TODO Callback to change this value

                        if( env_config != null )
                        begin
                            wait_state_delay = env_config.wait_state.pop_front();
                        end
                        else
                        begin
                            wait_state_delay = 0;
                        end

                        // Latch the Transaction Data Variables
                        PADDR_v = PADDR;
                        PWDATA_v = PWDATA;
                        PSTRB_v = PSTRB;
                        PWRITE_v = PWRITE;
                        
                        //`uvm_info( "APB_SLV_BFM", $sformatf( " WAIT_STATE : %3d", wait_state_delay ), UVM_LOW );

                        repeat( wait_state_delay )
                        begin
                            @(posedge PCLK );
                        end

                        if( wait_state_delay <= `PSELx_TIMEOUT )
                        begin
                            PREADY <= #1 1; // TODO : Callback Implementation
                            if( PWRITE_v == 1 && PSELx == 1 ) // Write Operation
                            begin
                                @( posedge PCLK );
                                
                                `uvm_info( "APB_SLV_BFM", $sformatf( " ==========================================" ), UVM_LOW );

                                if( env_config.error_write_data.size() )
                                begin
                                    logic [32-1:0] temp_data;

                                    temp_data = env_config.data;

                                    foreach( PSTRB_v[i] )
                                    begin
                                        if( PSTRB_v[i] )
                                        begin
                                            Mem_Model[PADDR_v+i] = temp_data[i*8+:8];
                                            `uvm_info( "APB_SLV_BFM", $sformatf( " Byte %3d Strobe : %1d [ WRITE_SUCCESSFUL ]", i, 1 ), UVM_LOW );
                                        end
                                        else
                                        begin
                                            `uvm_info( "APB_SLV_BFM", $sformatf( " Byte %3d Strobe : %1d [ WRITE_BYPASSED   ]", i, 0 ), UVM_LOW );
                                        end
                                    end
                                end
                                else
                                begin
                                    foreach( PSTRB_v[i] )
                                    begin
                                        if( PSTRB_v[i] )
                                        begin
                                            Mem_Model[PADDR_v+i] = PWDATA_v[i*8+:8];
                                            `uvm_info( "APB_SLV_BFM", $sformatf( " Byte %3d Strobe : %1d [ WRITE_SUCCESSFUL ]", i, 1 ), UVM_LOW );
                                        end
                                        else
                                        begin
                                            `uvm_info( "APB_SLV_BFM", $sformatf( " Byte %3d Strobe : %1d [ WRITE_BYPASSED   ]", i, 0 ), UVM_LOW );
                                        end
                                    end
                                end
                                
                                begin
                                    logic [32-1:0] temp_data_l;
                                    
                                    foreach( PSTRB_v[i] ) // Simply using PSTRB_v to iterate through the number of Byte Locations
                                    begin
                                        if( Mem_Model.exists( PADDR_v+i ) )
                                        begin
                                            temp_data_l[i*8+:8] = Mem_Model[PADDR_v+i];
                                        end
                                        else
                                        begin
                                            temp_data_l[i*8+:8] = 'dx;
                                        end
                                    end
                                    
                                    `uvm_info( "APB_SLV_BFM", $sformatf( " ==========================================" ), UVM_LOW );
                                    `uvm_info( "APB_SLV_BFM", $sformatf( " MEMORY LOCATION : [ %h ] %h", PADDR_v, temp_data_l ), UVM_LOW );
                                    `uvm_info( "APB_SLV_BFM", $sformatf( " ==========================================" ), UVM_LOW );
                                end
                                PREADY <= #1 0;
                            end
                            else if( PWRITE_v == 0 && PSELx == 1 ) // Read Operation
                            begin
                                bit [4-1:0] addr_valid;

                                foreach( PSTRB_v[i] )
                                begin
                                    if( Mem_Model.exists( PADDR_v+i ) )
                                    begin
                                        addr_valid[i] = 1'b1;
                                    end
                                end

                                if( addr_valid )
                                begin
                                    if( env_config.error_read_data.size() )
                                    begin
                                        PRDATA <= #1 env_config.data;
                                    end
                                    else
                                    begin
                                        logic [32-1:0] temp_data;

                                        foreach( PSTRB_v[i] ) // Simply using PSTRB_v to iterate through the Number of Byte Locations in Memory
                                        begin
                                            if( Mem_Model.exists( PADDR_v+i ) )
                                            begin
                                                temp_data[i*8+:8] = Mem_Model[PADDR_v+i];
                                            end
                                            else
                                            begin
                                                temp_data[i*8+:8] = 'dx;
                                            end
                                        end
                                        
                                        if( env_config.pslverr_err_inj[0] == 'd1 )
                                        begin
                                            `ifdef PSLVERR_RDATA_VALUE
                                                if( `PSLVERR_RDATA_VALUE == 'd0 )
                                                begin
                                                    temp_data = 'h0;
                                                end
                                                else
                                                begin
                                                    temp_data = 'hx;
                                                end
                                            `else
                                                temp_data = 'hx;
                                            `endif
                                            PSLVERR <= 'd1;
                                            PRDATA <= #1 temp_data;
                                        end
                                        else
                                        begin
                                            PRDATA <= #1 temp_data;
                                        end
                                    end
                                end
                                else
                                begin
                                    `uvm_info( "APB_SLV_BFM", $sformatf( " Non Existant Array Address Access In The Memory" ), UVM_LOW );
                                    `uvm_info( "APB_SLV_BFM", $sformatf( " PADDR : %h", PADDR_v ), UVM_LOW );
                                end
                                @( posedge PCLK );
                                PREADY <= #1 0;
                                PSLVERR <= 'd0;
                            end
                        end 
                        else
                        begin
                            PREADY <= #1 0;
                        end
                    end
                    else if( PRESETn )
                    begin
                        PREADY <= #1 0;
                    end
                end
            join_any

            if( !PRESETn )
            begin
                disable fork;
            end
        end
    endtask

endmodule
