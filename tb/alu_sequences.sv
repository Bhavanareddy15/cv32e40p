`ifndef ALU_SEQUENCES_SV
`define ALU_SEQUENCES_SV

// ============================================================
// Base ALU Sequence
// ============================================================
class alu_base_sequence extends uvm_sequence #(alu_seq_item);
  `uvm_object_utils(alu_base_sequence)

  int unsigned num_transactions = 100;

  function new(string name = "alu_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize())
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Arithmetic Operations Sequence
// ============================================================
class alu_arith_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_arith_sequence)

  function new(string name = "alu_arith_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_ADD, alu_seq_item::ALU_SUB,
                         alu_seq_item::ALU_ADDU, alu_seq_item::ALU_SUBU,
                         alu_seq_item::ALU_ADDR, alu_seq_item::ALU_SUBR,
                         alu_seq_item::ALU_ADDUR, alu_seq_item::ALU_SUBUR};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Logical Operations Sequence
// ============================================================
class alu_logic_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_logic_sequence)

  function new(string name = "alu_logic_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_AND, alu_seq_item::ALU_OR, alu_seq_item::ALU_XOR};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Shift Operations Sequence
// ============================================================
class alu_shift_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_shift_sequence)

  function new(string name = "alu_shift_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_SLL, alu_seq_item::ALU_SRL,
                         alu_seq_item::ALU_SRA, alu_seq_item::ALU_ROR};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Comparison Operations Sequence
// ============================================================
class alu_compare_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_compare_sequence)

  function new(string name = "alu_compare_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_LTS, alu_seq_item::ALU_LTU,
                         alu_seq_item::ALU_LES, alu_seq_item::ALU_LEU,
                         alu_seq_item::ALU_GTS, alu_seq_item::ALU_GTU,
                         alu_seq_item::ALU_GES, alu_seq_item::ALU_GEU,
                         alu_seq_item::ALU_EQ, alu_seq_item::ALU_NE,
                         alu_seq_item::ALU_SLTS, alu_seq_item::ALU_SLTU,
                         alu_seq_item::ALU_SLETS, alu_seq_item::ALU_SLETU};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Min/Max/Abs/Clip Operations Sequence
// ============================================================
class alu_minmax_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_minmax_sequence)

  function new(string name = "alu_minmax_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_MIN, alu_seq_item::ALU_MINU,
                         alu_seq_item::ALU_MAX, alu_seq_item::ALU_MAXU,
                         alu_seq_item::ALU_ABS, alu_seq_item::ALU_CLIP,
                         alu_seq_item::ALU_CLIPU};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Division Operations Sequence
// ============================================================
class alu_div_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_div_sequence)

  function new(string name = "alu_div_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_DIV, alu_seq_item::ALU_DIVU,
                         alu_seq_item::ALU_REM, alu_seq_item::ALU_REMU};
        enable == 1'b1;
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Bit Manipulation Operations Sequence
// ============================================================
class alu_bitmanip_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_bitmanip_sequence)

  function new(string name = "alu_bitmanip_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_BEXT, alu_seq_item::ALU_BEXTU,
                         alu_seq_item::ALU_BINS, alu_seq_item::ALU_BCLR,
                         alu_seq_item::ALU_BSET, alu_seq_item::ALU_BREV};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Bit Counting Operations Sequence
// ============================================================
class alu_bitcount_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_bitcount_sequence)

  function new(string name = "alu_bitcount_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_FF1, alu_seq_item::ALU_FL1,
                         alu_seq_item::ALU_CNT, alu_seq_item::ALU_CLB};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Shuffle/Pack Operations Sequence
// ============================================================
class alu_shuffle_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_shuffle_sequence)

  function new(string name = "alu_shuffle_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_SHUF, alu_seq_item::ALU_SHUF2,
                         alu_seq_item::ALU_PCKLO, alu_seq_item::ALU_PCKHI,
                         alu_seq_item::ALU_EXT, alu_seq_item::ALU_EXTS,
                         alu_seq_item::ALU_INS};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Vector Mode Sequence (VEC_MODE8 and VEC_MODE16)
// ============================================================
class alu_vector_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_vector_sequence)

  function new(string name = "alu_vector_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        vector_mode inside {alu_seq_item::VEC_MODE8, alu_seq_item::VEC_MODE16};
        operator inside {alu_seq_item::ALU_ADD, alu_seq_item::ALU_SUB,
                         alu_seq_item::ALU_AND, alu_seq_item::ALU_OR,
                         alu_seq_item::ALU_XOR, alu_seq_item::ALU_GTS,
                         alu_seq_item::ALU_GES, alu_seq_item::ALU_LTS,
                         alu_seq_item::ALU_LES, alu_seq_item::ALU_GTU,
                         alu_seq_item::ALU_GEU, alu_seq_item::ALU_LTU,
                         alu_seq_item::ALU_LEU, alu_seq_item::ALU_MIN,
                         alu_seq_item::ALU_MINU, alu_seq_item::ALU_MAX,
                         alu_seq_item::ALU_MAXU, alu_seq_item::ALU_SLL,
                         alu_seq_item::ALU_SRL, alu_seq_item::ALU_SRA};
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Sign Transition Sequence (Overflow/Underflow Focus)
// ============================================================
class alu_sign_transition_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_sign_transition_sequence)

  function new(string name = "alu_sign_transition_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        operator inside {alu_seq_item::ALU_ADD, alu_seq_item::ALU_SUB,
                         alu_seq_item::ALU_ADDU, alu_seq_item::ALU_SUBU};
        (operand_a inside {32'h7FFFFFFF, 32'h80000000, 32'h7FFFFFFE, 32'h80000001}) ||
        (operand_b inside {32'h7FFFFFFF, 32'h80000000, 32'h7FFFFFFE, 32'h80000001});
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Corner Case Sequence (Boundary Values)
// ============================================================
class alu_corner_case_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_corner_case_sequence)

  function new(string name = "alu_corner_case_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    logic [31:0] corner_values[$] = '{
      32'h00000000, 32'h00000001, 32'hFFFFFFFF,
      32'h7FFFFFFF, 32'h80000000, 32'h7FFFFFFE, 32'h80000001
    };

    foreach (corner_values[i]) begin
      foreach (corner_values[j]) begin
        txn = alu_seq_item::type_id::create("txn");
        start_item(txn);
        if (!txn.randomize() with {
          operand_a == corner_values[i];
          operand_b == corner_values[j];
        })
          `uvm_error(get_type_name(), "Randomization failed")
        finish_item(txn);
      end
    end
  endtask
