`ifndef ALU_DRIVER_SV
`define ALU_DRIVER_SV

class alu_driver extends uvm_driver #(alu_seq_item);
  `uvm_component_utils(alu_driver)

  virtual alu_if.DRV vif;

  function new(string name = "alu_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if.DRV)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not found in config_db")
  endfunction

  task run_phase(uvm_phase phase);
    alu_seq_item txn;

    wait (vif.rst_n === 1'b1);
    @(vif.drv_cb);

    forever begin
      seq_item_port.get_next_item(txn);
      drive_transaction(txn);
      seq_item_port.item_done();
    end
  endtask

  task drive_transaction(alu_seq_item txn);
    vif.drv_cb.enable      <= txn.enable;
    vif.drv_cb.operator    <= cv32e40p_pkg::alu_opcode_e'(txn.operator);
    vif.drv_cb.operand_a   <= txn.operand_a;
    vif.drv_cb.operand_b   <= txn.operand_b;
    vif.drv_cb.operand_c   <= txn.operand_c;
    vif.drv_cb.vector_mode <= txn.vector_mode;
    vif.drv_cb.bmask_a     <= txn.bmask_a;
    vif.drv_cb.bmask_b     <= txn.bmask_b;
    vif.drv_cb.imm_vec_ext <= txn.imm_vec_ext;
    vif.drv_cb.is_clpx     <= txn.is_clpx;
    vif.drv_cb.is_subrot   <= txn.is_subrot;
    vif.drv_cb.clpx_shift  <= txn.clpx_shift;
    vif.drv_cb.ex_ready    <= 1'b1;

    @(vif.drv_cb);

    if (txn.operator inside {alu_seq_item::ALU_DIV, alu_seq_item::ALU_DIVU,
                             alu_seq_item::ALU_REM, alu_seq_item::ALU_REMU}) begin
      wait (vif.drv_cb.ready === 1'b1);
      @(vif.drv_cb);
    end

    vif.drv_cb.enable <= 1'b0;
  endtask

endclass

`endif
