`ifndef RVFI_ITF
`define RVFI_ITF

interface rvfi_itf(input clk, input rst);

    logic halt;
    logic commit;
    logic [63:0] order;
    logic [31:0] inst;
    logic trap;
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [31:0] rs1_rdata;
    logic [31:0] rs2_rdata;
    logic load_regfile;
    logic [4:0] rd_addr;
    logic [31:0] rd_wdata;
    logic [31:0] pc_rdata;
    logic [31:0] pc_wdata;
    logic [31:0] mem_addr;
    logic [3:0] mem_rmask;
    logic [3:0] mem_wmask;
    logic [31:0] mem_rdata;
    logic [31:0] mem_wdata;

    logic [15:0] errcode;

endinterface

`endif