endclass

// ============================================================
// Complex Number (CLPX) Sequence
// ============================================================
class alu_clpx_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_clpx_sequence)

  function new(string name = "alu_clpx_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        is_clpx == 1'b1;
        operator inside {alu_seq_item::ALU_ADD, alu_seq_item::ALU_SUB, alu_seq_item::ALU_ABS};
        vector_mode == alu_seq_item::VEC_MODE16;
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Subrot Sequence
// ============================================================
class alu_subrot_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_subrot_sequence)

  function new(string name = "alu_subrot_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        is_subrot == 1'b1;
        operator == alu_seq_item::ALU_SUB;
        vector_mode == alu_seq_item::VEC_MODE16;
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass

// ============================================================
// Full Coverage Sequence (All Operations)
// ============================================================
class alu_full_coverage_sequence extends uvm_sequence #(alu_seq_item);
  `uvm_object_utils(alu_full_coverage_sequence)

  int unsigned txn_per_op = 1000;

  function new(string name = "alu_full_coverage_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_arith_sequence        arith_seq;
    alu_logic_sequence        logic_seq;
    alu_shift_sequence        shift_seq;
    alu_compare_sequence      compare_seq;
    alu_minmax_sequence       minmax_seq;
    alu_div_sequence          div_seq;
    alu_bitmanip_sequence     bitmanip_seq;
    alu_bitcount_sequence     bitcount_seq;
    alu_shuffle_sequence      shuffle_seq;
    alu_vector_sequence       vector_seq;
    alu_sign_transition_sequence sign_seq;
    alu_corner_case_sequence  corner_seq;
    alu_clpx_sequence         clpx_seq;
    alu_subrot_sequence       subrot_seq;

    `uvm_info(get_type_name(), "Starting full coverage sequence", UVM_LOW)

    arith_seq = alu_arith_sequence::type_id::create("arith_seq");
    arith_seq.num_transactions = txn_per_op;
    arith_seq.start(m_sequencer);

    logic_seq = alu_logic_sequence::type_id::create("logic_seq");
    logic_seq.num_transactions = txn_per_op;
    logic_seq.start(m_sequencer);

    shift_seq = alu_shift_sequence::type_id::create("shift_seq");
    shift_seq.num_transactions = txn_per_op;
    shift_seq.start(m_sequencer);

    compare_seq = alu_compare_sequence::type_id::create("compare_seq");
    compare_seq.num_transactions = txn_per_op;
    compare_seq.start(m_sequencer);

    minmax_seq = alu_minmax_sequence::type_id::create("minmax_seq");
    minmax_seq.num_transactions = txn_per_op;
    minmax_seq.start(m_sequencer);

    div_seq = alu_div_sequence::type_id::create("div_seq");
    div_seq.num_transactions = txn_per_op;
    div_seq.start(m_sequencer);

    bitmanip_seq = alu_bitmanip_sequence::type_id::create("bitmanip_seq");
    bitmanip_seq.num_transactions = txn_per_op;
    bitmanip_seq.start(m_sequencer);

    bitcount_seq = alu_bitcount_sequence::type_id::create("bitcount_seq");
    bitcount_seq.num_transactions = txn_per_op;
    bitcount_seq.start(m_sequencer);

    shuffle_seq = alu_shuffle_sequence::type_id::create("shuffle_seq");
    shuffle_seq.num_transactions = txn_per_op;
    shuffle_seq.start(m_sequencer);

    vector_seq = alu_vector_sequence::type_id::create("vector_seq");
    vector_seq.num_transactions = txn_per_op;
    vector_seq.start(m_sequencer);

    sign_seq = alu_sign_transition_sequence::type_id::create("sign_seq");
    sign_seq.num_transactions = txn_per_op;
    sign_seq.start(m_sequencer);

    corner_seq = alu_corner_case_sequence::type_id::create("corner_seq");
    corner_seq.start(m_sequencer);

    clpx_seq = alu_clpx_sequence::type_id::create("clpx_seq");
    clpx_seq.num_transactions = txn_per_op;
    clpx_seq.start(m_sequencer);

    subrot_seq = alu_subrot_sequence::type_id::create("subrot_seq");
    subrot_seq.num_transactions = txn_per_op;
    subrot_seq.start(m_sequencer);

    `uvm_info(get_type_name(), "Full coverage sequence complete", UVM_LOW)
  endtask
endclass

`endif
