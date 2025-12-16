# CV32E40P ALU Test Plan

## 1. Arithmetic Operations

### 1.1 ADD (ALU_ADD)
| Test | Stimulus | Check |
|------|----------|-------|
| 1.1.1 | `operand_a_i=0x00000001`, `operand_b_i=0x00000001`, `operator_i=ALU_ADD`, `vector_mode_i=VEC_MODE32` | `result_o == 0x00000002` |
| 1.1.2 | `operand_a_i=0x7FFFFFFF`, `operand_b_i=0x00000001` | `result_o == 0x80000000` (overflow to negative) |
| 1.1.3 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000001` | `result_o == 0x00000000` (wrap around) |
| 1.1.4 | `operand_a_i=0x80000000`, `operand_b_i=0x80000000` | `result_o == 0x00000000` (negative overflow) |
| 1.1.5 | `operand_a_i=0x12345678`, `operand_b_i=0x00000000` | `result_o == 0x12345678` (add zero) |

### 1.2 SUB (ALU_SUB)
| Test | Stimulus | Check |
|------|----------|-------|
| 1.2.1 | `operand_a_i=0x00000005`, `operand_b_i=0x00000003`, `operator_i=ALU_SUB` | `result_o == 0x00000002` |
| 1.2.2 | `operand_a_i=0x00000000`, `operand_b_i=0x00000001` | `result_o == 0xFFFFFFFF` (underflow) |
| 1.2.3 | `operand_a_i=0x80000000`, `operand_b_i=0x00000001` | `result_o == 0x7FFFFFFF` (signed underflow) |
| 1.2.4 | `operand_a_i=0x12345678`, `operand_b_i=0x12345678` | `result_o == 0x00000000` (self subtract) |

### 1.3 ADDU/SUBU (Unsigned variants)
| Test | Stimulus | Check |
|------|----------|-------|
| 1.3.1 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000001`, `operator_i=ALU_ADDU` | `result_o == 0x00000000` |
| 1.3.2 | `operand_a_i=0x00000000`, `operand_b_i=0x00000001`, `operator_i=ALU_SUBU` | `result_o == 0xFFFFFFFF` |

### 1.4 ADDR/SUBR (Rounding variants)
| Test | Stimulus | Check |
|------|----------|-------|
| 1.4.1 | `operand_a_i=0x00000010`, `operand_b_i=0x00000008`, `operator_i=ALU_ADDR`, `bmask_a_i=4`, `bmask_b_i=0` | `result_o == (0x18 + round_val) >> shift` where round_val = `{1'b0, bmask[31:1]}` |
| 1.4.2 | `operand_a_i=0x00000020`, `operand_b_i=0x00000010`, `operator_i=ALU_SUBR`, `bmask_a_i=4`, `bmask_b_i=0` | Verify rounding applied before shift |

---

## 2. Logical Operations

### 2.1 AND (ALU_AND)
| Test | Stimulus | Check |
|------|----------|-------|
| 2.1.1 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x0F0F0F0F`, `operator_i=ALU_AND` | `result_o == 0x0F0F0F0F` |
| 2.1.2 | `operand_a_i=0xAAAAAAAA`, `operand_b_i=0x55555555` | `result_o == 0x00000000` |
| 2.1.3 | `operand_a_i=0x12345678`, `operand_b_i=0xFFFFFFFF` | `result_o == 0x12345678` |
| 2.1.4 | `operand_a_i=0x12345678`, `operand_b_i=0x00000000` | `result_o == 0x00000000` |

### 2.2 OR (ALU_OR)
| Test | Stimulus | Check |
|------|----------|-------|
| 2.2.1 | `operand_a_i=0xF0F0F0F0`, `operand_b_i=0x0F0F0F0F`, `operator_i=ALU_OR` | `result_o == 0xFFFFFFFF` |
| 2.2.2 | `operand_a_i=0x00000000`, `operand_b_i=0x12345678` | `result_o == 0x12345678` |
| 2.2.3 | `operand_a_i=0xAAAAAAAA`, `operand_b_i=0x55555555` | `result_o == 0xFFFFFFFF` |

### 2.3 XOR (ALU_XOR)
| Test | Stimulus | Check |
|------|----------|-------|
| 2.3.1 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0xFFFFFFFF`, `operator_i=ALU_XOR` | `result_o == 0x00000000` |
| 2.3.2 | `operand_a_i=0xAAAAAAAA`, `operand_b_i=0x55555555` | `result_o == 0xFFFFFFFF` |
| 2.3.3 | `operand_a_i=0x12345678`, `operand_b_i=0x00000000` | `result_o == 0x12345678` |

---

## 3. Shift Operations

### 3.1 SLL (Shift Left Logical - ALU_SLL)
| Test | Stimulus | Check |
|------|----------|-------|
| 3.1.1 | `operand_a_i=0x00000001`, `operand_b_i=0x00000004`, `operator_i=ALU_SLL` | `result_o == 0x00000010` |
| 3.1.2 | `operand_a_i=0x80000000`, `operand_b_i=0x00000001` | `result_o == 0x00000000` (MSB shifted out) |
| 3.1.3 | `operand_a_i=0x12345678`, `operand_b_i=0x00000000` | `result_o == 0x12345678` (shift by 0) |
| 3.1.4 | `operand_a_i=0x00000001`, `operand_b_i=0x0000001F` | `result_o == 0x80000000` (shift by 31) |

### 3.2 SRL (Shift Right Logical - ALU_SRL)
| Test | Stimulus | Check |
|------|----------|-------|
| 3.2.1 | `operand_a_i=0x00000010`, `operand_b_i=0x00000004`, `operator_i=ALU_SRL` | `result_o == 0x00000001` |
| 3.2.2 | `operand_a_i=0x80000000`, `operand_b_i=0x00000001` | `result_o == 0x40000000` (zero-fill MSB) |
| 3.2.3 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x0000001F` | `result_o == 0x00000001` |

### 3.3 SRA (Shift Right Arithmetic - ALU_SRA)
| Test | Stimulus | Check |
|------|----------|-------|
| 3.3.1 | `operand_a_i=0x80000000`, `operand_b_i=0x00000004`, `operator_i=ALU_SRA` | `result_o == 0xF8000000` (sign-extend) |
| 3.3.2 | `operand_a_i=0x7FFFFFFF`, `operand_b_i=0x00000004` | `result_o == 0x07FFFFFF` (positive, zero-fill) |
| 3.3.3 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x0000001F` | `result_o == 0xFFFFFFFF` (all 1s preserved) |

