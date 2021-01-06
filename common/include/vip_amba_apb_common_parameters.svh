// *******************************************************
// Date Created   : 30 November, 2019
// Author         : :P
// *******************************************************

// Parameters Section
// ------------------

// VIP TB TOP Instance's Parameter Defines
// ---------------------------------------

`define TB_VIP_AMBA_APB_PARAM_DECL				#(  parameter ADDRESS_WIDTH = `ADDRESS_WIDTH, \
                                                    parameter DATA_STROBE = `DATA_STROBE, \
                                                    parameter DATA_WIDTH = `DATA_WIDTH, \
                                                    parameter SELECT_LINE_WIDTH = `SELECT_LINE_WIDTH, \
                                                    parameter PSELx_TIMEOUT = `PSELx_TIMEOUT, \
                                                    parameter VIP_MODE = 7, \
                                                    parameter VIP_INST = 0 )

`define TB_VIP_AMBA_APB_PARAM				    #(  .ADDRESS_WIDTH (  ADDRESS_WIDTH ), \
                                                    .DATA_STROBE (  DATA_STROBE ), \
                                                    .DATA_WIDTH (  DATA_WIDTH ), \
                                                    .SELECT_LINE_WIDTH (  SELECT_LINE_WIDTH ), \
                                                    .PSELx_TIMEOUT( PSELx_TIMEOUT ), \
                                                    .VIP_MODE( VIP_MODE ), \
                                                    .VIP_INST( VIP_INST ) )
	
// APB Master
// ----------

`define VIP_AMBA_APB_BRIDGE_DECL				#( 	parameter ADDRESS_WIDTH = `ADDRESS_WIDTH, \
                                                    parameter DATA_STROBE = `DATA_STROBE, \
                                                 	parameter DATA_WIDTH = `DATA_WIDTH, \
                                                    parameter SELECT_LINE_WIDTH = `SELECT_LINE_WIDTH,  \
                                                    parameter PSELx_TIMEOUT = `PSELx_TIMEOUT, \
                                                    parameter VIP_MODE = 7, \
                                                    parameter VIP_INST = 0 )

`define VIP_AMBA_APB_BRIDGE_PARAM				#(  .ADDRESS_WIDTH (  ADDRESS_WIDTH ), \
                                                    .DATA_STROBE (  DATA_STROBE ), \
                                                    .DATA_WIDTH (  DATA_WIDTH ), \
                                                    .SELECT_LINE_WIDTH (  SELECT_LINE_WIDTH ), \
                                                    .PSELx_TIMEOUT( PSELx_TIMEOUT ), \
                                                    .VIP_MODE( VIP_MODE ), \
                                                    .VIP_INST( VIP_INST ) )

// APB Slave                                        
// ---------

`define VIP_AMBA_APB_SLAVE_DECL 				#(  parameter ADDRESS_WIDTH = `ADDRESS_WIDTH, \
                                                    parameter DATA_STROBE = `DATA_STROBE, \
                                                    parameter DATA_WIDTH = `DATA_WIDTH, \
                                                    parameter SELECT_LINE_WIDTH = `SELECT_LINE_WIDTH,  \
                                                    parameter PSELx_TIMEOUT = `PSELx_TIMEOUT, \
                                                    parameter VIP_MODE = 7, \
                                                    parameter VIP_INST = 0 )

`define VIP_AMBA_APB_SLAVE_PARAM				#(  .ADDRESS_WIDTH (  ADDRESS_WIDTH ), \
                                                    .DATA_STROBE (  DATA_STROBE ), \
                                                    .DATA_WIDTH (  DATA_WIDTH ), \
                                                    .SELECT_LINE_WIDTH (  SELECT_LINE_WIDTH ), \
                                                    .PSELx_TIMEOUT( PSELx_TIMEOUT ), \
                                                    .VIP_MODE( VIP_MODE ), \
                                                    .VIP_INST( VIP_INST ) )
