`ifndef ALU_CONFIG_SV
`define ALU_CONFIG_SV

class alu_config extends uvm_object;
  `uvm_object_utils(alu_config)

  // Agent configuration
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Coverage settings
  bit coverage_enable = 1;
  bit func_cov_enable = 1;
  bit code_cov_enable = 0;

  // Test settings
  int unsigned num_transactions = 100;
  int unsigned timeout_cycles   = 100000;

  // Verbosity
  uvm_verbosity verbosity = UVM_MEDIUM;

  // Randomization seed (0 = use simulator default)
  int unsigned rand_seed = 0;

  // Division operation settings
  int unsigned div_timeout_cycles = 64;

  // Coverage goals (percentage)
  real opcode_cov_goal     = 100.0;
  real operand_cov_goal    = 90.0;
  real cross_cov_goal      = 80.0;

  // Test selection
  string test_name = "alu_base_test";

  // Waveform dump
  bit dump_waves = 0;
  string wave_file = "alu_tb.vcd";

  function new(string name = "alu_config");
    super.new(name);
  endfunction

  function void print_config();
    `uvm_info("ALU_CONFIG", $sformatf("========== ALU Configuration =========="), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Test Name:          %s", test_name), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Agent Mode:         %s", is_active.name()), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Coverage Enable:    %0d", coverage_enable), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Func Cov Enable:    %0d", func_cov_enable), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Code Cov Enable:    %0d", code_cov_enable), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Num Transactions:   %0d", num_transactions), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Timeout Cycles:     %0d", timeout_cycles), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Verbosity:          %s", verbosity.name()), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("  Dump Waves:         %0d", dump_waves), UVM_LOW)
    `uvm_info("ALU_CONFIG", $sformatf("============================================"), UVM_LOW)
  endfunction

  function bit check_coverage_goals(real opcode_cov, real operand_cov, real cross_cov);
    bit pass = 1;
    if (opcode_cov < opcode_cov_goal) begin
      `uvm_warning("ALU_CONFIG", $sformatf("Opcode coverage %.2f%% below goal %.2f%%", opcode_cov, opcode_cov_goal))
      pass = 0;
    end
    if (operand_cov < operand_cov_goal) begin
      `uvm_warning("ALU_CONFIG", $sformatf("Operand coverage %.2f%% below goal %.2f%%", operand_cov, operand_cov_goal))
      pass = 0;
    end
    if (cross_cov < cross_cov_goal) begin
      `uvm_warning("ALU_CONFIG", $sformatf("Cross coverage %.2f%% below goal %.2f%%", cross_cov, cross_cov_goal))
      pass = 0;
    end
    return pass;
  endfunction

endclass

`endif
