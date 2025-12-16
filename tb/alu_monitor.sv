`ifndef ALU_MONITOR_SV
`define ALU_MONITOR_SV

class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  virtual alu_if.MON vif;

  uvm_analysis_port #(alu_seq_item) ap;

  // Opcode hit tracking for detailed reporting
  bit arith_hit[cv32e40p_pkg::alu_opcode_e];
  bit logic_hit[cv32e40p_pkg::alu_opcode_e];
  bit shift_hit[cv32e40p_pkg::alu_opcode_e];
  bit cmp_hit[cv32e40p_pkg::alu_opcode_e];
  bit slt_hit[cv32e40p_pkg::alu_opcode_e];
  bit minmax_hit[cv32e40p_pkg::alu_opcode_e];
  bit bitman_hit[cv32e40p_pkg::alu_opcode_e];
  bit bitcnt_hit[cv32e40p_pkg::alu_opcode_e];
  bit div_hit[cv32e40p_pkg::alu_opcode_e];
  bit shuf_hit[cv32e40p_pkg::alu_opcode_e];

  // Coverage groups
  covergroup cg_opcode;
    cp_operator: coverpoint vif.mon_cb.operator {
      bins arith[] = {cv32e40p_pkg::ALU_ADD, cv32e40p_pkg::ALU_SUB,
                      cv32e40p_pkg::ALU_ADDU, cv32e40p_pkg::ALU_SUBU,
                      cv32e40p_pkg::ALU_ADDR, cv32e40p_pkg::ALU_SUBR,
                      cv32e40p_pkg::ALU_ADDUR, cv32e40p_pkg::ALU_SUBUR};
      bins logic_ops[] = {cv32e40p_pkg::ALU_AND, cv32e40p_pkg::ALU_OR, cv32e40p_pkg::ALU_XOR};
      bins shift[] = {cv32e40p_pkg::ALU_SLL, cv32e40p_pkg::ALU_SRL,
                      cv32e40p_pkg::ALU_SRA, cv32e40p_pkg::ALU_ROR};
      bins cmp[] = {cv32e40p_pkg::ALU_EQ, cv32e40p_pkg::ALU_NE,
                    cv32e40p_pkg::ALU_GTS, cv32e40p_pkg::ALU_GES,
                    cv32e40p_pkg::ALU_LTS, cv32e40p_pkg::ALU_LES,
                    cv32e40p_pkg::ALU_GTU, cv32e40p_pkg::ALU_GEU,
                    cv32e40p_pkg::ALU_LTU, cv32e40p_pkg::ALU_LEU};
      bins slt[] = {cv32e40p_pkg::ALU_SLTS, cv32e40p_pkg::ALU_SLTU,
                    cv32e40p_pkg::ALU_SLETS, cv32e40p_pkg::ALU_SLETU};
      bins minmax[] = {cv32e40p_pkg::ALU_MIN, cv32e40p_pkg::ALU_MINU,
                       cv32e40p_pkg::ALU_MAX, cv32e40p_pkg::ALU_MAXU,
                       cv32e40p_pkg::ALU_ABS, cv32e40p_pkg::ALU_CLIP,
                       cv32e40p_pkg::ALU_CLIPU};
      bins bitman[] = {cv32e40p_pkg::ALU_BEXT, cv32e40p_pkg::ALU_BEXTU,
                       cv32e40p_pkg::ALU_BINS, cv32e40p_pkg::ALU_BCLR,
                       cv32e40p_pkg::ALU_BSET, cv32e40p_pkg::ALU_BREV};
      bins bitcnt[] = {cv32e40p_pkg::ALU_FF1, cv32e40p_pkg::ALU_FL1,
                       cv32e40p_pkg::ALU_CNT, cv32e40p_pkg::ALU_CLB};
      bins div[] = {cv32e40p_pkg::ALU_DIV, cv32e40p_pkg::ALU_DIVU,
                    cv32e40p_pkg::ALU_REM, cv32e40p_pkg::ALU_REMU};
      bins shuf[] = {cv32e40p_pkg::ALU_SHUF, cv32e40p_pkg::ALU_SHUF2,
                     cv32e40p_pkg::ALU_PCKLO, cv32e40p_pkg::ALU_PCKHI,
                     cv32e40p_pkg::ALU_EXT, cv32e40p_pkg::ALU_EXTS,
                     cv32e40p_pkg::ALU_INS};
    }
  endgroup

  covergroup cg_operand_ranges;
    cp_operand_a: coverpoint vif.mon_cb.operand_a {
      bins zero        = {32'h00000000};
      bins one         = {32'h00000001};
      bins all_ones    = {32'hFFFFFFFF};
      bins max_signed  = {32'h7FFFFFFF};
      bins min_signed  = {32'h80000000};
      bins small_pos   = {[32'h00000002:32'h000000FF]};
      bins small_neg   = {[32'hFFFFFF00:32'hFFFFFFFE]};
      bins mid_pos     = {[32'h00000100:32'h7FFFFFFE]};
      bins mid_neg     = {[32'h80000001:32'hFFFFFEFF]};
    }
    cp_operand_b: coverpoint vif.mon_cb.operand_b {
      bins zero        = {32'h00000000};
      bins one         = {32'h00000001};
      bins all_ones    = {32'hFFFFFFFF};
      bins max_signed  = {32'h7FFFFFFF};
      bins min_signed  = {32'h80000000};
      bins small_pos   = {[32'h00000002:32'h000000FF]};
      bins small_neg   = {[32'hFFFFFF00:32'hFFFFFFFE]};
      bins mid_pos     = {[32'h00000100:32'h7FFFFFFE]};
      bins mid_neg     = {[32'h80000001:32'hFFFFFEFF]};
    }
    cx_a_b: cross cp_operand_a, cp_operand_b;
  endgroup

  covergroup cg_vector_mode;
    cp_vec_mode: coverpoint vif.mon_cb.vector_mode {
      bins mode32 = {2'b00};
      bins mode16 = {2'b10};
      bins mode8  = {2'b11};
    }
  endgroup

  covergroup cg_shift_amount;
    cp_shift_amt: coverpoint vif.mon_cb.operand_b[4:0] {
      bins zero     = {5'd0};
      bins one      = {5'd1};
      bins max      = {5'd31};
      bins low      = {[5'd2:5'd7]};
      bins mid      = {[5'd8:5'd23]};
      bins high     = {[5'd24:5'd30]};
    }
  endgroup

  covergroup cg_bmask;
    cp_bmask_a: coverpoint vif.mon_cb.bmask_a {
      bins single   = {5'd0};
      bins byte_w   = {5'd7};
      bins half_w   = {5'd15};
      bins full_w   = {5'd31};
      bins other    = default;
    }
    cp_bmask_b: coverpoint vif.mon_cb.bmask_b {
      bins lsb      = {5'd0};
      bins byte1    = {5'd8};
      bins byte2    = {5'd16};
      bins byte3    = {5'd24};
      bins other    = default;
    }
    cx_bmask: cross cp_bmask_a, cp_bmask_b;
  endgroup

  covergroup cg_division;
    cp_divisor: coverpoint vif.mon_cb.operand_b {
      bins zero     = {32'h00000000};
      bins one      = {32'h00000001};
      bins neg_one  = {32'hFFFFFFFF};
      bins other    = default;
    }
    cp_dividend: coverpoint vif.mon_cb.operand_a {
      bins zero     = {32'h00000000};
      bins min_neg  = {32'h80000000};
      bins other    = default;
    }
    cx_div: cross cp_divisor, cp_dividend;
  endgroup

  covergroup cg_clpx;
    cp_is_clpx: coverpoint vif.mon_cb.is_clpx {
      bins off = {1'b0};
      bins on  = {1'b1};
    }
    cp_is_subrot: coverpoint vif.mon_cb.is_subrot {
      bins off = {1'b0};
      bins on  = {1'b1};
    }
  endgroup

  covergroup cg_cross_op_vec;
    cp_operator: coverpoint vif.mon_cb.operator {
      bins vec_ops[] = {cv32e40p_pkg::ALU_ADD, cv32e40p_pkg::ALU_SUB,
                        cv32e40p_pkg::ALU_AND, cv32e40p_pkg::ALU_OR,
                        cv32e40p_pkg::ALU_XOR, cv32e40p_pkg::ALU_MIN,
                        cv32e40p_pkg::ALU_MAX, cv32e40p_pkg::ALU_GTS,
                        cv32e40p_pkg::ALU_LTS};
    }
    cp_vec_mode: coverpoint vif.mon_cb.vector_mode {
      bins mode32 = {2'b00};
      bins mode16 = {2'b10};
      bins mode8  = {2'b11};
    }
    cx_op_vec: cross cp_operator, cp_vec_mode;
  endgroup

  function new(string name = "alu_monitor", uvm_component parent = null);
    super.new(name, parent);
    cg_opcode = new();
    cg_operand_ranges = new();
    cg_vector_mode = new();
    cg_shift_amount = new();
    cg_bmask = new();
    cg_division = new();
    cg_clpx = new();
    cg_cross_op_vec = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual alu_if.MON)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not found in config_db")
  endfunction

  task run_phase(uvm_phase phase);
    alu_seq_item txn;

    wait (vif.rst_n === 1'b1);
    @(vif.mon_cb);

    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.enable === 1'b1) begin
        txn = alu_seq_item::type_id::create("txn");

        txn.operator    = alu_seq_item::alu_opcode_e'(vif.mon_cb.operator);
        txn.operand_a   = vif.mon_cb.operand_a;
        txn.operand_b   = vif.mon_cb.operand_b;
        txn.operand_c   = vif.mon_cb.operand_c;
        txn.vector_mode = alu_seq_item::vec_mode_e'(vif.mon_cb.vector_mode);
        txn.bmask_a     = vif.mon_cb.bmask_a;
        txn.bmask_b     = vif.mon_cb.bmask_b;
        txn.imm_vec_ext = vif.mon_cb.imm_vec_ext;
        txn.is_clpx     = vif.mon_cb.is_clpx;
        txn.is_subrot   = vif.mon_cb.is_subrot;
        txn.clpx_shift  = vif.mon_cb.clpx_shift;
        txn.enable      = vif.mon_cb.enable;

        if (txn.operator inside {alu_seq_item::ALU_DIV, alu_seq_item::ALU_DIVU,
                                 alu_seq_item::ALU_REM, alu_seq_item::ALU_REMU}) begin
          wait (vif.mon_cb.ready === 1'b1);
          @(vif.mon_cb);
        end

        txn.result            = vif.mon_cb.result;
        txn.comparison_result = vif.mon_cb.comparison_result;
        txn.ready             = vif.mon_cb.ready;

        sample_coverage();

        ap.write(txn);

        `uvm_info(get_type_name(), $sformatf("Monitored: op=%s a=0x%08h b=0x%08h result=0x%08h",
                  txn.operator.name(), txn.operand_a, txn.operand_b, txn.result), UVM_HIGH)
      end
    end
  endtask

  function void sample_coverage();
    cv32e40p_pkg::alu_opcode_e op;
    op = cv32e40p_pkg::alu_opcode_e'(vif.mon_cb.operator);

    cg_opcode.sample();
    cg_operand_ranges.sample();
    cg_vector_mode.sample();
    cg_clpx.sample();
    cg_cross_op_vec.sample();

    // Track individual opcode hits
    case (op)
      cv32e40p_pkg::ALU_ADD, cv32e40p_pkg::ALU_SUB,
      cv32e40p_pkg::ALU_ADDU, cv32e40p_pkg::ALU_SUBU,
      cv32e40p_pkg::ALU_ADDR, cv32e40p_pkg::ALU_SUBR,
      cv32e40p_pkg::ALU_ADDUR, cv32e40p_pkg::ALU_SUBUR:
        arith_hit[op] = 1;

      cv32e40p_pkg::ALU_AND, cv32e40p_pkg::ALU_OR, cv32e40p_pkg::ALU_XOR:
        logic_hit[op] = 1;

      cv32e40p_pkg::ALU_SLL, cv32e40p_pkg::ALU_SRL,
      cv32e40p_pkg::ALU_SRA, cv32e40p_pkg::ALU_ROR:
        shift_hit[op] = 1;

      cv32e40p_pkg::ALU_EQ, cv32e40p_pkg::ALU_NE,
      cv32e40p_pkg::ALU_GTS, cv32e40p_pkg::ALU_GES,
      cv32e40p_pkg::ALU_LTS, cv32e40p_pkg::ALU_LES,
      cv32e40p_pkg::ALU_GTU, cv32e40p_pkg::ALU_GEU,
      cv32e40p_pkg::ALU_LTU, cv32e40p_pkg::ALU_LEU:
        cmp_hit[op] = 1;

      cv32e40p_pkg::ALU_SLTS, cv32e40p_pkg::ALU_SLTU,
      cv32e40p_pkg::ALU_SLETS, cv32e40p_pkg::ALU_SLETU:
        slt_hit[op] = 1;

      cv32e40p_pkg::ALU_MIN, cv32e40p_pkg::ALU_MINU,
      cv32e40p_pkg::ALU_MAX, cv32e40p_pkg::ALU_MAXU,
      cv32e40p_pkg::ALU_ABS, cv32e40p_pkg::ALU_CLIP,
      cv32e40p_pkg::ALU_CLIPU:
        minmax_hit[op] = 1;

      cv32e40p_pkg::ALU_BEXT, cv32e40p_pkg::ALU_BEXTU,
      cv32e40p_pkg::ALU_BINS, cv32e40p_pkg::ALU_BCLR,
      cv32e40p_pkg::ALU_BSET, cv32e40p_pkg::ALU_BREV:
        bitman_hit[op] = 1;

      cv32e40p_pkg::ALU_FF1, cv32e40p_pkg::ALU_FL1,
      cv32e40p_pkg::ALU_CNT, cv32e40p_pkg::ALU_CLB:
        bitcnt_hit[op] = 1;

      cv32e40p_pkg::ALU_DIV, cv32e40p_pkg::ALU_DIVU,
      cv32e40p_pkg::ALU_REM, cv32e40p_pkg::ALU_REMU:
        div_hit[op] = 1;

      cv32e40p_pkg::ALU_SHUF, cv32e40p_pkg::ALU_SHUF2,
      cv32e40p_pkg::ALU_PCKLO, cv32e40p_pkg::ALU_PCKHI,
      cv32e40p_pkg::ALU_EXT, cv32e40p_pkg::ALU_EXTS,
      cv32e40p_pkg::ALU_INS:
        shuf_hit[op] = 1;

      default: ;
    endcase

    if (op inside {cv32e40p_pkg::ALU_SLL, cv32e40p_pkg::ALU_SRL,
                   cv32e40p_pkg::ALU_SRA, cv32e40p_pkg::ALU_ROR})
      cg_shift_amount.sample();

    if (op inside {cv32e40p_pkg::ALU_BEXT, cv32e40p_pkg::ALU_BEXTU,
                   cv32e40p_pkg::ALU_BINS, cv32e40p_pkg::ALU_BCLR,
                   cv32e40p_pkg::ALU_BSET, cv32e40p_pkg::ALU_BREV})
      cg_bmask.sample();

    if (op inside {cv32e40p_pkg::ALU_DIV, cv32e40p_pkg::ALU_DIVU,
                   cv32e40p_pkg::ALU_REM, cv32e40p_pkg::ALU_REMU})
      cg_division.sample();
  endfunction

  function void report_phase(uvm_phase phase);
    string report_str;

    report_str = "\n";
    report_str = {report_str, "================================================================================\n"};
    report_str = {report_str, "                         ALU COVERAGE REPORT\n"};
    report_str = {report_str, "================================================================================\n\n"};

    // Overall Summary
    report_str = {report_str, "--- OVERALL SUMMARY ---\n"};
    report_str = {report_str, $sformatf("  Opcode Coverage:        %6.2f%%\n", cg_opcode.get_coverage())};
    report_str = {report_str, $sformatf("  Operand Range Coverage: %6.2f%%\n", cg_operand_ranges.get_coverage())};
    report_str = {report_str, $sformatf("  Vector Mode Coverage:   %6.2f%%\n", cg_vector_mode.get_coverage())};
    report_str = {report_str, $sformatf("  Shift Amount Coverage:  %6.2f%%\n", cg_shift_amount.get_coverage())};
    report_str = {report_str, $sformatf("  Bmask Coverage:         %6.2f%%\n", cg_bmask.get_coverage())};
    report_str = {report_str, $sformatf("  Division Coverage:      %6.2f%%\n", cg_division.get_coverage())};
    report_str = {report_str, $sformatf("  CLPX Coverage:          %6.2f%%\n", cg_clpx.get_coverage())};
    report_str = {report_str, $sformatf("  Op x Vec Cross Cov:     %6.2f%%\n\n", cg_cross_op_vec.get_coverage())};

    // Opcode Details using hit tracking
    report_str = {report_str, "--- OPCODE COVERAGE DETAILS ---\n"};
    report_str = {report_str, $sformatf("  Arithmetic (%0d/8): ", arith_hit.size())};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_ADD) ? "ADD " : ""};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_SUB) ? "SUB " : ""};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_ADDU) ? "ADDU " : ""};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_SUBU) ? "SUBU " : ""};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_ADDR) ? "ADDR " : ""};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_SUBR) ? "SUBR " : ""};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_ADDUR) ? "ADDUR " : ""};
    report_str = {report_str, arith_hit.exists(cv32e40p_pkg::ALU_SUBUR) ? "SUBUR " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Logic (%0d/3): ", logic_hit.size())};
    report_str = {report_str, logic_hit.exists(cv32e40p_pkg::ALU_AND) ? "AND " : ""};
    report_str = {report_str, logic_hit.exists(cv32e40p_pkg::ALU_OR) ? "OR " : ""};
    report_str = {report_str, logic_hit.exists(cv32e40p_pkg::ALU_XOR) ? "XOR " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Shift (%0d/4): ", shift_hit.size())};
    report_str = {report_str, shift_hit.exists(cv32e40p_pkg::ALU_SLL) ? "SLL " : ""};
    report_str = {report_str, shift_hit.exists(cv32e40p_pkg::ALU_SRL) ? "SRL " : ""};
    report_str = {report_str, shift_hit.exists(cv32e40p_pkg::ALU_SRA) ? "SRA " : ""};
    report_str = {report_str, shift_hit.exists(cv32e40p_pkg::ALU_ROR) ? "ROR " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Compare (%0d/10): ", cmp_hit.size())};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_EQ) ? "EQ " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_NE) ? "NE " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_GTS) ? "GTS " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_GES) ? "GES " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_LTS) ? "LTS " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_LES) ? "LES " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_GTU) ? "GTU " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_GEU) ? "GEU " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_LTU) ? "LTU " : ""};
    report_str = {report_str, cmp_hit.exists(cv32e40p_pkg::ALU_LEU) ? "LEU " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Set Less Than (%0d/4): ", slt_hit.size())};
    report_str = {report_str, slt_hit.exists(cv32e40p_pkg::ALU_SLTS) ? "SLTS " : ""};
    report_str = {report_str, slt_hit.exists(cv32e40p_pkg::ALU_SLTU) ? "SLTU " : ""};
    report_str = {report_str, slt_hit.exists(cv32e40p_pkg::ALU_SLETS) ? "SLETS " : ""};
    report_str = {report_str, slt_hit.exists(cv32e40p_pkg::ALU_SLETU) ? "SLETU " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Min/Max (%0d/7): ", minmax_hit.size())};
    report_str = {report_str, minmax_hit.exists(cv32e40p_pkg::ALU_MIN) ? "MIN " : ""};
    report_str = {report_str, minmax_hit.exists(cv32e40p_pkg::ALU_MINU) ? "MINU " : ""};
    report_str = {report_str, minmax_hit.exists(cv32e40p_pkg::ALU_MAX) ? "MAX " : ""};
    report_str = {report_str, minmax_hit.exists(cv32e40p_pkg::ALU_MAXU) ? "MAXU " : ""};
    report_str = {report_str, minmax_hit.exists(cv32e40p_pkg::ALU_ABS) ? "ABS " : ""};
    report_str = {report_str, minmax_hit.exists(cv32e40p_pkg::ALU_CLIP) ? "CLIP " : ""};
    report_str = {report_str, minmax_hit.exists(cv32e40p_pkg::ALU_CLIPU) ? "CLIPU " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Bit Manip (%0d/6): ", bitman_hit.size())};
    report_str = {report_str, bitman_hit.exists(cv32e40p_pkg::ALU_BEXT) ? "BEXT " : ""};
    report_str = {report_str, bitman_hit.exists(cv32e40p_pkg::ALU_BEXTU) ? "BEXTU " : ""};
    report_str = {report_str, bitman_hit.exists(cv32e40p_pkg::ALU_BINS) ? "BINS " : ""};
    report_str = {report_str, bitman_hit.exists(cv32e40p_pkg::ALU_BCLR) ? "BCLR " : ""};
    report_str = {report_str, bitman_hit.exists(cv32e40p_pkg::ALU_BSET) ? "BSET " : ""};
    report_str = {report_str, bitman_hit.exists(cv32e40p_pkg::ALU_BREV) ? "BREV " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Bit Count (%0d/4): ", bitcnt_hit.size())};
    report_str = {report_str, bitcnt_hit.exists(cv32e40p_pkg::ALU_FF1) ? "FF1 " : ""};
    report_str = {report_str, bitcnt_hit.exists(cv32e40p_pkg::ALU_FL1) ? "FL1 " : ""};
    report_str = {report_str, bitcnt_hit.exists(cv32e40p_pkg::ALU_CNT) ? "CNT " : ""};
    report_str = {report_str, bitcnt_hit.exists(cv32e40p_pkg::ALU_CLB) ? "CLB " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Division (%0d/4): ", div_hit.size())};
    report_str = {report_str, div_hit.exists(cv32e40p_pkg::ALU_DIV) ? "DIV " : ""};
    report_str = {report_str, div_hit.exists(cv32e40p_pkg::ALU_DIVU) ? "DIVU " : ""};
    report_str = {report_str, div_hit.exists(cv32e40p_pkg::ALU_REM) ? "REM " : ""};
    report_str = {report_str, div_hit.exists(cv32e40p_pkg::ALU_REMU) ? "REMU " : ""};
    report_str = {report_str, "\n"};

    report_str = {report_str, $sformatf("  Shuffle (%0d/7): ", shuf_hit.size())};
    report_str = {report_str, shuf_hit.exists(cv32e40p_pkg::ALU_SHUF) ? "SHUF " : ""};
    report_str = {report_str, shuf_hit.exists(cv32e40p_pkg::ALU_SHUF2) ? "SHUF2 " : ""};
    report_str = {report_str, shuf_hit.exists(cv32e40p_pkg::ALU_PCKLO) ? "PCKLO " : ""};
    report_str = {report_str, shuf_hit.exists(cv32e40p_pkg::ALU_PCKHI) ? "PCKHI " : ""};
    report_str = {report_str, shuf_hit.exists(cv32e40p_pkg::ALU_EXT) ? "EXT " : ""};
    report_str = {report_str, shuf_hit.exists(cv32e40p_pkg::ALU_EXTS) ? "EXTS " : ""};
    report_str = {report_str, shuf_hit.exists(cv32e40p_pkg::ALU_INS) ? "INS " : ""};
    report_str = {report_str, "\n\n"};

    // Operand A Details
    report_str = {report_str, "--- OPERAND_A RANGE COVERAGE ---\n"};
    report_str = {report_str, $sformatf("  zero (0x00000000):        %s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("zero") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  one (0x00000001):         %s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("one") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  all_ones (0xFFFFFFFF):    %s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("all_ones") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  max_signed (0x7FFFFFFF):  %s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("max_signed") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  min_signed (0x80000000):  %s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("min_signed") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  small_pos (0x02-0xFF):    %s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("small_pos") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  small_neg (0xFFFFFF00-FE):%s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("small_neg") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  mid_pos (0x100-0x7FFFFFFE):%s\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("mid_pos") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  mid_neg (0x80000001-FEFF):%s\n\n",
                  cg_operand_ranges.cp_operand_a.get_coverage("mid_neg") > 0 ? "HIT" : "MISS")};

    // Operand B Details
    report_str = {report_str, "--- OPERAND_B RANGE COVERAGE ---\n"};
    report_str = {report_str, $sformatf("  zero (0x00000000):        %s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("zero") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  one (0x00000001):         %s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("one") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  all_ones (0xFFFFFFFF):    %s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("all_ones") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  max_signed (0x7FFFFFFF):  %s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("max_signed") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  min_signed (0x80000000):  %s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("min_signed") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  small_pos (0x02-0xFF):    %s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("small_pos") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  small_neg (0xFFFFFF00-FE):%s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("small_neg") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  mid_pos (0x100-0x7FFFFFFE):%s\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("mid_pos") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  mid_neg (0x80000001-FEFF):%s\n\n",
                  cg_operand_ranges.cp_operand_b.get_coverage("mid_neg") > 0 ? "HIT" : "MISS")};

    // Vector Mode Details
    report_str = {report_str, "--- VECTOR MODE COVERAGE ---\n"};
    report_str = {report_str, $sformatf("  VEC_MODE32 (2'b00): %s\n",
                  cg_vector_mode.cp_vec_mode.get_coverage("mode32") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  VEC_MODE16 (2'b10): %s\n",
                  cg_vector_mode.cp_vec_mode.get_coverage("mode16") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  VEC_MODE8  (2'b11): %s\n\n",
                  cg_vector_mode.cp_vec_mode.get_coverage("mode8") > 0 ? "HIT" : "MISS")};

    // Shift Amount Details
    report_str = {report_str, "--- SHIFT AMOUNT COVERAGE ---\n"};
    report_str = {report_str, $sformatf("  zero (0):      %s\n",
                  cg_shift_amount.cp_shift_amt.get_coverage("zero") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  one (1):       %s\n",
                  cg_shift_amount.cp_shift_amt.get_coverage("one") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  max (31):      %s\n",
                  cg_shift_amount.cp_shift_amt.get_coverage("max") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  low (2-7):     %s\n",
                  cg_shift_amount.cp_shift_amt.get_coverage("low") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  mid (8-23):    %s\n",
                  cg_shift_amount.cp_shift_amt.get_coverage("mid") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  high (24-30):  %s\n\n",
                  cg_shift_amount.cp_shift_amt.get_coverage("high") > 0 ? "HIT" : "MISS")};

    // Division Details
    report_str = {report_str, "--- DIVISION COVERAGE ---\n"};
    report_str = {report_str, $sformatf("  Divisor zero:    %s\n",
                  cg_division.cp_divisor.get_coverage("zero") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  Divisor one:     %s\n",
                  cg_division.cp_divisor.get_coverage("one") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  Divisor neg_one: %s\n",
                  cg_division.cp_divisor.get_coverage("neg_one") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  Dividend zero:   %s\n",
                  cg_division.cp_dividend.get_coverage("zero") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  Dividend min_neg:%s\n\n",
                  cg_division.cp_dividend.get_coverage("min_neg") > 0 ? "HIT" : "MISS")};

    // CLPX Details
    report_str = {report_str, "--- CLPX COVERAGE ---\n"};
    report_str = {report_str, $sformatf("  is_clpx=0:   %s\n",
                  cg_clpx.cp_is_clpx.get_coverage("off") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  is_clpx=1:   %s\n",
                  cg_clpx.cp_is_clpx.get_coverage("on") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  is_subrot=0: %s\n",
                  cg_clpx.cp_is_subrot.get_coverage("off") > 0 ? "HIT" : "MISS")};
    report_str = {report_str, $sformatf("  is_subrot=1: %s\n\n",
                  cg_clpx.cp_is_subrot.get_coverage("on") > 0 ? "HIT" : "MISS")};

    // Cross Coverage Summary
    report_str = {report_str, "--- CROSS COVERAGE ---\n"};
    report_str = {report_str, $sformatf("  Operand A x B cross:     %6.2f%% (%0d/81 bins)\n",
                  cg_operand_ranges.cx_a_b.get_coverage(),
                  $rtoi(cg_operand_ranges.cx_a_b.get_coverage() * 81 / 100))};
    report_str = {report_str, $sformatf("  Op x Vec cross:          %6.2f%% (%0d/27 bins)\n",
                  cg_cross_op_vec.cx_op_vec.get_coverage(),
                  $rtoi(cg_cross_op_vec.cx_op_vec.get_coverage() * 27 / 100))};
    report_str = {report_str, $sformatf("  Bmask A x B cross:       %6.2f%%\n",
                  cg_bmask.cx_bmask.get_coverage())};
    report_str = {report_str, $sformatf("  Division cross:          %6.2f%%\n\n",
                  cg_division.cx_div.get_coverage())};

    report_str = {report_str, "================================================================================\n"};

    `uvm_info(get_type_name(), report_str, UVM_LOW)
  endfunction

endclass

`endif
