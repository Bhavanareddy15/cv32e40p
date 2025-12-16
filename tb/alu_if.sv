`ifndef ALU_IF_SV
`define ALU_IF_SV

`timescale 1ns/1ps

interface alu_if (input logic clk, input logic rst_n);

  import cv32e40p_pkg::*;

  // Inputs to DUT
  logic               enable;
  alu_opcode_e        operator;
  logic        [31:0] operand_a;
  logic        [31:0] operand_b;
  logic        [31:0] operand_c;
  logic        [1:0]  vector_mode;
  logic        [4:0]  bmask_a;
  logic        [4:0]  bmask_b;
  logic        [1:0]  imm_vec_ext;
  logic               is_clpx;
  logic               is_subrot;
  logic        [1:0]  clpx_shift;
  logic               ex_ready;

  // Outputs from DUT
  logic        [31:0] result;
  logic               comparison_result;
  logic               ready;

  // Driver clocking block
  clocking drv_cb @(posedge clk);
    default input #1step output #1ns;
    output enable;
    output operator;
    output operand_a;
    output operand_b;
    output operand_c;
    output vector_mode;
    output bmask_a;
    output bmask_b;
    output imm_vec_ext;
    output is_clpx;
    output is_subrot;
    output clpx_shift;
    output ex_ready;
    input  result;
    input  comparison_result;
    input  ready;
  endclocking

  // Monitor clocking block
  clocking mon_cb @(posedge clk);
    default input #1step;
    input enable;
    input operator;
    input operand_a;
    input operand_b;
    input operand_c;
    input vector_mode;
    input bmask_a;
    input bmask_b;
    input imm_vec_ext;
    input is_clpx;
    input is_subrot;
    input clpx_shift;
    input ex_ready;
    input result;
    input comparison_result;
    input ready;
  endclocking

  // Modports
  modport DRV (clocking drv_cb, input clk, input rst_n);
  modport MON (clocking mon_cb, input clk, input rst_n);

endinterface

`endif
