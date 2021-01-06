// *******************************************************
// Date Created   : 18 November, 2019
// Author         : :P
// *******************************************************

// Error Messages and Description Regarding Spec Section
// -----------------------------------------------------

`define EID_0 " [ AMBA_APB_EID_000 ] Sample Error Message. No need to panic at all :P"
`define EID_1 " [ AMBA_APB_EID_001 ] [ AMBA_APB3_v2 ] [ 3.1.1 ] PADDR Bus Value Changed during Access Phase"
`define EID_2 " [ AMBA_APB_EID_002 ] [ AMBA_APB3_v2 ] [ 3.1.1 ] PWDATA Value Changed during Access Phase"
`define EID_3 " [ AMBA_APB_EID_003 ] [ AMBA_APB3_v2 ] [ 3.1.1 ] PSTRB Bus Value Changed during Access Phase"
`define EID_4 " [ AMBA_APB_EID_004 ] [ AMBA_APB3_v2 ] [ 3.1.1 ] PWRITE Bus Value Changed during Access Phase"
`define EID_5 " [ AMBA_APB_EID_005 ] [ AMBA_APB3_v2 ] [ - ] PSELx Signal has not been de-asserted after the defined timeout"
`define EID_6 " [ AMBA_APB_EID_006 ] [ AMBA_APB3_v2 ] [ - ] READ Data Mismatch has occured"
`define EID_7 " [ AMBA_APB_EID_007 ] [ AMBA_APB3_v2 ] [ - ] READ is begin performend on an uninitialised or unwritten Memory Location"
`define EID_8 " [ AMBA_APB_EID_008 ] [ AMBA_APB3_v2 ] [ 3.4.0 ] PSLVERR is high, which means the RDATA bus is supposed to be either all 0's or all x's"
`define EID_9 " [ AMBA_APB_EID_009 ] [ AMBA_APB3_v2 ] [ 3.2.0 ] PSTRB must be LOW during a READ Transaction"
`define EID_10 " [ AMBA_APB_EID_010 ] [ AMBA_APB3_v2 ] [ 4.1.0 ] PENABLE must be asserted only when PSELx is already asserted"
`define EID_11 " [ AMBA_APB_EID_011 ] [ AMBA_APB3_v2 ] [ 3.1.2 ] PSELx must remain asserted for atleat 2 Clocks"
`define EID_12 " [ AMBA_APB_EID_012 ] [ AMBA_APB3_v2 ] [ 4.1.0 ] PENABLE must be asserted immideatly after PSELx has been sampled as asserted for 1 Clock, ie Master should have moved into ACCESS Phase in 2 Clock Cycles"
`define EID_13 " [ AMBA_APB_EID_013 ] [ AMBA_APB3_v2 ] [ 3.3.0 ] PREADY unexpectedly received. No ongoing transacton can be mapped to this runnaway signal assertion"

// Error Count INcrementing Define
// -------------------------------

`define actual_count_incr(x) begin test_config.EID_actual_count[x]++; end

// ERROR Ids With Suppressing Conditions
// -------------------------------------

`define AMBA_APB_EID_0 begin `actual_count_incr(0) if( test_config.EID[0] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_0, UVM_LOW ); end else if( test_config.EID[0] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_0 ); end else begin `uvm_error( "APB_MON_COM", `EID_0 ); end end 
`define AMBA_APB_EID_1 begin `actual_count_incr(1) if( test_config.EID[1] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_1, UVM_LOW ); end else if( test_config.EID[1] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_1 ); end else begin `uvm_error( "APB_MON_COM", `EID_1 ); end end 
`define AMBA_APB_EID_2 begin `actual_count_incr(2) if( test_config.EID[2] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_2, UVM_LOW ); end else if( test_config.EID[2] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_2 ); end else begin `uvm_error( "APB_MON_COM", `EID_2 ); end end 
`define AMBA_APB_EID_3 begin `actual_count_incr(3) if( test_config.EID[3] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_3, UVM_LOW ); end else if( test_config.EID[3] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_3 ); end else begin `uvm_error( "APB_MON_COM", `EID_3 ); end end 
`define AMBA_APB_EID_4 begin `actual_count_incr(4) if( test_config.EID[4] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_4, UVM_LOW ); end else if( test_config.EID[4] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_4 ); end else begin `uvm_error( "APB_MON_COM", `EID_4 ); end end 
`define AMBA_APB_EID_5 begin `actual_count_incr(5) if( test_config.EID[5] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_5, UVM_LOW ); end else if( test_config.EID[5] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_5 ); end else begin `uvm_error( "APB_MON_COM", `EID_5 ); end end 
`define AMBA_APB_EID_6 begin `actual_count_incr(6) if( test_config.EID[6] == 'd2 ) begin `uvm_info( "APB_SCB_COM", `EID_6, UVM_LOW ); end else if( test_config.EID[6] == 'd1 ) begin `uvm_warning( "APB_SCB_COM", `EID_6 ); end else begin `uvm_error( "APB_SCB_COM", `EID_6 ); end end 
`define AMBA_APB_EID_7 begin `actual_count_incr(7) if( test_config.EID[7] == 'd2 ) begin `uvm_info( "APB_SCB_COM", `EID_7, UVM_LOW ); end else if( test_config.EID[7] == 'd1 ) begin `uvm_warning( "APB_SCB_COM", `EID_7 ); end else begin `uvm_error( "APB_SCB_COM", `EID_7 ); end end 
`define AMBA_APB_EID_8 begin `actual_count_incr(8) if( test_config.EID[8] == 'd2 ) begin `uvm_info( "APB_SCB_COM", `EID_8, UVM_LOW ); end else if( test_config.EID[8] == 'd1 ) begin `uvm_warning( "APB_SCB_COM", `EID_8 ); end else begin `uvm_error( "APB_SCB_COM", `EID_8 ); end end 
`define AMBA_APB_EID_9 begin `actual_count_incr(9) if( test_config.EID[9] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_9, UVM_LOW ); end else if( test_config.EID[9] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_9 ); end else begin `uvm_error( "APB_MON_COM", `EID_9 ); end end 
`define AMBA_APB_EID_10 begin `actual_count_incr(10) if( test_config.EID[10] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_10, UVM_LOW ); end else if( test_config.EID[10] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_10 ); end else begin `uvm_error( "APB_MON_COM", `EID_10 ); end end 
`define AMBA_APB_EID_11 begin `actual_count_incr(11) if( test_config.EID[11] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_11, UVM_LOW ); end else if( test_config.EID[11] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_11 ); end else begin `uvm_error( "APB_MON_COM", `EID_11 ); end end 
`define AMBA_APB_EID_12 begin `actual_count_incr(12) if( test_config.EID[12] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_12, UVM_LOW ); end else if( test_config.EID[12] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_12 ); end else begin `uvm_error( "APB_MON_COM", `EID_12 ); end end 
`define AMBA_APB_EID_13 begin `actual_count_incr(13) if( test_config.EID[13] == 'd2 ) begin `uvm_info( "APB_MON_COM", `EID_13, UVM_LOW ); end else if( test_config.EID[13] == 'd1 ) begin `uvm_warning( "APB_MON_COM", `EID_13 ); end else begin `uvm_error( "APB_MON_COM", `EID_13 ); end end 
