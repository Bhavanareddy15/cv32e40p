`ifndef ALU_TEST_SV
`define ALU_TEST_SV

// ============================================================
// Base Test Class
// ============================================================
class alu_base_test extends uvm_test;
  `uvm_component_utils(alu_base_test)

  alu_env env;

  function new(string name = "alu_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    alu_base_sequence seq;
    phase.raise_objection(this);
    seq = alu_base_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Arithmetic Test
// ============================================================
class alu_arith_test extends alu_base_test;
  `uvm_component_utils(alu_arith_test)

  function new(string name = "alu_arith_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_arith_sequence seq;
    phase.raise_objection(this);
    seq = alu_arith_sequence::type_id::create("seq");
    seq.num_transactions = 200;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Logic Test
// ============================================================
class alu_logic_test extends alu_base_test;
  `uvm_component_utils(alu_logic_test)

  function new(string name = "alu_logic_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_logic_sequence seq;
    phase.raise_objection(this);
    seq = alu_logic_sequence::type_id::create("seq");
    seq.num_transactions = 200;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Shift Test
// ============================================================
class alu_shift_test extends alu_base_test;
  `uvm_component_utils(alu_shift_test)

  function new(string name = "alu_shift_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_shift_sequence seq;
    phase.raise_objection(this);
    seq = alu_shift_sequence::type_id::create("seq");
    seq.num_transactions = 200;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Compare Test
// ============================================================
class alu_compare_test extends alu_base_test;
  `uvm_component_utils(alu_compare_test)

  function new(string name = "alu_compare_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_compare_sequence seq;
    phase.raise_objection(this);
    seq = alu_compare_sequence::type_id::create("seq");
    seq.num_transactions = 200;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Division Test
// ============================================================
class alu_div_test extends alu_base_test;
  `uvm_component_utils(alu_div_test)

  function new(string name = "alu_div_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_div_sequence seq;
    phase.raise_objection(this);
    seq = alu_div_sequence::type_id::create("seq");
    seq.num_transactions = 200;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Bit Manipulation Test
// ============================================================
class alu_bitmanip_test extends alu_base_test;
  `uvm_component_utils(alu_bitmanip_test)

  function new(string name = "alu_bitmanip_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_bitmanip_sequence seq;
    phase.raise_objection(this);
    seq = alu_bitmanip_sequence::type_id::create("seq");
    seq.num_transactions = 200;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Vector Mode Test
// ============================================================
class alu_vector_test extends alu_base_test;
  `uvm_component_utils(alu_vector_test)

  function new(string name = "alu_vector_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_vector_sequence seq;
    phase.raise_objection(this);
    seq = alu_vector_sequence::type_id::create("seq");
    seq.num_transactions = 200;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Corner Case Test
// ============================================================
class alu_corner_case_test extends alu_base_test;
  `uvm_component_utils(alu_corner_case_test)

  function new(string name = "alu_corner_case_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_corner_case_sequence seq;
    phase.raise_objection(this);
    seq = alu_corner_case_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

// ============================================================
// Full Coverage Test
// ============================================================
class alu_full_coverage_test extends alu_base_test;
  `uvm_component_utils(alu_full_coverage_test)

  function new(string name = "alu_full_coverage_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_full_coverage_sequence seq;
    phase.raise_objection(this);
    seq = alu_full_coverage_sequence::type_id::create("seq");
    seq.txn_per_op = 100;
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass

`endif