### 3.4 ROR (Rotate Right - ALU_ROR)
| Test | Stimulus | Check |
|------|----------|-------|
| 3.4.1 | `operand_a_i=0x00000001`, `operand_b_i=0x00000001`, `operator_i=ALU_ROR` | `result_o == 0x80000000` |
| 3.4.2 | `operand_a_i=0x80000001`, `operand_b_i=0x00000004` | `result_o == 0x18000000` |
| 3.4.3 | `operand_a_i=0x12345678`, `operand_b_i=0x00000000` | `result_o == 0x12345678` |

---

## 4. Comparison Operations

### 4.1 Signed Comparisons
| Test | Stimulus | Check |
|------|----------|-------|
| 4.1.1 | `operand_a_i=0x00000005`, `operand_b_i=0x00000003`, `operator_i=ALU_GTS` | `comparison_result_o == 1` |
| 4.1.2 | `operand_a_i=0xFFFFFFFF` (-1), `operand_b_i=0x00000001`, `operator_i=ALU_LTS` | `comparison_result_o == 1` (-1 < 1 signed) |
| 4.1.3 | `operand_a_i=0x80000000`, `operand_b_i=0x7FFFFFFF`, `operator_i=ALU_LTS` | `comparison_result_o == 1` (min < max signed) |
| 4.1.4 | `operand_a_i=0x00000005`, `operand_b_i=0x00000005`, `operator_i=ALU_GES` | `comparison_result_o == 1` |
| 4.1.5 | `operand_a_i=0x00000005`, `operand_b_i=0x00000005`, `operator_i=ALU_LES` | `comparison_result_o == 1` |

### 4.2 Unsigned Comparisons
| Test | Stimulus | Check |
|------|----------|-------|
| 4.2.1 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000001`, `operator_i=ALU_GTU` | `comparison_result_o == 1` (0xFFFFFFFF > 1 unsigned) |
| 4.2.2 | `operand_a_i=0x00000001`, `operand_b_i=0xFFFFFFFF`, `operator_i=ALU_LTU` | `comparison_result_o == 1` |
| 4.2.3 | `operand_a_i=0x80000000`, `operand_b_i=0x7FFFFFFF`, `operator_i=ALU_GTU` | `comparison_result_o == 1` |

### 4.3 Equality
| Test | Stimulus | Check |
|------|----------|-------|
| 4.3.1 | `operand_a_i=0x12345678`, `operand_b_i=0x12345678`, `operator_i=ALU_EQ` | `comparison_result_o == 1` |
| 4.3.2 | `operand_a_i=0x12345678`, `operand_b_i=0x12345679`, `operator_i=ALU_EQ` | `comparison_result_o == 0` |
| 4.3.3 | `operand_a_i=0x12345678`, `operand_b_i=0x12345679`, `operator_i=ALU_NE` | `comparison_result_o == 1` |

### 4.4 Set Less Than (SLTS/SLTU)
| Test | Stimulus | Check |
|------|----------|-------|
| 4.4.1 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000000`, `operator_i=ALU_SLTS` | `result_o == 0x00000001` (-1 < 0) |
| 4.4.2 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000000`, `operator_i=ALU_SLTU` | `result_o == 0x00000000` (0xFFFFFFFF > 0 unsigned) |
| 4.4.3 | `operand_a_i=0x00000005`, `operand_b_i=0x00000005`, `operator_i=ALU_SLETS` | `result_o == 0x00000001` (5 <= 5) |

---

## 5. Min/Max/Abs Operations

### 5.1 MIN (ALU_MIN - Signed)
| Test | Stimulus | Check |
|------|----------|-------|
| 5.1.1 | `operand_a_i=0x00000005`, `operand_b_i=0x00000003`, `operator_i=ALU_MIN` | `result_o == 0x00000003` |
| 5.1.2 | `operand_a_i=0xFFFFFFFF` (-1), `operand_b_i=0x00000001` | `result_o == 0xFFFFFFFF` (-1 < 1) |
| 5.1.3 | `operand_a_i=0x80000000`, `operand_b_i=0x7FFFFFFF` | `result_o == 0x80000000` |

### 5.2 MINU (ALU_MINU - Unsigned)
| Test | Stimulus | Check |
|------|----------|-------|
| 5.2.1 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000001`, `operator_i=ALU_MINU` | `result_o == 0x00000001` |
| 5.2.2 | `operand_a_i=0x80000000`, `operand_b_i=0x7FFFFFFF` | `result_o == 0x7FFFFFFF` |

### 5.3 MAX (ALU_MAX - Signed)
| Test | Stimulus | Check |
|------|----------|-------|
| 5.3.1 | `operand_a_i=0x00000005`, `operand_b_i=0x00000003`, `operator_i=ALU_MAX` | `result_o == 0x00000005` |
| 5.3.2 | `operand_a_i=0xFFFFFFFF` (-1), `operand_b_i=0x00000001` | `result_o == 0x00000001` |

