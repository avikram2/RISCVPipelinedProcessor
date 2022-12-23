module p_d_cache
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
  /* Physical memory signals */
  input logic pmem_resp,
  input logic [255:0] pmem_rdata,
  output logic [31:0] pmem_address,
  output logic [255:0] pmem_wdata,
  output logic pmem_read,
  output logic pmem_write,

  /* CPU memory signals */
  input logic mem_read,
  input logic mem_write,
  input logic [3:0] mem_byte_enable_cpu,
  input logic [31:0] mem_address,
  input logic [31:0] mem_wdata_cpu,
  input logic if_id_reg_load,
  output logic mem_resp,
  output logic [31:0] mem_rdata_cpu
);


logic [255:0] mem_wdata;
logic [255:0] mem_rdata;
logic [31:0] mem_byte_enable;

logic v_array_0_dataout;
logic v_array_1_dataout;
logic v_array_2_dataout;
logic v_array_3_dataout;

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

logic LRU_array_load;

logic [2:0] LRU_array_datain;

logic load_d_cache_reg;

logic read_array_flag;

d_cache_pipeline_reg cache_pipeline_in;
d_cache_pipeline_reg cache_pipeline_out;


dataarraymux_sel_t write_en_0_MUX_sel;
dataarraymux_sel_t write_en_1_MUX_sel;
dataarraymux_sel_t write_en_2_MUX_sel;
dataarraymux_sel_t write_en_3_MUX_sel;
dataarraymux_sel_t data_array_0_datain_MUX_sel;
dataarraymux_sel_t data_array_1_datain_MUX_sel;
dataarraymux_sel_t data_array_2_datain_MUX_sel;
dataarraymux_sel_t data_array_3_datain_MUX_sel;

paddressmux_sel_t address_mux_sel;

rv32i_word address_MUX_out;

logic [1:0] dataout_MUX_sel;

pmemaddressmux_sel_t pmem_address_MUX_sel;

p_d_cache_control control(
  .clk,
  .rst,

  /* CPU memory signals */
  .mem_read,
  .mem_write,
  .mem_resp,

  /* Physical memory signals */
  .pmem_resp,
  .pmem_read,
  .pmem_write,

  /* Datapath to Control */
  .v_array_0_dataout,
  .v_array_1_dataout,
  .v_array_2_dataout,
  .v_array_3_dataout,

  .cache_pipeline_out,
  .cache_pipeline_in,

  /* Control to Datapath */
  .v_array_0_load,
  .v_array_0_datain,
  .v_array_1_load,
  .v_array_1_datain,
  .v_array_2_load,
  .v_array_2_datain,
  .v_array_3_load,
  .v_array_3_datain,
  .d_array_0_load,
  .d_array_0_datain,
  .d_array_1_load,
  .d_array_1_datain,
  .d_array_2_load,
  .d_array_2_datain,
  .d_array_3_load,
  .d_array_3_datain,
  .tag_array_0_load,
  .tag_array_1_load,
  .tag_array_2_load,
  .tag_array_3_load,

  .LRU_array_load,
  .LRU_array_datain,

  .write_en_0_MUX_sel,
  .write_en_1_MUX_sel,
  .write_en_2_MUX_sel,
  .write_en_3_MUX_sel,
  .data_array_0_datain_MUX_sel,
  .data_array_1_datain_MUX_sel,
  .data_array_2_datain_MUX_sel,
  .data_array_3_datain_MUX_sel,
  .load_d_cache_reg,
  .if_id_reg_load,
  .read_array_flag,
  .address_mux_sel,
  .dataout_MUX_sel,
  .pmem_address_MUX_sel
);


//STAGE 1: COMPARE TAG AND SEE IF HIT OR MISS

assign cache_pipeline_in.cpu_address = mem_address;
assign cache_pipeline_in.mem_write = mem_write;
assign cache_pipeline_in.mem_read = mem_read;
assign cache_pipeline_in.mem_wdata = mem_wdata;
assign cache_pipeline_in.mem_byte_enable256 = mem_byte_enable;

p_d_cache_metadata_check check
(
  .clk,
  .rst,
  /* CPU memory signals */
  .mem_address(address_MUX_out),
  .mem_byte_enable256(cache_pipeline_in.mem_byte_enable256),
  .mem_wdata256(cache_pipeline_in.mem_wdata),		// write happens for the previous instruction, which is at the second stage

  /* Physical memory data signals */
  .pmem_rdata,
  .pmem_address,
  .pmem_wdata,

  .hit(cache_pipeline_in.hit),
  .way_0_hit(cache_pipeline_in.way_0_hit),
  .way_1_hit(cache_pipeline_in.way_1_hit),
  .way_2_hit(cache_pipeline_in.way_2_hit),
  .way_3_hit(cache_pipeline_in.way_3_hit),
  
  .v_array_0_dataout,
  .v_array_1_dataout,
  .v_array_2_dataout,
  .v_array_3_dataout,

  .dirty_out(cache_pipeline_in.dirty),

  // LRU array width is now 3.
  .LRU_array_dataout(cache_pipeline_in.LRU_array_dataout),

  /* Control to Datapath */
  .v_array_0_load,
  .v_array_0_datain,
  .v_array_1_load,
  .v_array_1_datain,
  .v_array_2_load,
  .v_array_2_datain,
  .v_array_3_load,
  .v_array_3_datain,

  .d_array_0_load,
  .d_array_0_datain,
  .d_array_1_load,
  .d_array_1_datain,
  .d_array_2_load,
  .d_array_2_datain,
  .d_array_3_load,
  .d_array_3_datain,

  .tag_array_0_load,
  .tag_array_1_load,
  .tag_array_2_load,
  .tag_array_3_load,

  .LRU_array_load,
  .LRU_array_datain,
  
  .write_en_0_MUX_sel,
  .write_en_1_MUX_sel,
  .write_en_2_MUX_sel,
  .write_en_3_MUX_sel,

  .data_array_0_datain_MUX_sel,
  .data_array_1_datain_MUX_sel,
  .data_array_2_datain_MUX_sel,
  .data_array_3_datain_MUX_sel,
  .prev_address(cache_pipeline_out.cpu_address),
  .read_array_flag,
  .dataout_MUX_sel,
  .pmem_address_MUX_sel,
  .dataout(cache_pipeline_in.dataout)
);


always_comb begin : ADDRESSMUX
  address_MUX_out = mem_address;
  unique case (address_mux_sel)
    curr_cpu_address: address_MUX_out = mem_address;
    prev_cpu_address: address_MUX_out = cache_pipeline_out.cpu_address;
  endcase
end


p_d_cache_reg pipeline_reg
(
  .clk,
  .rst, 
  .load(load_d_cache_reg),
  .in(cache_pipeline_in),
  .out(cache_pipeline_out)
);

//STAGE 2: DELIVER DATA
assign mem_rdata = cache_pipeline_in.dataout;


p_line_adapter bus (
    .mem_wdata_line(mem_wdata),
    .mem_rdata_line(mem_rdata),
    .mem_wdata(mem_wdata_cpu),
    .mem_rdata(mem_rdata_cpu),
    .mem_byte_enable(mem_byte_enable_cpu),
    .mem_byte_enable_line(mem_byte_enable),
    .address(cache_pipeline_out.cpu_address)
);




endmodule : p_d_cache
