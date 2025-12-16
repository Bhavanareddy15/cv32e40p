`timescale 1ns/1ps

module alu_tb_top;

  import uvm_pkg::*;
  import cv32e40p_pkg::*;
  import alu_pkg::*;

  `include "uvm_macros.svh"

  // Clock and reset
  logic clk;
  logic rst_n;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst_n = 0;
    repeat (5) @(posedge clk);
    rst_n = 1;
  end

  // Interface instance
  alu_if alu_vif(clk, rst_n);

  // DUT instantiation
  cv32e40p_alu dut (
    .clk                 (clk),
    .rst_n               (rst_n),
    .enable_i            (alu_vif.enable),
    .operator_i          (alu_vif.operator),
    .operand_a_i         (alu_vif.operand_a),
    .operand_b_i         (alu_vif.operand_b),
    .operand_c_i         (alu_vif.operand_c),
    .vector_mode_i       (alu_vif.vector_mode),
    .bmask_a_i           (alu_vif.bmask_a),
    .bmask_b_i           (alu_vif.bmask_b),
    .imm_vec_ext_i       (alu_vif.imm_vec_ext),
    .is_clpx_i           (alu_vif.is_clpx),
    .is_subrot_i         (alu_vif.is_subrot),
    .clpx_shift_i        (alu_vif.clpx_shift),
    .result_o            (alu_vif.result),
    .comparison_result_o (alu_vif.comparison_result),
    .ready_o             (alu_vif.ready),
    .ex_ready_i          (alu_vif.ex_ready)
  );

  // UVM configuration and test start
  initial begin
    // Set virtual interface in config_db
    uvm_config_db#(virtual alu_if.DRV)::set(null, "uvm_test_top.env.agent.driver", "vif", alu_vif);
    uvm_config_db#(virtual alu_if.MON)::set(null, "uvm_test_top.env.agent.monitor", "vif", alu_vif);

    // Dump waveforms
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb_top);

    // Run test
    run_test();
  end

  // Timeout watchdog
  initial begin
    #1000000;
    `uvm_fatal("TIMEOUT", "Simulation timeout reached")
  end

endmodule