### 5.4 MAXU (ALU_MAXU - Unsigned)
| Test | Stimulus | Check |
|------|----------|-------|
| 5.4.1 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000001`, `operator_i=ALU_MAXU` | `result_o == 0xFFFFFFFF` |

### 5.5 ABS (ALU_ABS)
| Test | Stimulus | Check |
|------|----------|-------|
| 5.5.1 | `operand_a_i=0xFFFFFFFF` (-1), `operator_i=ALU_ABS`, `is_clpx_i=0` | `result_o == 0x00000001` |
| 5.5.2 | `operand_a_i=0x80000000` (-2^31), `is_clpx_i=0` | `result_o == 0x80000000` (overflow case) |
| 5.5.3 | `operand_a_i=0x00000005`, `is_clpx_i=0` | `result_o == 0x00000005` (positive unchanged) |

---

## 6. Clip Operations

### 6.1 CLIP (ALU_CLIP - Signed)
| Test | Stimulus | Check |
|------|----------|-------|
| 6.1.1 | `operand_a_i=0x00000010` (16), `operand_b_i=0x0000000F` (15), `operator_i=ALU_CLIP` | `result_o == 0x0000000F` (clipped to max) |
| 6.1.2 | `operand_a_i=0xFFFFFFF0` (-16), `operand_b_i=0x0000000F` | `result_o == 0xFFFFFFF1` (-15, clipped to -max) |
| 6.1.3 | `operand_a_i=0x00000005`, `operand_b_i=0x0000000F` | `result_o == 0x00000005` (within range) |

### 6.2 CLIPU (ALU_CLIPU - Unsigned)
| Test | Stimulus | Check |
|------|----------|-------|
| 6.2.1 | `operand_a_i=0x00000020`, `operand_b_i=0x0000000F`, `operator_i=ALU_CLIPU` | `result_o == 0x0000000F` (clipped to max) |
| 6.2.2 | `operand_a_i=0xFFFFFFFF` (negative), `operand_b_i=0x0000000F` | `result_o == 0x00000000` (clipped to 0) |
| 6.2.3 | `operand_a_i=0x00000005`, `operand_b_i=0x0000000F` | `result_o == 0x00000005` (within range) |

---

## 7. Bit Manipulation Operations

### 7.1 BEXT (Bit Extract Signed - ALU_BEXT)
| Test | Stimulus | Check |
|------|----------|-------|
| 7.1.1 | `operand_a_i=0x12345678`, `bmask_a_i=7`, `bmask_b_i=4`, `operator_i=ALU_BEXT` | Extract bits [11:4], sign-extend. `result_o == sign_ext(0x67)` |
| 7.1.2 | `operand_a_i=0xFFFF8765`, `bmask_a_i=7`, `bmask_b_i=0` | Extract bits [7:0] = 0x65, sign-extend (bit 7=0). `result_o == 0x00000065` |
| 7.1.3 | `operand_a_i=0xFFFF8765`, `bmask_a_i=7`, `bmask_b_i=8` | Extract bits [15:8] = 0x87, sign-extend (bit 7=1). `result_o == 0xFFFFFF87` |

### 7.2 BEXTU (Bit Extract Unsigned - ALU_BEXTU)
| Test | Stimulus | Check |
|------|----------|-------|
| 7.2.1 | `operand_a_i=0x12345678`, `bmask_a_i=7`, `bmask_b_i=4`, `operator_i=ALU_BEXTU` | Extract bits [11:4], zero-extend. `result_o == 0x00000067` |
| 7.2.2 | `operand_a_i=0xFFFF8765`, `bmask_a_i=7`, `bmask_b_i=8` | Extract bits [15:8] = 0x87, zero-extend. `result_o == 0x00000087` |

### 7.3 BINS (Bit Insert - ALU_BINS)
| Test | Stimulus | Check |
|------|----------|-------|
| 7.3.1 | `operand_a_i=0x0000000F`, `operand_c_i=0x12345678`, `bmask_a_i=7`, `bmask_b_i=8`, `operator_i=ALU_BINS` | Insert 0x0F into bits [15:8] of operand_c. `result_o == 0x12340F78` |
| 7.3.2 | `operand_a_i=0x000000FF`, `operand_c_i=0x00000000`, `bmask_a_i=7`, `bmask_b_i=0` | `result_o == 0x000000FF` |

### 7.4 BCLR (Bit Clear - ALU_BCLR)
| Test | Stimulus | Check |
|------|----------|-------|
| 7.4.1 | `operand_a_i=0xFFFFFFFF`, `bmask_a_i=7`, `bmask_b_i=4`, `operator_i=ALU_BCLR` | Clear bits [11:4]. `result_o == 0xFFFFF00F` |
| 7.4.2 | `operand_a_i=0x12345678`, `bmask_a_i=3`, `bmask_b_i=0` | Clear bits [3:0]. `result_o == 0x12345670` |

### 7.5 BSET (Bit Set - ALU_BSET)
| Test | Stimulus | Check |
|------|----------|-------|
| 7.5.1 | `operand_a_i=0x00000000`, `bmask_a_i=7`, `bmask_b_i=4`, `operator_i=ALU_BSET` | Set bits [11:4]. `result_o == 0x00000FF0` |
| 7.5.2 | `operand_a_i=0x12345678`, `bmask_a_i=3`, `bmask_b_i=28` | Set bits [31:28]. `result_o == 0xF2345678` |

### 7.6 BREV (Bit Reverse - ALU_BREV)
| Test | Stimulus | Check |
|------|----------|-------|
| 7.6.1 | `operand_a_i=0x80000000`, `bmask_a_i[1:0]=2'b00` (radix-2), `operator_i=ALU_BREV` | `result_o == 0x00000001` |
| 7.6.2 | `operand_a_i=0x12345678`, `bmask_a_i[1:0]=2'b00` | `result_o == bit_reverse(0x12345678)` = 0x1E6A2C48 |
| 7.6.3 | `operand_a_i=0x12345678`, `bmask_a_i[1:0]=2'b01` (radix-4) | Verify radix-4 reversal |

---

## 8. Bit Counting Operations

### 8.1 FF1 (Find First 1 - ALU_FF1)
| Test | Stimulus | Check |
|------|----------|-------|
| 8.1.1 | `operand_a_i=0x00000001`, `operator_i=ALU_FF1` | `result_o == 0` (bit 0) |
| 8.1.2 | `operand_a_i=0x80000000` | `result_o == 31` |
| 8.1.3 | `operand_a_i=0x00000000` | `result_o == 32` (no ones) |
| 8.1.4 | `operand_a_i=0x00000100` | `result_o == 8` |

### 8.2 FL1 (Find Last 1 - ALU_FL1)
| Test | Stimulus | Check |
|------|----------|-------|
| 8.2.1 | `operand_a_i=0x00000001`, `operator_i=ALU_FL1` | `result_o == 0` |
| 8.2.2 | `operand_a_i=0x80000000` | `result_o == 31` |
| 8.2.3 | `operand_a_i=0x00000000` | `result_o == 32` (no ones) |
| 8.2.4 | `operand_a_i=0x0000FF00` | `result_o == 15` |

