/* MODIFY. Your cache design. It contains the cache
controller, cache datapath, and bus adapter. */

module l2_cache 
import rv32i_types::*;
import cache_mux_types::*;
#(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index,
    parameter num_ways = 4
)
(
    input clk,
    input rst,

    /* CPU memory signals */
    input   logic [31:0]    mem_address,
    output  logic [255:0]   mem_rdata256,
    input   logic [255:0]   mem_wdata256,
    input   logic           mem_read,
    input   logic           mem_write,
    output  logic           mem_resp,

    /* Physical memory signals */
    output  logic [31:0]    pmem_address,
    input   logic [255:0]   pmem_rdata,
    output  logic [255:0]   pmem_wdata,
    output  logic           pmem_read,
    output  logic           pmem_write,
    input   logic           pmem_resp
);

logic [31:0]  mem_byte_enable256;
assign mem_byte_enable256 = '1;

/* Datapath to Control */
logic hit;
logic way_0_hit;
logic way_1_hit;
logic way_2_hit;
logic way_3_hit;

logic v_array_0_dataout;
logic v_array_1_dataout;
logic v_array_2_dataout;
logic v_array_3_dataout;

logic d_array_0_dataout;
logic d_array_1_dataout;
logic d_array_2_dataout;
logic d_array_3_dataout;

logic [2:0] LRU_array_dataout;

/* Control to Datapath */
logic v_array_0_load;
logic v_array_0_datain;
logic v_array_1_load;
logic v_array_1_datain;
logic v_array_2_load;
logic v_array_2_datain;
logic v_array_3_load;
logic v_array_3_datain;

logic d_array_0_load;
logic d_array_0_datain;
logic d_array_1_load;
logic d_array_1_datain;
logic d_array_2_load;
logic d_array_2_datain;
logic d_array_3_load;
logic d_array_3_datain;

logic tag_array_0_load;
logic tag_array_1_load;
logic tag_array_2_load;
logic tag_array_3_load;

logic [31:0] datapath_pmem_address;
logic [31:0] ewb_pmem_address;

logic LRU_array_load;
logic [2:0] LRU_array_datain;

logic memory_buffer_register_load;

dataarraymux_sel_t write_en_0_MUX_sel;
dataarraymux_sel_t write_en_1_MUX_sel;
dataarraymux_sel_t write_en_2_MUX_sel;
dataarraymux_sel_t write_en_3_MUX_sel;
dataarraymux_sel_t data_array_0_datain_MUX_sel;
dataarraymux_sel_t data_array_1_datain_MUX_sel;
dataarraymux_sel_t data_array_2_datain_MUX_sel;
dataarraymux_sel_t data_array_3_datain_MUX_sel;

logic [1:0] dataout_MUX_sel;

pmemaddressmux_sel_t pmem_address_MUX_sel;


logic load_ewb;
logic wb_ewb;
logic tag_check;
logic ewb_hit;

logic ewb_full;

logic [255:0] ewb_dataout;
logic [255:0] datapath_dataout;
logic ewb_empty;

ewb ewb (
    .clk, 
    .rst, 
    .data_i(datapath_dataout),
    .addr_i(datapath_pmem_address),

    .tag_check(tag_check),
    .tag_i(mem_address[31:5]),
    .hit_o(ewb_hit),
    .read_o(ewb_dataout),
    .empty_o(ewb_empty),
    .valid_i(load_ewb),
    .data_o(pmem_wdata),
    .addr_o(ewb_pmem_address),
    .yumi_i(wb_ewb),
    .write_ewb_i(mem_write),
    .replace_i(mem_wdata256),
    .full_o(ewb_full)
);

always_comb begin
    mem_rdata256 = datapath_dataout;
    if (hit == 1'b1)
        mem_rdata256 = datapath_dataout;
    else if (ewb_hit == 1'b1)
        mem_rdata256 = ewb_dataout;
end

always_comb begin
    pmem_address = datapath_pmem_address;
    if (pmem_write == 1'b1)
        pmem_address = ewb_pmem_address;

end

l2_cache_control control (.*);

l2_cache_datapath datapath (.mem_rdata256(datapath_dataout), .pmem_wdata(), .pmem_address(datapath_pmem_address), .*);


endmodule : l2_cache
