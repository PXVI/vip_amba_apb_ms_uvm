// *******************************************************
// Date Created   : 11 January, 2020
// Author         : :P
// *******************************************************

module vip_amba_apb_assertions `TB_VIP_AMBA_APB_PARAM_DECL ( 
                                                                // Protocol Specific Pins
                                                                // ----------------------
                                                                input                         PCLK,
                                                                input                         PRESETn,
                                                                
                                                                input                         PREADY,
                                                                input   [DATA_WIDTH-1:0]      PRDATA,
                                                                input                         PSLVERR,
                                                                
                                                                input   [ADDRESS_WIDTH-1:0]   PADDR,
                                                                input   [3-1:0]               PPROT,
                                                                input                         PSELx,
                                                                input                         PENABLE,
                                                                input                         PWRITE,
                                                                input  [DATA_WIDTH-1:0]       PWDATA,
                                                                input  [DATA_STROBE-1:0]      PSTRB
);

    // -------------------
    // Assertion Sequences
    // -------------------

    // Assertion 001 : During the Access Phase the PADDR must remain stable ( R/W )
    sequence vip_amba_apb_stable_paddr_access_phase;
        PCLK == 1;   
    endsequence

    // Assertion 002 : During the Access Phase the PWRITE must remain stable 
    sequence vip_amba_apb_stable_pwrite_access_phase;
        PCLK == 1;    
    endsequence

    // Assertion 003 : During the Access Phase the PSEL must remain stable 
    sequence vip_amba_apb_stable_psel_access_phase;
        PCLK == 1;    
    endsequence

    // Assertion 004 : During the Access Phase the PENABLE must remain stable 
    sequence vip_amba_apb_stable_penable_access_phase;
        PCLK == 1;    
    endsequence

    // Assertion 005 : During the Access Phase the PWDATA must remain stable 
    sequence vip_amba_apb_stable_pwdata_access_phase;
        PCLK == 1;    
    endsequence

    // Assertion 006 : During the Access Phase the PSTRB must remain stable 
    sequence vip_amba_apb_stable_pstrb_access_phase;
        PCLK == 1;    
    endsequence

    // Assertion 007 : During the Access Phase the PPROT must remain stable 
    sequence vip_amba_apb_stable_pprot_access_phase;
        PCLK == 1;    
    endsequence


endmodule