### 8.3 CNT (Population Count - ALU_CNT)
| Test | Stimulus | Check |
|------|----------|-------|
| 8.3.1 | `operand_a_i=0x00000000`, `operator_i=ALU_CNT` | `result_o == 0` |
| 8.3.2 | `operand_a_i=0xFFFFFFFF` | `result_o == 32` |
| 8.3.3 | `operand_a_i=0x55555555` | `result_o == 16` |
| 8.3.4 | `operand_a_i=0x00000001` | `result_o == 1` |

### 8.4 CLB (Count Leading Bits - ALU_CLB)
| Test | Stimulus | Check |
|------|----------|-------|
| 8.4.1 | `operand_a_i=0x00000001`, `operator_i=ALU_CLB` | `result_o == 30` (30 leading zeros before the 1) |
| 8.4.2 | `operand_a_i=0xFFFFFFFE` | `result_o == 30` (30 leading ones before the 0) |
| 8.4.3 | `operand_a_i=0x00000000` | `result_o == 0` |
| 8.4.4 | `operand_a_i=0xFFFFFFFF` | `result_o == 31` |

---

## 9. Division Operations

### 9.1 DIV (Signed Division - ALU_DIV)
| Test | Stimulus | Check |
|------|----------|-------|
| 9.1.1 | `operand_a_i=0x00000014` (20), `operand_b_i=0x00000004`, `operator_i=ALU_DIV`, `enable_i=1` | Wait for `ready_o==1`, `result_o == 0x00000005` |
| 9.1.2 | `operand_a_i=0xFFFFFFEC` (-20), `operand_b_i=0x00000004` | `result_o == 0xFFFFFFFB` (-5) |
| 9.1.3 | `operand_a_i=0x00000014`, `operand_b_i=0xFFFFFFFC` (-4) | `result_o == 0xFFFFFFFB` (-5) |
| 9.1.4 | `operand_a_i=0x00000014`, `operand_b_i=0x00000000` | `result_o == 0xFFFFFFFF` (div by zero) |
| 9.1.5 | `operand_a_i=0x80000000`, `operand_b_i=0xFFFFFFFF` | `result_o == 0x80000000` (overflow case) |

### 9.2 DIVU (Unsigned Division - ALU_DIVU)
| Test | Stimulus | Check |
|------|----------|-------|
| 9.2.1 | `operand_a_i=0x00000014`, `operand_b_i=0x00000004`, `operator_i=ALU_DIVU` | `result_o == 0x00000005` |
| 9.2.2 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000002` | `result_o == 0x7FFFFFFF` |
| 9.2.3 | `operand_a_i=0x00000014`, `operand_b_i=0x00000000` | `result_o == 0xFFFFFFFF` (div by zero) |

### 9.3 REM (Signed Remainder - ALU_REM)
| Test | Stimulus | Check |
|------|----------|-------|
| 9.3.1 | `operand_a_i=0x00000015` (21), `operand_b_i=0x00000004`, `operator_i=ALU_REM` | `result_o == 0x00000001` |
| 9.3.2 | `operand_a_i=0xFFFFFFEB` (-21), `operand_b_i=0x00000004` | `result_o == 0xFFFFFFFF` (-1) |
| 9.3.3 | `operand_a_i=0x00000015`, `operand_b_i=0x00000000` | `result_o == 0x00000015` (rem by zero = dividend) |

### 9.4 REMU (Unsigned Remainder - ALU_REMU)
| Test | Stimulus | Check |
|------|----------|-------|
| 9.4.1 | `operand_a_i=0x00000015`, `operand_b_i=0x00000004`, `operator_i=ALU_REMU` | `result_o == 0x00000001` |
| 9.4.2 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000003` | `result_o == 0x00000000` |

---

## 10. Shuffle/Pack Operations

### 10.1 SHUF (Shuffle - ALU_SHUF)
| Test | Stimulus | Check |
|------|----------|-------|
| 10.1.1 | `operand_a_i=0x44332211`, `operand_b_i` with byte selectors `[25:24]=3, [17:16]=2, [9:8]=1, [1:0]=0`, `vector_mode_i=VEC_MODE8`, `operator_i=ALU_SHUF` | `result_o == 0x44332211` (identity) |
| 10.1.2 | `operand_a_i=0x44332211`, byte selectors `[25:24]=0, [17:16]=1, [9:8]=2, [1:0]=3` | `result_o == 0x11223344` (reverse bytes) |

### 10.2 SHUF2 (Shuffle2 - ALU_SHUF2)
| Test | Stimulus | Check |
|------|----------|-------|
| 10.2.1 | `operand_a_i=0xAABBCCDD`, `operand_b_i=0x11223344` with appropriate selectors, `operator_i=ALU_SHUF2` | Verify bytes selected from either operand_a or operand_b based on selector bits |

### 10.3 PCKLO (Pack Low - ALU_PCKLO)
| Test | Stimulus | Check |
|------|----------|-------|
| 10.3.1 | `operand_a_i=0xAABBCCDD`, `operand_b_i=0x11223344`, `vector_mode_i=VEC_MODE16`, `operator_i=ALU_PCKLO` | `result_o == {operand_b[15:0], operand_a[15:0]}` = 0x3344CCDD |
| 10.3.2 | Same with `vector_mode_i=VEC_MODE8` | Pack low bytes |

### 10.4 PCKHI (Pack High - ALU_PCKHI)
| Test | Stimulus | Check |
|------|----------|-------|
| 10.4.1 | `operand_a_i=0xAABBCCDD`, `operand_b_i=0x11223344`, `vector_mode_i=VEC_MODE16`, `operator_i=ALU_PCKHI` | `result_o == {operand_b[31:16], operand_a[31:16]}` = 0x1122AABB |

---

## 11. Extension Operations

### 11.1 EXT (Zero Extension - ALU_EXT)
| Test | Stimulus | Check |
|------|----------|-------|
| 11.1.1 | `operand_a_i=0x123456FF`, `vector_mode_i=VEC_MODE8`, `imm_vec_ext_i=0`, `operator_i=ALU_EXT` | `result_o == 0x000000FF` (zero-extend byte 0) |
| 11.1.2 | `operand_a_i=0x12345678`, `vector_mode_i=VEC_MODE16`, `imm_vec_ext_i=0` | `result_o == 0x00005678` (zero-extend halfword 0) |

