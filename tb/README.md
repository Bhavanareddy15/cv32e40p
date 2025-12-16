# CV32E40P ALU UVM Testbench

## Overview

This UVM testbench verifies the CV32E40P ALU module, covering all arithmetic, logic, shift, comparison, division, bit manipulation, and vector operations.

## Directory Structure

```
tb/
├── alu_if.sv          # ALU interface definition
├── alu_pkg.sv         # Package including all TB components
├── alu_seq_item.sv    # Transaction item
├── alu_sequencer.sv   # Sequencer
├── alu_driver.sv      # Driver
├── alu_monitor.sv     # Monitor with coverage collection
├── alu_agent.sv       # Agent (driver + monitor + sequencer)
├── alu_env.sv         # Environment
├── alu_sequences.sv   # All test sequences
├── alu_test.sv        # All test classes
└── alu_tb_top.sv      # Testbench top module
```

## Setup and Compilation

### Prerequisites
- Synopsys VCS simulator with UVM support
- CV32E40P RTL source files

### Compile Command

```bash
cd work/cv32e40p
vcs -sverilog -ntb_opts uvm -timescale=1ns/1ps \
    +incdir+tb +incdir+rtl/include \
    rtl/include/cv32e40p_pkg.sv \
    tb/alu_if.sv \
    tb/alu_pkg.sv \
    tb/alu_tb_top.sv \
    rtl/cv32e40p_alu.sv \
    rtl/cv32e40p_popcnt.sv \
    rtl/cv32e40p_ff_one.sv \
    rtl/cv32e40p_alu_div.sv \
    -o simv
```

## Running Tests

### Basic Syntax
```bash
./simv +UVM_TESTNAME=<test_name>
```

### Available Tests

| Test Name | Description | Transactions |
|-----------|-------------|--------------|
| `alu_base_test` | Random operations across all ALU functions | 100 |
| `alu_arith_test` | Arithmetic operations (ADD, SUB, ADDU, SUBU, ADDR, SUBR, ADDUR, SUBUR) | 200 |
| `alu_logic_test` | Logical operations (AND, OR, XOR) | 200 |
| `alu_shift_test` | Shift operations (SLL, SRL, SRA, ROR) | 200 |
| `alu_compare_test` | Comparison operations (EQ, NE, LT, LE, GT, GE - signed/unsigned, SLT variants) | 200 |
| `alu_div_test` | Division operations (DIV, DIVU, REM, REMU) | 200 |
| `alu_bitmanip_test` | Bit manipulation (BEXT, BEXTU, BINS, BCLR, BSET, BREV) | 200 |
| `alu_vector_test` | Vector mode operations (VEC_MODE8, VEC_MODE16) | 200 |
| `alu_corner_case_test` | Boundary value testing (0, 1, -1, MAX, MIN) | 49 |
| `alu_full_coverage_test` | Comprehensive test running all sequences | ~1400 |

### Example Commands

```bash
# Run base test
./simv +UVM_TESTNAME=alu_base_test

# Run arithmetic test
./simv +UVM_TESTNAME=alu_arith_test

# Run full coverage test
./simv +UVM_TESTNAME=alu_full_coverage_test

# Run with increased verbosity
./simv +UVM_TESTNAME=alu_base_test +UVM_VERBOSITY=UVM_HIGH
```

## Coverage Categories

The monitor collects functional coverage across these categories:

| Category | Description |
|----------|-------------|
| Opcode Coverage | All 57 ALU operations grouped by type |
| Operand Range Coverage | Corner cases for operand_a and operand_b |
| Vector Mode Coverage | VEC_MODE32, VEC_MODE16, VEC_MODE8 |
| Shift Amount Coverage | Shift values 0, 1, 31, and ranges |
| Bmask Coverage | Bit manipulation mask values (6 opcodes) |
| Division Coverage | Division opcodes and corner cases (4 opcodes) |
| CLPX Coverage | Complex number mode flags |
| Cross Coverage | Operand combinations, Op x Vector mode |

## Test Sequences

The following sequences are available for custom test development:

| Sequence | Target Operations |
|----------|-------------------|
| `alu_base_sequence` | All operations (random) |
| `alu_arith_sequence` | ADD, SUB, ADDU, SUBU, ADDR, SUBR, ADDUR, SUBUR |
| `alu_logic_sequence` | AND, OR, XOR |
| `alu_shift_sequence` | SLL, SRL, SRA, ROR |
| `alu_compare_sequence` | LTS, LTU, LES, LEU, GTS, GTU, GES, GEU, EQ, NE, SLTS, SLTU, SLETS, SLETU |
| `alu_minmax_sequence` | MIN, MINU, MAX, MAXU, ABS, CLIP, CLIPU |
| `alu_div_sequence` | DIV, DIVU, REM, REMU |
| `alu_bitmanip_sequence` | BEXT, BEXTU, BINS, BCLR, BSET, BREV |
| `alu_bitcount_sequence` | FF1, FL1, CNT, CLB |
| `alu_shuffle_sequence` | SHUF, SHUF2, PCKLO, PCKHI, EXT, EXTS, INS |
| `alu_vector_sequence` | Vector mode operations (VEC_MODE8, VEC_MODE16) |
| `alu_sign_transition_sequence` | Overflow/underflow boundary cases |
| `alu_corner_case_sequence` | All combinations of boundary values |
| `alu_clpx_sequence` | Complex number operations (is_clpx=1) |
| `alu_subrot_sequence` | Subtract-rotate operations (is_subrot=1) |
| `alu_full_coverage_sequence` | Runs all above sequences |

## Coverage Report

After simulation, a coverage report is printed showing:

```
================================================================================
                         ALU COVERAGE REPORT
================================================================================

--- OVERALL SUMMARY ---
  Opcode Coverage:        100.00%
  Operand Range Coverage:  76.95%
  Vector Mode Coverage:   100.00%
  Shift Amount Coverage:  100.00%
  Bmask Coverage:         100.00% (6/6 opcodes)
  Division Coverage:      100.00% (4/4 opcodes)
  CLPX Coverage:          100.00%
  Op x Vec Cross Cov:     100.00%

--- OPCODE COVERAGE DETAILS ---
  Arithmetic (8/8): ADD SUB ADDU SUBU ADDR SUBR ADDUR SUBUR
  Logic (3/3): AND OR XOR
  ...
================================================================================
```

## Adding Custom Tests

1. Create a new test class in `alu_test.sv`:

```systemverilog
class my_custom_test extends alu_base_test;
  `uvm_component_utils(my_custom_test)

  function new(string name = "my_custom_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    my_custom_sequence seq;
    phase.raise_objection(this);
    seq = my_custom_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass
```

2. Create a corresponding sequence in `alu_sequences.sv`:

```systemverilog
class my_custom_sequence extends alu_base_sequence;
  `uvm_object_utils(my_custom_sequence)

  function new(string name = "my_custom_sequence");
    super.new(name);
  endfunction

  virtual task body();
    alu_seq_item txn;
    repeat (num_transactions) begin
      txn = alu_seq_item::type_id::create("txn");
      start_item(txn);
      if (!txn.randomize() with {
        // Add constraints here
      })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(txn);
    end
  endtask
endclass
```

3. Recompile and run:

```bash
vcs ... -o simv
./simv +UVM_TESTNAME=my_custom_test
```
