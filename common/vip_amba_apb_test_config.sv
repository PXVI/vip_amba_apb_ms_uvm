// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_test_config extends uvm_object;

    int EID_expected_count[];
    int EID_actual_count[];
    
    bit [2:0] EID[];

	`uvm_object_utils_begin( vip_amba_apb_test_config )
    // Util Registration
        `uvm_field_array_int( EID_expected_count, UVM_ALL_ON )
        `uvm_field_array_int( EID_actual_count, UVM_ALL_ON )
        `uvm_field_array_int( EID, UVM_ALL_ON )
	`uvm_object_utils_end

    function new( string name = "vip_amba_apb_test_config" );
        super.new( name );

        EID_expected_count = new[100];
        EID_actual_count = new[100];
        EID = new[100];
    endfunction

endclass
