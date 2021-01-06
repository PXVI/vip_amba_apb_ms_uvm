// *******************************************************
// Date Created   : 01 June, 2019
// Author         : :P
// *******************************************************

class vip_amba_apb_txn_item extends uvm_sequence_item;

  // TXN Feilds Declaration
  // ----------------------
  rand bit [32-1:0]     txn_ADDR;
  rand bit [32-1:0]     txn_WDATA;
  rand bit [32-1:0]     txn_RDATA;
  rand bit              txn_rd_wr;
  rand bit [8-1:0]      txn_STRB;
  rand bit              txn_slave_sel;
  rand bit              txn_slverr;
  rand bit              txn_consecutive;  
  rand bit              get_data;

  // TXN Fields For Back To Back Transactions
  // ----------------------------------------
  rand bit [32-1:0]     txn_ADDR_q[$];
  rand bit [32-1:0]     txn_WDATA_q[$];
  rand bit [32-1:0]     txn_RDATA_q[$];
  rand bit              txn_rd_wr_q[$];
  rand bit [8-1:0]      txn_STRB_q[$];
  rand bit              txn_slave_sel_q[$];
  rand bit              txn_slverr_q[$];

  // Error Injection Bits
  // --------------------
  bit                   read_txn_error;
  bit                   pslverr_err_inj;
  
  int                   presetn_initiate[$];
  
	`uvm_object_utils_begin( vip_amba_apb_txn_item )
    // Util Registration
        `uvm_field_int( txn_ADDR, UVM_ALL_ON )
        `uvm_field_int( txn_WDATA, UVM_ALL_ON )
        `uvm_field_int( txn_RDATA, UVM_ALL_ON )
        `uvm_field_int( txn_rd_wr, UVM_ALL_ON )
        `uvm_field_int( txn_STRB, UVM_ALL_ON )
        `uvm_field_int( txn_slave_sel, UVM_ALL_ON )
        `uvm_field_int( txn_slverr, UVM_ALL_ON )
        `uvm_field_int( txn_consecutive, UVM_ALL_ON )
        `uvm_field_int( read_txn_error, UVM_ALL_ON )
        `uvm_field_int( pslverr_err_inj, UVM_ALL_ON )
        `uvm_field_int( get_data, UVM_ALL_ON )
        `uvm_field_queue_int( txn_ADDR_q, UVM_ALL_ON )
        `uvm_field_queue_int( txn_WDATA_q, UVM_ALL_ON )
        `uvm_field_queue_int( txn_RDATA_q, UVM_ALL_ON )
        `uvm_field_queue_int( txn_rd_wr_q, UVM_ALL_ON )
        `uvm_field_queue_int( txn_STRB_q, UVM_ALL_ON )
        `uvm_field_queue_int( txn_slave_sel_q, UVM_ALL_ON )
        `uvm_field_queue_int( txn_slverr_q, UVM_ALL_ON )
        `uvm_field_queue_int( presetn_initiate, UVM_ALL_ON )
	`uvm_object_utils_end

    constraint default_constraints { 
                                        soft txn_consecutive == 1'b0;
                                        soft txn_ADDR_q.size() == 'd1;
                                        soft txn_RDATA_q.size() == txn_ADDR_q.size();
                                        soft txn_rd_wr_q.size() == txn_ADDR_q.size();
                                        soft txn_STRB_q.size() == txn_ADDR_q.size();
                                        soft txn_slave_sel_q.size() == txn_ADDR_q.size();
                                        soft txn_slverr_q.size() == txn_ADDR_q.size();
                                        soft txn_WDATA_q.size() == txn_ADDR_q.size();
                                        soft get_data == 'd0;
    };

endclass
