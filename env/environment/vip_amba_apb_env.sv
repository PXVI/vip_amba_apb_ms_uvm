// *******************************************************
// Date Created   : 04 June, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_env extends uvm_env;

    `uvm_component_utils( vip_amba_apb_env )
    
    // Environment Instance Number
    // ---------------------------
    int env_num;
    
    // Environment Configuration Object
    // --------------------------------
    vip_amba_apb_env_config env_config;
    
    // Master Agent
    // ------------
    vip_amba_apb_master_agent master_agent;   
    
    // Slave Agent
    // -----------
    
    // Monitor Agent
    // -------------
    vip_amba_apb_monitor_agent monitor_agent;
    
    // Scoreboard Agent
    // ----------------
    
    function new( string name="vip_amba_apb_env", uvm_component parent );
        super.new( name, parent );
        $display( "Environment New Called" );
    endfunction
    
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        $display( "Environment Build Called" );
        
        // Get the Environement Configuration File
        // ---------------------------------------
        if( !uvm_config_db#( vip_amba_apb_env_config )::get(    .cntxt( this ),
            .inst_name( "" ),
            .field_name( $sformatf( "env_config[%0d]", env_num ) ),
            .value( env_config ) ) )
        begin
            `uvm_fatal( "DB_GET_ERR","Failed to get the env_config in sequence" )
        end
        
        // Building Components
        // -------------------
        if( env_config.has_master )
        begin
            master_agent = vip_amba_apb_master_agent::type_id::create( "master_agent",this );
            master_agent.env_num = env_num;
        end
        if( env_config.has_monitor )
        begin
            monitor_agent = vip_amba_apb_monitor_agent::type_id::create( "monitor_agent",this );
            monitor_agent.env_num = env_num;
        end
        
    endfunction
    
    function void end_of_elaboration_phase( uvm_phase phase );
        super.end_of_elaboration_phase( phase );
        
        uvm_top.print_topology();
        factory.print();
    endfunction
    
endclass
