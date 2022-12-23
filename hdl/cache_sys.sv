module cache_sys
import rv32i_types::*;
(
	input clk,
	input rst,

	/* Physical Memory Signals */
	output logic pmem_read,
	output logic pmem_write,
	output rv32i_word pmem_address,
	output [63:0] pmem_wdata,
	input [63:0] pmem_rdata,
	input logic pmem_resp,
	

	/* CPU Memory Signals: I-Cache */
	input logic instr_read,
	input rv32i_word instr_mem_address,
	output rv32i_word instr_mem_rdata,
	output logic instr_mem_resp,
	input logic if_id_reg_load,


	/* CPU Memory Signals: D-Cache */
	input logic data_read,
	input logic data_write,
	input rv32i_word data_mem_address,
	input logic [3:0] data_mbe,
	input rv32i_word data_mem_wdata,
	output rv32i_word data_mem_rdata, 
	output logic data_mem_resp
);

logic [31:0] a_pmem_address;
logic [31:0] cla_pmem_address;

logic i_pmem_resp;
logic [255:0] i_pmem_rdata;
logic [31:0] i_pmem_address;
logic i_pmem_read;

logic d_pmem_resp;
logic [255:0] d_pmem_rdata;
logic [31:0] d_pmem_address;
logic [255:0] d_pmem_wdata;
logic d_pmem_read;
logic d_pmem_write;

arbiteraddressmux::arbiteraddressmux_sel_t arbiter_address_MUX_sel;

logic a_pmem_resp;
logic [255:0] a_pmem_rdata;
logic [255:0] a_pmem_wdata;
logic a_pmem_read;
logic a_pmem_write;

logic cla_pmem_resp;
logic [255:0] cla_pmem_rdata;
logic [255:0] cla_pmem_wdata;
logic cla_pmem_read;
logic cla_pmem_write;

/* Does not pass synthesis, use for simulation only. */

// always @ (posedge cla_pmem_read or posedge cla_pmem_write)
// begin
// 	$display("a_pmem_address = %27b", cla_pmem_address[31:5]);
// end

/* L2 Perf Counter Signals*/
logic [perf_counter_width-1:0] num_l2_request;
logic num_l2_request_overflow;
// logic [perf_counter_width-1:0] num_l2_miss;
// logic num_l2_miss_overflow;

p_i_cache i_cache (

	.clk(clk),
	.rst(rst),

	/* Physical memory signals */
	.pmem_resp(i_pmem_resp),
	.pmem_rdata(i_pmem_rdata),
	.pmem_address(i_pmem_address),
	.pmem_wdata(), // output by cache, no hardwire
	.pmem_read(i_pmem_read),
	.pmem_write(), // output by cache, no hardwire

	/* CPU memory signals */
	.mem_read(instr_read),
	.mem_write(1'b0),
	.mem_byte_enable_cpu(4'b0),
	.mem_address(instr_mem_address),
	.mem_wdata_cpu(32'b0),
	.mem_resp(instr_mem_resp),
	.mem_rdata_cpu(instr_mem_rdata),
	.if_id_reg_load(if_id_reg_load)

);

/* Count the total number of L2 cache requests. */
perf_counter #(.width(perf_counter_width)) l2total
(
	.clk(a_pmem_read || a_pmem_write),
    .rst(rst),
    .count(1'b1),
    .overflow(num_l2_request_overflow),
    .out(num_l2_request)
);

// /* Count the total number of L2 cache misses. */
// perf_counter #(.width(perf_counter_width)) l2miss
// (
// 	.clk(cla_pmem_read || cla_pmem_write),
//     .rst(rst),
//     .count(1'b1),
//     .overflow(num_l2_miss_overflow),
//     .out(num_l2_miss)
// );

cache d_cache (

	.clk(clk),
	.rst(rst),

	/* Physical memory signals */
	.pmem_resp(d_pmem_resp),
	.pmem_rdata(d_pmem_rdata),
	.pmem_address(d_pmem_address),
	.pmem_wdata(d_pmem_wdata),
	.pmem_read(d_pmem_read),
	.pmem_write(d_pmem_write),

	/* CPU memory signals */
	.mem_read(data_read),
	.mem_write(data_write),
	.mem_byte_enable_cpu(data_mbe),
	.mem_address(data_mem_address),
	.mem_wdata_cpu(data_mem_wdata),
	.mem_resp(data_mem_resp),
	.mem_rdata_cpu(data_mem_rdata)

);

arbiter_datapath arbiter_datapath (

	
	/* I-Cache Side Signals */
	.i_pmem_address(i_pmem_address),
	.i_pmem_rdata(i_pmem_rdata),

	/* D-Cache Side Signals */
	.d_pmem_address(d_pmem_address),
	.d_pmem_wdata(d_pmem_wdata),
	.d_pmem_rdata(d_pmem_rdata),


	/* Physical Memory Side Signals */
	.a_pmem_address(a_pmem_address),
	.a_pmem_wdata(a_pmem_wdata),
	.a_pmem_rdata(a_pmem_rdata),

	/* Control to Datapath */
	.arbiter_address_MUX_sel(arbiter_address_MUX_sel)
);

arbiter_control arbiter_control (
	.clk(clk),
	.rst(rst),
	
	/* I-Cache Side Signals */
	.i_pmem_resp(i_pmem_resp),
	.i_pmem_read(i_pmem_read),

	/* D-Cache Side Signals */
	.d_pmem_resp(d_pmem_resp),
	.d_pmem_read(d_pmem_read),
	.d_pmem_write(d_pmem_write),

	/* Memory Side Signals */
	.a_pmem_resp(a_pmem_resp),
	.a_pmem_read(a_pmem_read),
	.a_pmem_write(a_pmem_write),

	/* Control to Datapath */
	.arbiter_address_MUX_sel(arbiter_address_MUX_sel)
);

l2_cache l2_cache (
	.clk(clk),
	.rst(rst),

    /* Arbiter Side Signals */
    .mem_address(a_pmem_address),
    .mem_rdata256(a_pmem_rdata),
    .mem_wdata256(a_pmem_wdata),
    .mem_read(a_pmem_read),
    .mem_write(a_pmem_write),
    .mem_resp(a_pmem_resp),

    /* Cacheline Adaptor Side Signals */
    .pmem_address(cla_pmem_address),
    .pmem_rdata(cla_pmem_rdata),
    .pmem_wdata(cla_pmem_wdata),
    .pmem_read(cla_pmem_read),
    .pmem_write(cla_pmem_write),
    .pmem_resp(cla_pmem_resp)
);

cacheline_adaptor cacheline_adaptor (
	
	.clk(clk),
	.reset_n(~rst),

	// Port to LLC (Lowest Level Cache)
	.line_i(cla_pmem_wdata),
	.line_o(cla_pmem_rdata),
	.address_i(cla_pmem_address),
	.read_i(cla_pmem_read),
	.write_i(cla_pmem_write),
	.resp_o(cla_pmem_resp),

	// Port to memory
	.burst_i(pmem_rdata),
	.burst_o(pmem_wdata),
	.address_o(pmem_address),
	.read_o(pmem_read),
	.write_o(pmem_write),
	.resp_i(pmem_resp)
);

endmodule : cache_sys
