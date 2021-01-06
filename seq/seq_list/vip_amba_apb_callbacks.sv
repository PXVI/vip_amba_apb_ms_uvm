// *******************************************************
// Date Created   : 12 November, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_callbacks extends uvm_callback;
    
	`uvm_object_utils_begin( vip_amba_apb_callbacks )
    // Util Registration
	`uvm_object_utils_end

    function new( string name = "vip_amba_apb_callbacks" );
        super.new( name );
    endfunction

    virtual function int wait_state();
        return 0;
    endfunction

endclass