### 11.2 EXTS (Sign Extension - ALU_EXTS)
| Test | Stimulus | Check |
|------|----------|-------|
| 11.2.1 | `operand_a_i=0x123456FF`, `vector_mode_i=VEC_MODE8`, `imm_vec_ext_i=0`, `operator_i=ALU_EXTS` | `result_o == 0xFFFFFFFF` (sign-extend 0xFF) |
| 11.2.2 | `operand_a_i=0x12345678`, `vector_mode_i=VEC_MODE8`, `imm_vec_ext_i=0` | `result_o == 0x00000078` (sign-extend 0x78, positive) |
| 11.2.3 | `operand_a_i=0x12348765`, `vector_mode_i=VEC_MODE16`, `imm_vec_ext_i=0` | `result_o == 0xFFFF8765` (sign-extend 0x8765) |

### 11.3 INS (Insert - ALU_INS)
| Test | Stimulus | Check |
|------|----------|-------|
| 11.3.1 | `operand_a_i=0x000000FF`, `operand_c_i=0x12345678`, `vector_mode_i=VEC_MODE8`, `imm_vec_ext_i=2`, `operator_i=ALU_INS` | Insert byte into position 2. `result_o == 0x12FF5678` |

---

## 12. Vector Mode Operations

### 12.1 VEC_MODE16 (16-bit SIMD)
| Test | Stimulus | Check |
|------|----------|-------|
| 12.1.1 | `operand_a_i=0x00010002`, `operand_b_i=0x00030004`, `operator_i=ALU_ADD`, `vector_mode_i=VEC_MODE16` | `result_o == 0x00040006` (two 16-bit adds) |
| 12.1.2 | `operand_a_i=0xFFFF0001`, `operand_b_i=0x00010001`, `operator_i=ALU_ADD`, `vector_mode_i=VEC_MODE16` | `result_o == 0x00000002` (with wrap) |
| 12.1.3 | `operand_a_i=0x00050003`, `operand_b_i=0x00030005`, `operator_i=ALU_GTS`, `vector_mode_i=VEC_MODE16` | `result_o[31:16] == 0xFFFF` (5>3), `result_o[15:0] == 0x0000` (3<5) |

### 12.2 VEC_MODE8 (8-bit SIMD)
| Test | Stimulus | Check |
|------|----------|-------|
| 12.2.1 | `operand_a_i=0x01020304`, `operand_b_i=0x01010101`, `operator_i=ALU_ADD`, `vector_mode_i=VEC_MODE8` | `result_o == 0x02030405` (four 8-bit adds) |
| 12.2.2 | `operand_a_i=0xFF010201`, `operand_b_i=0x01010101`, `operator_i=ALU_ADD`, `vector_mode_i=VEC_MODE8` | `result_o == 0x00020302` (with wrap on byte 3) |
| 12.2.3 | `operand_a_i=0x05030201`, `operand_b_i=0x01050302`, `operator_i=ALU_GTS`, `vector_mode_i=VEC_MODE8` | Per-byte comparison results |

---

## 13. Complex Number Operations (CLPX)

### 13.1 Complex Conjugate via ABS
| Test | Stimulus | Check |
|------|----------|-------|
| 13.1.1 | `operand_a_i=0x00050003`, `operator_i=ALU_ABS`, `is_clpx_i=1` | `result_o == {adder_result[31:16], operand_a_i[15:0]}` (negate imaginary part) |

### 13.2 Subrot (Complex rotation)
| Test | Stimulus | Check |
|------|----------|-------|
| 13.2.1 | `operand_a_i=0xAAAABBBB`, `operand_b_i=0xCCCCDDDD`, `operator_i=ALU_SUB`, `is_subrot_i=1` | Verify cross-subtraction: `{b[15:0], a[31:16]} - {a[15:0], b[31:16]}` |

---

## 14. Control Signal Tests

### 14.1 Enable Signal
| Test | Stimulus | Check |
|------|----------|-------|
| 14.1.1 | `enable_i=0`, `operator_i=ALU_DIV` | `div_valid` should be 0, division should not start |
| 14.1.2 | `enable_i=1`, `operator_i=ALU_DIV` | Division starts, wait for `ready_o` |

### 14.2 Ready/Valid Handshake
| Test | Stimulus | Check |
|------|----------|-------|
| 14.2.1 | Start division, toggle `ex_ready_i` | Verify `ready_o` behavior with backpressure |
| 14.2.2 | Non-division operation | `ready_o` should follow `div_ready` (from div unit) |

### 14.3 Reset
| Test | Stimulus | Check |
|------|----------|-------|
| 14.3.1 | Assert `rst_n=0` during division | Division state machine resets |
| 14.3.2 | Deassert reset, start new operation | Clean operation after reset |

---

## 15. Corner Cases and Random Testing

### 15.1 Boundary Values
| Test | Stimulus | Check |
|------|----------|-------|
| 15.1.1 | All operations with `operand_a_i=0x00000000` | Verify zero handling |
| 15.1.2 | All operations with `operand_a_i=0xFFFFFFFF` | Verify all-ones handling |
| 15.1.3 | All operations with `operand_a_i=0x80000000` | Verify min signed handling |
| 15.1.4 | All operations with `operand_a_i=0x7FFFFFFF` | Verify max signed handling |

### 15.2 Random Stimulus
| Test | Stimulus | Check |
|------|----------|-------|
| 15.2.1 | Random `operand_a_i`, `operand_b_i` for each operation | Compare against reference model |
| 15.2.2 | Random back-to-back operations | Verify no state corruption |
| 15.2.3 | Random vector modes with random operands | Verify SIMD correctness |

---

## 16. Directed Corner Case Tests

### 16.1 Operand Boundary Values (Per Operation)

For **each ALU operation**, apply the following directed test matrix:

