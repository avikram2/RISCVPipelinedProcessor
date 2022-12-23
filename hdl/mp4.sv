module mp4
import rv32i_types::*;
(
    input clk,
    input rst,
	
    input pmem_resp,
    output logic pmem_read,
    output logic pmem_write,
    output rv32i_word pmem_address,
    input [63:0] pmem_rdata,
    output [63:0] pmem_wdata

);

logic instr_mem_resp;
rv32i_word instr_mem_rdata;
logic data_mem_resp;
rv32i_word data_mem_rdata;
logic instr_read;
rv32i_word instr_mem_address;
logic data_read;
logic data_write;
logic [3:0] data_mbe;
rv32i_word data_mem_address;
rv32i_word data_mem_wdata;
logic continue_i_cache;

cpu cpu (

    .clk(clk),
    .rst(rst),
	
    /* I-Cache Ports */
    .instr_read(instr_read),
    .instr_mem_address(instr_mem_address),
    .instr_mem_rdata(instr_mem_rdata),
    .instr_mem_resp(instr_mem_resp),
    .continue_i_cache(continue_i_cache),


    /* D-Cache Ports */
    .data_read(data_read),
    .data_write(data_write),
    .data_mem_address(data_mem_address),
    .data_mem_rdata(data_mem_rdata), 
    .data_mbe(data_mbe),
    .data_mem_wdata(data_mem_wdata),
	.data_mem_resp(data_mem_resp)

);

cache_sys cache_sys (

    .clk(clk),
    .rst(rst),

    /* Physical Memory Signals */
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),
    .pmem_address(pmem_address),
    .pmem_wdata(pmem_wdata),
    .pmem_rdata(pmem_rdata),
    .pmem_resp(pmem_resp),
    

    /* CPU Memory Signals: I-Cache */
    .instr_read(instr_read),
    .instr_mem_address(instr_mem_address),
    .instr_mem_rdata(instr_mem_rdata),
    .instr_mem_resp(instr_mem_resp),
    .if_id_reg_load(continue_i_cache),


    /* CPU Memory Signals: D-Cache */
    .data_read(data_read),
    .data_write(data_write),
    .data_mem_address(data_mem_address),
    .data_mbe(data_mbe),
    .data_mem_wdata(data_mem_wdata),
    .data_mem_rdata(data_mem_rdata), 
	.data_mem_resp(data_mem_resp)

);

endmodule : mp4
