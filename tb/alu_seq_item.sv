`ifndef ALU_SEQ_ITEM_SV
`define ALU_SEQ_ITEM_SV

class alu_seq_item extends uvm_sequence_item;

  // ALU opcode enumeration (matches cv32e40p_pkg)
  typedef enum logic [6:0] {
    ALU_ADD   = 7'b0011000,
    ALU_SUB   = 7'b0011001,
    ALU_ADDU  = 7'b0011010,
    ALU_SUBU  = 7'b0011011,
    ALU_ADDR  = 7'b0011100,
    ALU_SUBR  = 7'b0011101,
    ALU_ADDUR = 7'b0011110,
    ALU_SUBUR = 7'b0011111,
    ALU_XOR   = 7'b0101111,
    ALU_OR    = 7'b0101110,
    ALU_AND   = 7'b0010101,
    ALU_SRA   = 7'b0100100,
    ALU_SRL   = 7'b0100101,
    ALU_ROR   = 7'b0100110,
    ALU_SLL   = 7'b0100111,
    ALU_BEXT  = 7'b0101000,
    ALU_BEXTU = 7'b0101001,
    ALU_BINS  = 7'b0101010,
    ALU_BCLR  = 7'b0101011,
    ALU_BSET  = 7'b0101100,
    ALU_BREV  = 7'b1001001,
    ALU_FF1   = 7'b0110110,
    ALU_FL1   = 7'b0110111,
    ALU_CNT   = 7'b0110100,
    ALU_CLB   = 7'b0110101,
    ALU_EXTS  = 7'b0111110,
    ALU_EXT   = 7'b0111111,
    ALU_LTS   = 7'b0000000,
    ALU_LTU   = 7'b0000001,
    ALU_LES   = 7'b0000100,
    ALU_LEU   = 7'b0000101,
    ALU_GTS   = 7'b0001000,
    ALU_GTU   = 7'b0001001,
    ALU_GES   = 7'b0001010,
    ALU_GEU   = 7'b0001011,
    ALU_EQ    = 7'b0001100,
    ALU_NE    = 7'b0001101,
    ALU_SLTS  = 7'b0000010,
    ALU_SLTU  = 7'b0000011,
    ALU_SLETS = 7'b0000110,
    ALU_SLETU = 7'b0000111,
    ALU_ABS   = 7'b0010100,
    ALU_CLIP  = 7'b0010110,
    ALU_CLIPU = 7'b0010111,
    ALU_INS   = 7'b0101101,
    ALU_MIN   = 7'b0010000,
    ALU_MINU  = 7'b0010001,
    ALU_MAX   = 7'b0010010,
    ALU_MAXU  = 7'b0010011,
    ALU_DIVU  = 7'b0110000,
    ALU_DIV   = 7'b0110001,
    ALU_REMU  = 7'b0110010,
    ALU_REM   = 7'b0110011,
    ALU_SHUF  = 7'b0111010,
    ALU_SHUF2 = 7'b0111011,
    ALU_PCKLO = 7'b0111000,
    ALU_PCKHI = 7'b0111001
  } alu_opcode_e;

  // Vector mode constants
  typedef enum logic [1:0] {
    VEC_MODE32 = 2'b00,
    VEC_MODE16 = 2'b10,
    VEC_MODE8  = 2'b11
  } vec_mode_e;

  // Stimulus fields
  rand alu_opcode_e       operator;
  rand logic [31:0]       operand_a;
  rand logic [31:0]       operand_b;
  rand logic [31:0]       operand_c;
  rand vec_mode_e         vector_mode;
  rand logic [4:0]        bmask_a;
  rand logic [4:0]        bmask_b;
  rand logic [1:0]        imm_vec_ext;
  rand logic              is_clpx;
  rand logic              is_subrot;
  rand logic [1:0]        clpx_shift;
  rand logic              enable;

  // Response fields
  logic [31:0]            result;
  logic                   comparison_result;
  logic                   ready;

  `uvm_object_utils_begin(alu_seq_item)
    `uvm_field_enum(alu_opcode_e, operator, UVM_ALL_ON)
    `uvm_field_int(operand_a, UVM_ALL_ON)
    `uvm_field_int(operand_b, UVM_ALL_ON)
    `uvm_field_int(operand_c, UVM_ALL_ON)
    `uvm_field_enum(vec_mode_e, vector_mode, UVM_ALL_ON)
    `uvm_field_int(bmask_a, UVM_ALL_ON)
    `uvm_field_int(bmask_b, UVM_ALL_ON)
    `uvm_field_int(imm_vec_ext, UVM_ALL_ON)
    `uvm_field_int(is_clpx, UVM_ALL_ON)
    `uvm_field_int(is_subrot, UVM_ALL_ON)
    `uvm_field_int(clpx_shift, UVM_ALL_ON)
    `uvm_field_int(enable, UVM_ALL_ON)
    `uvm_field_int(result, UVM_ALL_ON)
    `uvm_field_int(comparison_result, UVM_ALL_ON)
    `uvm_field_int(ready, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "alu_seq_item");
    super.new(name);
  endfunction

  // ============================================================
  // Base Constraints: 30% boundary values, 70% random
  // ============================================================

  constraint c_operand_a_dist {
    operand_a dist {
      32'h00000000 := 5,
      32'h00000001 := 5,
      32'hFFFFFFFF := 5,
      32'h7FFFFFFF := 5,
      32'h80000000 := 5,
      32'h7FFFFFFE := 2,
      32'h80000001 := 2,
      [32'h00000002:32'h7FFFFFFD] :/ 35,
      [32'h80000002:32'hFFFFFFFE] :/ 36
    };
  }

  constraint c_operand_b_dist {
    operand_b dist {
      32'h00000000 := 5,
      32'h00000001 := 5,
      32'hFFFFFFFF := 5,
      32'h7FFFFFFF := 5,
      32'h80000000 := 5,
      32'h7FFFFFFE := 2,
      32'h80000001 := 2,
      [32'h00000002:32'h7FFFFFFD] :/ 35,
      [32'h80000002:32'hFFFFFFFE] :/ 36
    };
  }

  constraint c_operand_c_dist {
    operand_c dist {
      32'h00000000 := 10,
      32'hFFFFFFFF := 10,
      [32'h00000001:32'hFFFFFFFE] :/ 80
    };
  }

  // ============================================================
  // Vector Mode Distribution
  // ============================================================

  constraint c_vector_mode_dist {
    vector_mode dist {
      VEC_MODE32 := 40,
      VEC_MODE16 := 30,
      VEC_MODE8  := 30
    };
  }

  // ============================================================
  // Shift Amount Constraints (operand_b[4:0] for shift ops)
  // ============================================================

  constraint c_shift_amount {
    if (operator inside {ALU_SLL, ALU_SRL, ALU_SRA, ALU_ROR}) {
      operand_b[4:0] dist {
        5'd0  := 10,
        5'd1  := 10,
        5'd31 := 10,
        [5'd2:5'd30] :/ 70
      };
    }
  }

  // ============================================================
  // Division Constraints
  // ============================================================

  constraint c_division {
    if (operator inside {ALU_DIV, ALU_DIVU, ALU_REM, ALU_REMU}) {
      operand_b dist {
        32'h00000000 := 5,
        32'h00000001 := 10,
        32'hFFFFFFFF := 5,
        [32'h00000002:32'hFFFFFFFE] :/ 80
      };
      operand_a dist {
        32'h00000000 := 5,
        32'h80000000 := 5,
        [32'h00000001:32'h7FFFFFFF] :/ 45,
        [32'h80000001:32'hFFFFFFFF] :/ 45
      };
      enable == 1'b1;
    }
  }

  // ============================================================
  // Bit Manipulation Constraints
  // ============================================================

  constraint c_bmask_a_dist {
    if (operator inside {ALU_BEXT, ALU_BEXTU, ALU_BINS, ALU_BCLR, ALU_BSET, ALU_BREV}) {
      bmask_a dist {
        5'd0  := 10,
        5'd7  := 15,
        5'd15 := 15,
        5'd31 := 10,
        [5'd1:5'd6]   :/ 15,
        [5'd8:5'd14]  :/ 15,
        [5'd16:5'd30] :/ 20
      };
    }
  }

  constraint c_bmask_b_dist {
    if (operator inside {ALU_BEXT, ALU_BEXTU, ALU_BINS, ALU_BCLR, ALU_BSET}) {
      bmask_b dist {
        5'd0  := 20,
        5'd8  := 10,
        5'd16 := 10,
        5'd24 := 10,
        [5'd1:5'd7]   :/ 15,
        [5'd9:5'd15]  :/ 15,
        [5'd17:5'd23] :/ 10,
        [5'd25:5'd31] :/ 10
      };
    }
  }

  constraint c_bmask_valid_range {
    if (operator inside {ALU_BEXT, ALU_BEXTU, ALU_BINS, ALU_BCLR, ALU_BSET}) {
      bmask_a + bmask_b <= 31;
    }
  }

  // ============================================================
  // Complex Number (CLPX) Constraints
  // ============================================================

  constraint c_clpx_default {
    is_clpx dist {
      1'b0 := 90,
      1'b1 := 10
    };
    is_subrot dist {
      1'b0 := 90,
      1'b1 := 10
    };
  }

  constraint c_clpx_ops {
    if (is_clpx == 1'b1) {
      operator inside {ALU_ADD, ALU_SUB, ALU_ABS};
      vector_mode == VEC_MODE16;
    }
    if (is_subrot == 1'b1) {
      operator == ALU_SUB;
      vector_mode == VEC_MODE16;
    }
  }

  // ============================================================
  // Enable Signal Constraint
  // ============================================================

  constraint c_enable_default {
    if (operator inside {ALU_DIV, ALU_DIVU, ALU_REM, ALU_REMU}) {
      enable == 1'b1;
    } else {
      enable dist {
        1'b1 := 95,
        1'b0 := 5
      };
    }
  }

  // ============================================================
  // Extension Operation Constraints
  // ============================================================

  constraint c_imm_vec_ext {
    if (operator inside {ALU_EXT, ALU_EXTS, ALU_INS}) {
      if (vector_mode == VEC_MODE8) {
        imm_vec_ext inside {2'b00, 2'b01, 2'b10, 2'b11};
      } else if (vector_mode == VEC_MODE16) {
        imm_vec_ext inside {2'b00, 2'b01};
      } else {
        imm_vec_ext == 2'b00;
      }
    }
  }

  // ============================================================
  // Vector Mode Per-Lane Boundary Constraints
  // ============================================================

  constraint c_vec8_lane_boundaries {
    if (vector_mode == VEC_MODE8) {
      operand_a[7:0]   dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
      operand_a[15:8]  dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
      operand_a[23:16] dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
      operand_a[31:24] dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
    }
  }

  constraint c_vec16_lane_boundaries {
    if (vector_mode == VEC_MODE16) {
      operand_a[15:0]  dist {16'h0000 := 10, 16'h7FFF := 10, 16'h8000 := 10, 16'hFFFF := 10, [16'h0001:16'h7FFE] :/ 30, [16'h8001:16'hFFFE] :/ 30};
      operand_a[31:16] dist {16'h0000 := 10, 16'h7FFF := 10, 16'h8000 := 10, 16'hFFFF := 10, [16'h0001:16'h7FFE] :/ 30, [16'h8001:16'hFFFE] :/ 30};
    }
  }

  // ============================================================
  // Clip Operation Constraints
  // ============================================================

  constraint c_clip_operand_b {
    if (operator inside {ALU_CLIP, ALU_CLIPU}) {
      operand_b dist {
        32'h00000000 := 5,
        32'h0000000F := 10,
        32'h000000FF := 10,
        32'h0000FFFF := 10,
        32'h7FFFFFFF := 5,
        [32'h00000001:32'h0000000E] :/ 20,
        [32'h00000010:32'h7FFFFFFE] :/ 40
      };
    }
  }

endclass

`endif
