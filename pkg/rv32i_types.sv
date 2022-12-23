package rv32i_types;
// Mux types are in their own packages to prevent identiier collisions
// e.g. pcmux::pc_plus4 and regfilemux::pc_plus4 are seperate identifiers
// for seperate enumerated types
import pcmux::*;
import marmux::*;
import cmpmux::*;
import alumux::*;
import regfilemux::*;
import targetaddressmux::*;
import idforwardamux::*;
import idforwardbmux::*;
import exforwardamux::*;
import exforwardbmux::*;
import wbmemforwardmux::*;
import arbiteraddressmux::*;
import tournamentmux::*;

/* Specify the width of performance counters. */
localparam perf_counter_width = 32;

/* Specify the depth of branch history recorded. */
localparam history_depth = 8;

/* Specify the number of sets in BTB. */
localparam btb_s_index = 4;

/* Specify the number of sets in BHT. */
localparam bht_s_index = 8;

/* Specify the number of sets in Tournament PHT. */
localparam tournament_pht_s_index = 8;

typedef logic [31:0] rv32i_word;
typedef logic [4:0] rv32i_reg;
typedef logic [3:0] rv32i_mem_wmask;

typedef enum bit [6:0] {
    op_lui   = 7'b0110111, //load upper immediate (U type)
    op_auipc = 7'b0010111, //add upper immediate PC (U type)
    op_jal   = 7'b1101111, //jump and link (J type)
    op_jalr  = 7'b1100111, //jump and link register (I type)
    op_br    = 7'b1100011, //branch (B type)
    op_load  = 7'b0000011, //load (I type)
    op_store = 7'b0100011, //store (S type)
    op_imm   = 7'b0010011, //arith ops with register/immediate operands (I type)
    op_reg   = 7'b0110011, //arith ops with register operands (R type)
    op_csr   = 7'b1110011  //control and status register (I type)
} rv32i_opcode;

typedef enum bit [2:0] {
    beq  = 3'b000,
    bne  = 3'b001,
    blt  = 3'b100,
    bge  = 3'b101,
    bltu = 3'b110,
    bgeu = 3'b111
} branch_funct3_t;

typedef enum bit [2:0] {
    lb  = 3'b000,
    lh  = 3'b001,
    lw  = 3'b010,
    lbu = 3'b100,
    lhu = 3'b101
} load_funct3_t;

typedef enum bit [2:0] {
    sb = 3'b000,
    sh = 3'b001,
    sw = 3'b010
} store_funct3_t;

typedef enum bit [2:0] {
    add  = 3'b000, //check bit30 for sub if op_reg opcode
    sll  = 3'b001,
    slt  = 3'b010,
    sltu = 3'b011,
    axor = 3'b100,
    sr   = 3'b101, //check bit30 for logical/arithmetic
    aor  = 3'b110,
    aand = 3'b111
} arith_funct3_t;

typedef enum bit [2:0] {
    alu_add = 3'b000,
    alu_sll = 3'b001,
    alu_sra = 3'b010,
    alu_sub = 3'b011,
    alu_xor = 3'b100,
    alu_srl = 3'b101,
    alu_or  = 3'b110,
    alu_and = 3'b111
} alu_ops;


typedef enum bit [1:0] {
    br  = 2'b00
    ,jal  = 2'b01
    ,jalr = 2'b10
} btb_ops;

typedef struct packed {

    rv32i_word target_address;
    btb_ops br_jal_jalr;

} btb_entry;

typedef struct packed {

    rv32i_opcode opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    rv32i_reg rs1_id;
    rv32i_reg rs2_id;
    rv32i_reg rd_id;

    alu_ops aluop;
    branch_funct3_t cmpop;

    cmpmux_sel_t cmp_MUX_sel;
    alumux1_sel_t alu_1_MUX_sel;
    alumux2_sel_t alu_2_MUX_sel;
    regfilemux_sel_t regfile_MUX_sel;
    targetaddressmux_sel_t target_address_MUX_sel;

    logic load_regfile;
    logic load_pc;
    logic mem_read;
    logic mem_write;

} rv32i_control_word;

typedef struct packed {

    rv32i_word pc;
    rv32i_word ir;
    logic btb_read_hit;
    btb_entry btb_out;
    logic [history_depth-1:0] local_pht_index;
    logic [history_depth-1:0] global_pht_index;
    logic local_pr;
    logic global_pr;
    logic br_pr;

} if_id_pipeline_reg;

typedef struct packed {

    rv32i_word pc;
    rv32i_word ir;
    rv32i_word rs1_out;
    rv32i_word rs2_out;
    rv32i_word imm; 
    logic br_en;
    rv32i_word target_address;
    rv32i_control_word ctrl;

} id_ex_pipeline_reg;

typedef struct packed {

    rv32i_word pc;
    rv32i_word ir;
    rv32i_word alu_out;
    rv32i_word alu_out_address;
    rv32i_mem_wmask write_read_mask;
    rv32i_word mem_data_out;
    logic br_en;
    rv32i_word imm; 
    rv32i_word target_address;
    rv32i_control_word ctrl;

} ex_mem_pipeline_reg;

typedef struct packed {

    rv32i_word pc;
    rv32i_word ir;
    rv32i_word alu_out;
    rv32i_word MDR;
    rv32i_mem_wmask write_read_mask;  
    logic br_en;
    rv32i_word imm;
    rv32i_word target_address;
    rv32i_control_word ctrl;
    rv32i_word alu_out_address;
    rv32i_word mem_data_out;

} mem_wb_pipeline_reg;

typedef struct packed {
    rv32i_word cpu_address;
} i_cache_pipeline_reg;

typedef struct packed {
    logic [255:0] dataout;
    logic way_0_hit;
    logic way_1_hit;
    logic way_2_hit;
    logic way_3_hit;
    logic hit;
    logic [2:0] LRU_array_dataout;
} i_cache_pipeline_data;

typedef struct packed {

    rv32i_word cpu_address;
    logic [255:0] dataout;
    logic [255:0] mem_wdata;
    logic [31:0]  mem_byte_enable256;
    logic way_0_hit;
    logic way_1_hit;
    logic way_2_hit;
    logic way_3_hit;
    logic hit;
    logic dirty;
    logic mem_write;
    logic mem_read;
    logic [2:0] LRU_array_dataout;

} d_cache_pipeline_reg;

endpackage : rv32i_types