| Corner Case | operand_a_i | operand_b_i | Description |
|-------------|-------------|-------------|-------------|
| CC-1 | `0x00000000` | `0x00000000` | Both zero |
| CC-2 | `0x00000000` | `0xFFFFFFFF` | Zero vs all-ones |
| CC-3 | `0xFFFFFFFF` | `0x00000000` | All-ones vs zero |
| CC-4 | `0xFFFFFFFF` | `0xFFFFFFFF` | Both all-ones |
| CC-5 | `0x80000000` | `0x00000000` | Min signed vs zero |
| CC-6 | `0x7FFFFFFF` | `0x00000000` | Max signed vs zero |
| CC-7 | `0x80000000` | `0x7FFFFFFF` | Min vs max signed |
| CC-8 | `0x7FFFFFFF` | `0x80000000` | Max vs min signed |
| CC-9 | `0x80000000` | `0x80000000` | Both min signed |
| CC-10 | `0x7FFFFFFF` | `0x7FFFFFFF` | Both max signed |
| CC-11 | `0x00000001` | `0x00000001` | Both one |
| CC-12 | `0x00000001` | `0xFFFFFFFF` | One vs all-ones |
| CC-13 | `0x80000000` | `0x00000001` | Min signed ± 1 |
| CC-14 | `0x7FFFFFFF` | `0x00000001` | Max signed ± 1 |

### 16.2 Sign Transition Tests

| Test ID | Stimulus | Expected Behavior |
|---------|----------|-------------------|
| ST-1 | `operand_a_i=0x7FFFFFFF`, `operand_b_i=0x00000001`, `operator_i=ALU_ADD` | Result crosses to negative (0x80000000) |
| ST-2 | `operand_a_i=0x80000000`, `operand_b_i=0xFFFFFFFF`, `operator_i=ALU_ADD` | Result crosses to positive (0x7FFFFFFF) |
| ST-3 | `operand_a_i=0x00000000`, `operand_b_i=0x00000001`, `operator_i=ALU_SUB` | Result wraps to 0xFFFFFFFF |
| ST-4 | `operand_a_i=0x80000000`, `operand_b_i=0x00000001`, `operator_i=ALU_SUB` | Signed overflow to 0x7FFFFFFF |
| ST-5 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00000001`, `operator_i=ALU_SRA` | Sign preserved after shift |
| ST-6 | `operand_a_i=0x80000000`, `operand_b_i=0x0000001F`, `operator_i=ALU_SRA` | All bits become sign bit (0xFFFFFFFF) |

### 16.3 Shift Amount Boundaries

| Test ID | Stimulus | Check |
|---------|----------|-------|
| SH-1 | `operand_b_i[4:0]=0`, any shift op | Result unchanged from operand_a_i |
| SH-2 | `operand_b_i[4:0]=1`, any shift op | Single bit shift |
| SH-3 | `operand_b_i[4:0]=31`, any shift op | Maximum valid shift |
| SH-4 | `operand_b_i=0x00000020` (32), any shift op | Verify only [4:0] used (effective shift=0) |
| SH-5 | `operand_b_i=0xFFFFFFFF`, any shift op | Verify only [4:0] used (effective shift=31) |

### 16.4 Division Corner Cases

| Test ID | Stimulus | Expected Result |
|---------|----------|-----------------|
| DIV-1 | `operand_a_i=0`, `operand_b_i=N` (any non-zero), `operator_i=ALU_DIV` | `result_o == 0` |
| DIV-2 | `operand_a_i=N`, `operand_b_i=0`, `operator_i=ALU_DIV` | `result_o == 0xFFFFFFFF` (RISC-V div-by-zero) |
| DIV-3 | `operand_a_i=0x80000000`, `operand_b_i=0xFFFFFFFF`, `operator_i=ALU_DIV` | `result_o == 0x80000000` (signed overflow) |
| DIV-4 | `operand_a_i=N`, `operand_b_i=1`, `operator_i=ALU_DIV` | `result_o == N` |
| DIV-5 | `operand_a_i=N`, `operand_b_i=0xFFFFFFFF` (-1), `operator_i=ALU_DIV` | `result_o == -N` (check overflow for 0x80000000) |
| DIV-6 | `operand_a_i=N`, `operand_b_i=N`, `operator_i=ALU_DIV` | `result_o == 1` |
| DIV-7 | `operand_a_i < operand_b_i` (unsigned), `operator_i=ALU_DIVU` | `result_o == 0` |

### 16.5 Bit Manipulation Boundaries

| Test ID | Operation | bmask_a_i | bmask_b_i | Description |
|---------|-----------|-----------|-----------|-------------|
| BM-1 | ALU_BEXT | 0 | 0 | Single bit extraction at LSB |
| BM-2 | ALU_BEXT | 31 | 0 | Full width extraction from bit 0 |
| BM-3 | ALU_BEXT | 0 | 31 | Single bit extraction at MSB |
| BM-4 | ALU_BINS | 7 | 8 | Insert byte into middle position |
| BM-5 | ALU_BCLR | 31 | 0 | Clear all bits |
| BM-6 | ALU_BSET | 31 | 0 | Set all bits |
| BM-7 | ALU_BREV | radix=0 | N/A | Radix-2 bit reversal |
| BM-8 | ALU_BREV | radix=1 | N/A | Radix-4 bit reversal |
| BM-9 | ALU_BREV | radix=2 | N/A | Radix-8 bit reversal |

### 16.6 Vector Mode Corner Cases

| Test ID | vector_mode_i | Stimulus | Check |
|---------|---------------|----------|-------|
| VM-1 | VEC_MODE8 | `operand_a_i=0x7F7F7F7F`, `operand_b_i=0x01010101`, op=ALU_ADD | Each byte overflows independently: `result_o == 0x80808080` |
| VM-2 | VEC_MODE8 | `operand_a_i=0x80808080`, `operand_b_i=0x80808080`, op=ALU_ADD | Each byte wraps: `result_o == 0x00000000` |
| VM-3 | VEC_MODE8 | `operand_a_i=0xFF007F80`, `operand_b_i=0x01010101`, op=ALU_ADD | Mixed boundaries per lane |
| VM-4 | VEC_MODE16 | `operand_a_i=0x7FFF7FFF`, `operand_b_i=0x00010001`, op=ALU_ADD | Both halfwords overflow: `result_o == 0x80008000` |
| VM-5 | VEC_MODE16 | `operand_a_i=0x80008000`, `operand_b_i=0xFFFFFFFF`, op=ALU_ADD | Both halfwords wrap to 0x7FFF7FFF |
| VM-6 | VEC_MODE8 | `operand_a_i=0x05030201`, `operand_b_i=0x01050302`, op=ALU_GTS | Per-byte signed comparison |
| VM-7 | VEC_MODE16 | `operand_a_i=0x00058003`, `operand_b_i=0x00037FFF`, op=ALU_GTS | Per-halfword signed comparison |

### 16.7 Complex Number (CLPX) Corner Cases

| Test ID | Stimulus | Check |
|---------|----------|-------|
| CLPX-1 | `operand_a_i=0x7FFF8000`, `is_clpx_i=1`, op=ALU_ABS | Conjugate with max/min halfwords |
| CLPX-2 | `operand_a_i=0x00000000`, `is_clpx_i=1`, op=ALU_ABS | Zero complex number |
| CLPX-3 | `operand_a_i=0xFFFFFFFF`, `operand_b_i=0x00010001`, `is_subrot_i=1`, op=ALU_SUB | Subrot with all-ones |

---

## 17. Constrained Randomization Strategy

### 17.1 Coverage Model

#### 17.1.1 Opcode Coverage
```systemverilog
covergroup cg_opcode;
  cp_operator: coverpoint operator_i {
    bins arith[] = {ALU_ADD, ALU_SUB, ALU_ADDU, ALU_SUBU, ALU_ADDR, ALU_SUBR, ALU_ADDUR, ALU_SUBUR};
    bins logic[] = {ALU_AND, ALU_OR, ALU_XOR};
    bins shift[] = {ALU_SLL, ALU_SRL, ALU_SRA, ALU_ROR};
    bins cmp[]   = {ALU_EQ, ALU_NE, ALU_GTS, ALU_GES, ALU_LTS, ALU_LES, ALU_GTU, ALU_GEU, ALU_LTU, ALU_LEU};
    bins slt[]   = {ALU_SLTS, ALU_SLTU, ALU_SLETS, ALU_SLETU};
    bins minmax[]= {ALU_MIN, ALU_MINU, ALU_MAX, ALU_MAXU, ALU_ABS, ALU_CLIP, ALU_CLIPU};
    bins bitman[]= {ALU_BEXT, ALU_BEXTU, ALU_BINS, ALU_BCLR, ALU_BSET, ALU_BREV};
    bins bitcnt[]= {ALU_FF1, ALU_FL1, ALU_CNT, ALU_CLB};
    bins div[]   = {ALU_DIV, ALU_DIVU, ALU_REM, ALU_REMU};
    bins shuf[]  = {ALU_SHUF, ALU_SHUF2, ALU_PCKLO, ALU_PCKHI, ALU_EXT, ALU_EXTS, ALU_INS};
  }
