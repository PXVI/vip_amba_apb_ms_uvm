// *******************************************************
// Date Created   : 17 November, 2019
// Author         : :P
// *******************************************************

// File Display Defines
// --------------------

`define mdisplay(x,y) \
    `ifdef VIP_MONITOR_DEBUG \
        $fdisplay( monitor_debug,$sformatf( "%8t %s", $time, x ) ); \
    `endif \
    if( y == 1 ) \
    begin \
        `uvm_info( "APB_MON_COM",x,UVM_LOW ) \
    end

`define cdisplay(x,y) \
    `ifdef VIP_MONITOR_DEBUG \
        $fdisplay( monitor_debug,$sformatf( "%8t %s", $time, x ) ); \
    `endif \
    if( y == 1 ) \
    begin \
        `uvm_info( "APB_COV_COM",x,UVM_LOW ) \
    end

// Protocol Bus Interface Signals
// ------------------------------

`define PCLK monitor_bus_intf0.PCLK
`define PRESETn monitor_bus_intf0.PRESETn
`define PREADY monitor_bus_intf0.PREADY
`define PRDATA monitor_bus_intf0.PRDATA
`define PSLVERR monitor_bus_intf0.PSLVERR
`define PADDR monitor_bus_intf0.PADDR
`define PPROT monitor_bus_intf0.PPROT
`define PSELx monitor_bus_intf0.PSELx
`define PENABLE monitor_bus_intf0.PENABLE
`define PWRITE monitor_bus_intf0.PWRITE
`define PWDATA monitor_bus_intf0.PWDATA
`define PSTRB monitor_bus_intf0.PSTRB

