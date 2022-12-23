package pcmux;
typedef enum bit [2:0] {
    pc_plus4  = 3'b000
    ,adder_out  = 3'b001
    ,adder_mod2 = 3'b010
    ,btb_out    = 3'b011
    ,if_id_out_pc_plus4 = 3'b100
} pcmux_sel_t;
endpackage

package marmux;
typedef enum bit {
    pc_out   = 1'b0
    ,alu_out = 1'b1
} marmux_sel_t;
endpackage

package cmpmux;
typedef enum bit {
    rs2_out = 1'b0
    ,imm    = 1'b1
} cmpmux_sel_t;
endpackage

package alumux;
typedef enum bit {
    rs1_out = 1'b0
    ,pc_out = 1'b1
} alumux1_sel_t;

typedef enum bit {
    imm      = 1'b0
    ,rs2_out = 1'b1
} alumux2_sel_t;
endpackage

package regfilemux;
typedef enum bit [2:0] {
    alu_out   = 3'b000
    ,br_en    = 3'b001
    ,imm      = 3'b010
    ,load     = 3'b011
    ,pc_plus4 = 3'b100
} regfilemux_sel_t;
endpackage

package targetaddressmux;
typedef enum bit {
    pc       = 1'b0
    ,rs1_out = 1'b1
} targetaddressmux_sel_t;
endpackage

package idforwardamux;
typedef enum bit [2:0] {
    no_forward          = 3'b000 //
    ,ex_br_en           = 3'b001 //
    ,ex_imm             = 3'b010 //
    ,mem_pc_plus4       = 3'b011 //
    ,mem_alu_out        = 3'b100 //
    ,mem_imm            = 3'b101 // 
} idforwardamux_sel_t;
endpackage

package idforwardbmux;
typedef enum bit [2:0] {
    no_forward          = 3'b000
    ,ex_br_en           = 3'b001
    ,ex_imm             = 3'b010
    ,mem_pc_plus4       = 3'b011
    ,mem_alu_out        = 3'b100
    ,mem_imm            = 3'b101
} idforwardbmux_sel_t;
endpackage

package exforwardamux;
typedef enum bit [2:0] {
    no_forward             = 3'b000 
    ,mem_alu_out           = 3'b001 
    ,mem_imm               = 3'b010 
    ,wb_regfile_MUX_out    = 3'b011
    ,mem_br_en             = 3'b100
} exforwardamux_sel_t;
endpackage 

package exforwardbmux;
typedef enum bit [2:0] {
    no_forward             = 3'b000 
    ,mem_alu_out           = 3'b001 
    ,mem_imm               = 3'b010 
    ,wb_regfile_MUX_out    = 3'b011
    ,mem_br_en             = 3'b100
} exforwardbmux_sel_t;
endpackage

package wbmemforwardmux;
typedef enum bit {
    no_forward          = 1'b0
    ,regfile_MUX_out    = 1'b1
} wbmemforwardmux_sel_t;
endpackage

package arbiteraddressmux;
typedef enum bit {
    d_cache          = 1'b0
    ,i_cache         = 1'b1
} arbiteraddressmux_sel_t;
endpackage

package tournamentmux;
typedef enum bit {
    local_pred           = 1'b0
    ,global_pred         = 1'b1
} tournamentmux_sel_t;
endpackage