endgroup
```

#### 17.1.2 Operand Range Coverage
```systemverilog
covergroup cg_operand_ranges;
  cp_operand_a: coverpoint operand_a_i {
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
  cp_operand_b: coverpoint operand_b_i {
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
```

#### 17.1.3 Vector Mode Coverage
```systemverilog
covergroup cg_vector_mode;
  cp_vec_mode: coverpoint vector_mode_i {
    bins mode32 = {2'b00};  // VEC_MODE32
    bins mode16 = {2'b10};  // VEC_MODE16
    bins mode8  = {2'b11};  // VEC_MODE8
  }
endgroup
```

#### 17.1.4 Cross Coverage
```systemverilog
covergroup cg_cross_coverage;
  cp_operator: coverpoint operator_i;
  cp_vec_mode: coverpoint vector_mode_i;
  cp_operand_a_range: coverpoint operand_a_i {
    bins boundary = {32'h0, 32'hFFFFFFFF, 32'h7FFFFFFF, 32'h80000000};
    bins other    = default;
  }
  cx_op_vec: cross cp_operator, cp_vec_mode {
    ignore_bins non_vec = binsof(cp_operator) intersect {ALU_DIV, ALU_DIVU, ALU_REM, ALU_REMU};
  }
  cx_op_boundary: cross cp_operator, cp_operand_a_range;
endgroup
```

### 17.2 Constraint Classes

#### 17.2.1 Base Transaction Class with Weighted Boundary Distribution
```systemverilog
class alu_transaction;
  rand alu_opcode_e        operator;
  rand logic [31:0]        operand_a;
  rand logic [31:0]        operand_b;
  rand logic [31:0]        operand_c;
  rand logic [1:0]         vector_mode;
  rand logic [4:0]         bmask_a;
  rand logic [4:0]         bmask_b;
  rand logic [1:0]         imm_vec_ext;
  rand logic               is_clpx;
  rand logic               is_subrot;
  rand logic [1:0]         clpx_shift;

  // 30% boundary values, 70% random
  constraint c_operand_a_dist {
    operand_a dist {
      32'h00000000 := 5,   // zero
      32'h00000001 := 5,   // one
      32'hFFFFFFFF := 5,   // all ones
      32'h7FFFFFFF := 5,   // max signed
      32'h80000000 := 5,   // min signed
      32'h7FFFFFFE := 2,   // max signed - 1
      32'h80000001 := 2,   // min signed + 1
      [32'h00000002:32'h7FFFFFFD] :/ 35,  // positive range
      [32'h80000002:32'hFFFFFFFE] :/ 36   // negative range
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
endclass
```

#### 17.2.2 Sign Transition Focused Constraints
```systemverilog
class alu_sign_transition_txn extends alu_transaction;
  constraint c_sign_transition {
    // Force sign boundary scenarios
    (operand_a inside {32'h7FFFFFFF, 32'h80000000, 32'h7FFFFFFE, 32'h80000001}) ||
    (operand_b inside {32'h7FFFFFFF, 32'h80000000, 32'h7FFFFFFE, 32'h80000001});
  }

  constraint c_arith_ops {
    operator inside {ALU_ADD, ALU_SUB, ALU_ADDU, ALU_SUBU};
  }
endclass
```

#### 17.2.3 Shift Amount Constraints
```systemverilog
class alu_shift_txn extends alu_transaction;
  constraint c_shift_ops {
    operator inside {ALU_SLL, ALU_SRL, ALU_SRA, ALU_ROR};
  }

  constraint c_shift_amt {
    operand_b[4:0] dist {
      5'd0  := 10,  // no shift
      5'd1  := 10,  // single bit
      5'd31 := 10,  // max shift
      [5'd2:5'd30] :/ 70
    };
  }
endclass
```

#### 17.2.4 Division Constraints
```systemverilog
class alu_div_txn extends alu_transaction;
  constraint c_div_ops {
    operator inside {ALU_DIV, ALU_DIVU, ALU_REM, ALU_REMU};
  }

  constraint c_divisor {
    operand_b dist {
      32'h00000000 := 5,           // div by zero
      32'h00000001 := 10,          // div by 1
      32'hFFFFFFFF := 5,           // div by -1
      [32'h00000002:32'hFFFFFFFE] :/ 80
    };
  }

  constraint c_dividend_corners {
    operand_a dist {
      32'h00000000 := 5,           // zero dividend
      32'h80000000 := 5,           // min signed (overflow case)
      [32'h00000001:32'h7FFFFFFF] :/ 45,
      [32'h80000001:32'hFFFFFFFF] :/ 45
    };
  }
endclass
```

#### 17.2.5 Bit Manipulation Constraints
```systemverilog
class alu_bitmanip_txn extends alu_transaction;
  constraint c_bitmanip_ops {
    operator inside {ALU_BEXT, ALU_BEXTU, ALU_BINS, ALU_BCLR, ALU_BSET, ALU_BREV};
  }

  constraint c_bmask_a {
    bmask_a dist {
      5'd0  := 10,   // single bit
      5'd7  := 15,   // byte width
      5'd15 := 15,   // halfword width
      5'd31 := 10,   // full width
      [5'd1:5'd6]   :/ 15,
      [5'd8:5'd14]  :/ 15,
      [5'd16:5'd30] :/ 20
    };
  }

  constraint c_bmask_b {
    bmask_b dist {
      5'd0  := 20,   // LSB aligned
      5'd8  := 10,   // byte 1
      5'd16 := 10,   // byte 2
      5'd24 := 10,   // byte 3
      [5'd1:5'd7]   :/ 15,
      [5'd9:5'd15]  :/ 15,
      [5'd17:5'd23] :/ 10,
      [5'd25:5'd31] :/ 10
    };
  }

  constraint c_valid_range {
    bmask_a + bmask_b <= 31;
  }
endclass
```

#### 17.2.6 Vector Mode Constraints
```systemverilog
class alu_vector_txn extends alu_transaction;
  constraint c_vector_mode {
    vector_mode dist {
      2'b00 := 40,  // VEC_MODE32
      2'b10 := 30,  // VEC_MODE16
      2'b11 := 30   // VEC_MODE8
    };
  }

  constraint c_vector_ops {
    operator inside {ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR,
                     ALU_GTS, ALU_GES, ALU_LTS, ALU_LES, ALU_GTU, ALU_GEU, ALU_LTU, ALU_LEU,
                     ALU_MIN, ALU_MINU, ALU_MAX, ALU_MAXU,
                     ALU_SLL, ALU_SRL, ALU_SRA};
  }

  // Per-lane boundary values for VEC_MODE8
  constraint c_vec8_boundaries {
    if (vector_mode == 2'b11) {
      operand_a[7:0]   dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
      operand_a[15:8]  dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
      operand_a[23:16] dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
      operand_a[31:24] dist {8'h00 := 10, 8'h7F := 10, 8'h80 := 10, 8'hFF := 10, [8'h01:8'h7E] :/ 30, [8'h81:8'hFE] :/ 30};
    }
  }
endclass
```

### 17.3 Test Execution Strategy

| Phase | Transaction Class | Iterations | Description |
|-------|-------------------|------------|-------------|
| Phase 1 | `alu_transaction` | 100 per opcode | Uniform random with boundary bias |
| Phase 2 | `alu_sign_transition_txn` | 100 | Sign transition focused |
| Phase 3 | `alu_shift_txn` | 100 | Shift operation edge cases |
| Phase 4 | `alu_div_txn` | 100 | Division corner cases |
| Phase 5 | `alu_bitmanip_txn` | 100 | Bit manipulation edge cases |
| Phase 6 | `alu_vector_txn` | 100 per vector mode | Vector mode cross-coverage |

**Total Estimated Transactions:** ~5500 random transactions

### 17.4 Functional Coverage Goals

| Coverage Point | Target | Description |
|----------------|--------|-------------|
| All opcodes exercised | 100% | Every ALU operation must be tested |
| Operand boundary bins | 100% | All 9 bins for operand_a and operand_b hit |
| Operand cross-coverage | >90% | 81 cross bins (9×9), target 73+ bins |
| Vector mode × opcode | 100% | All valid combinations for vector-capable ops |
| Sign transition scenarios | >95% | Overflow/underflow cases covered |
| Shift amount boundaries | 100% | 0, 1, 31 shift amounts for all shift ops |
| Division edge cases | 100% | Div-by-zero, overflow, identity cases |
| Bit manipulation ranges | >90% | bmask_a × bmask_b cross coverage |

### 17.5 Checker Strategy

For each random transaction:

1. **Stimulus Application:**
   - Drive all inputs (`operator_i`, `operand_a_i`, `operand_b_i`, `operand_c_i`, `vector_mode_i`, etc.)
   - For division operations, assert `enable_i` and wait for `ready_o`

2. **Reference Model Computation:**
   ```systemverilog
   function automatic logic [31:0] alu_reference_model(
     alu_opcode_e op,
     logic [31:0] a, b, c,
     logic [1:0]  vec_mode,
     logic [4:0]  bmask_a, bmask_b
   );
     case (op)
       ALU_ADD:  return a + b;
       ALU_SUB:  return a - b;
       ALU_AND:  return a & b;
       ALU_OR:   return a | b;
       ALU_XOR:  return a ^ b;
       ALU_SLL:  return a << b[4:0];
       ALU_SRL:  return a >> b[4:0];
       ALU_SRA:  return $signed(a) >>> b[4:0];
       // ... additional operations
       default:  return 32'h0;
     endcase
   endfunction
   ```

3. **Result Comparison:**
   - Compare `result_o` with reference model output
   - Compare `comparison_result_o` for comparison operations
   - Log mismatches with full transaction context

4. **Coverage Sampling:**
   - Sample covergroups after each transaction
   - Track coverage closure progress

### 17.6 Test Termination Criteria

| Criterion | Threshold |
|-----------|-----------|
| Minimum transactions | 5000 |
| Opcode coverage | 100% |
| Operand range coverage | 100% |
| Cross coverage | >90% |
| Zero failures | Required |

Test terminates when all coverage goals are met OR maximum iteration count (10000) is reached.
