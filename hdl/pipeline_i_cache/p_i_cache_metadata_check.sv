`define BAD_MUX_SEL $display("%0d: %s:  %0t: Illegal MUX Select", `__LINE__, `__FILE__, $time)
module p_i_cache_metadata_check 
import rv32i_types::*; // MP3CP1_error: is this the right place to put "import" statement?
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
  input logic [31:0]    prev_address,

  /* Physical memory data signals */
  input  logic [255:0] pmem_rdata,
  output logic [31:0]  pmem_address,

/* Control signals */
  /* Datapath to Control */
  output logic hit,
  output logic way_0_hit,
  output logic way_1_hit,
  output logic way_2_hit,
  output logic way_3_hit,
  
  output logic v_array_0_dataout,
  output logic v_array_1_dataout,
  output logic v_array_2_dataout,
  output logic v_array_3_dataout,

  // LRU array width is now 3.
  output logic [2:0] LRU_array_dataout,

  output logic [255:0] dataout,

  /* Control to Datapath */
  input logic v_array_0_load,
  input logic v_array_0_datain,
  input logic v_array_1_load,
  input logic v_array_1_datain,
  input logic v_array_2_load,
  input logic v_array_2_datain,
  input logic v_array_3_load,
  input logic v_array_3_datain,

  input logic tag_array_0_load,
  input logic tag_array_1_load,
  input logic tag_array_2_load,
  input logic tag_array_3_load,

  input logic LRU_array_load,
  // LRU array width is now 3.
  input logic [2:0] LRU_array_datain,
  
  input dataarraymux_sel_t write_en_0_MUX_sel,
  input dataarraymux_sel_t write_en_1_MUX_sel,
  input dataarraymux_sel_t write_en_2_MUX_sel,
  input dataarraymux_sel_t write_en_3_MUX_sel,

  input dataarraymux_sel_t data_array_0_datain_MUX_sel,
  input dataarraymux_sel_t data_array_1_datain_MUX_sel,
  input dataarraymux_sel_t data_array_2_datain_MUX_sel,
  input dataarraymux_sel_t data_array_3_datain_MUX_sel, 
  
  input logic read_array_flag

);

logic [255:0] data_array_0_dataout;
logic [255:0] data_array_1_dataout;
logic [255:0] data_array_2_dataout;
logic [255:0] data_array_3_dataout;
logic [255:0] data_array_0_datain_MUX_out;
logic [255:0] data_array_1_datain_MUX_out;
logic [255:0] data_array_2_datain_MUX_out;
logic [255:0] data_array_3_datain_MUX_out;

logic [31:0] write_en_0_MUX_out;
logic [31:0] write_en_1_MUX_out;
logic [31:0] write_en_2_MUX_out;
logic [31:0] write_en_3_MUX_out;

logic [s_tag-1:0] tag_array_0_dataout;
logic [s_tag-1:0] tag_array_1_dataout;
logic [s_tag-1:0] tag_array_2_dataout;
logic [s_tag-1:0] tag_array_3_dataout;


assign pmem_address = {mem_address[31:5], 5'b0};


//valid array
l2_array #(.s_index(s_index), .width(1)) v_array [num_ways-1:0] (
    .clk({clk, clk, clk, clk}),
    .rst({rst, rst, rst, rst}),
    .read({read_array_flag, read_array_flag, read_array_flag, read_array_flag}),
    .load({v_array_3_load, v_array_2_load, v_array_1_load, v_array_0_load}),
    .rindex({mem_address[7:5], mem_address[7:5], mem_address[7:5], mem_address[7:5]}),
    .windex({mem_address[7:5], mem_address[7:5], mem_address[7:5], mem_address[7:5]}),
    .datain({v_array_3_datain, v_array_2_datain, v_array_1_datain, v_array_0_datain}),
    .dataout({v_array_3_dataout, v_array_2_dataout, v_array_1_dataout, v_array_0_dataout})
);

//tag array
l2_array #(.s_index(s_index), .width(s_tag)) tag_array [num_ways-1:0] (
    .clk({clk, clk, clk, clk}),
    .rst({rst, rst, rst, rst}),
    .read({read_array_flag, read_array_flag, read_array_flag, read_array_flag}),
    .load({tag_array_3_load, tag_array_2_load, tag_array_1_load, tag_array_0_load}),
    .rindex({mem_address[7:5], mem_address[7:5], mem_address[7:5], mem_address[7:5]}),
    .windex({mem_address[7:5], mem_address[7:5], mem_address[7:5], mem_address[7:5]}),
    .datain({mem_address[31:8], mem_address[31:8], mem_address[31:8], mem_address[31:8]}),
    .dataout({tag_array_3_dataout, tag_array_2_dataout, tag_array_1_dataout, tag_array_0_dataout})
);

//data array
l2_data_array #(.s_offset(s_offset), .s_index(s_index)) data_array [num_ways-1:0] (
    .clk({clk, clk, clk, clk}),
    .read({read_array_flag, read_array_flag, read_array_flag, read_array_flag}),
    .write_en({write_en_3_MUX_out, write_en_2_MUX_out, write_en_1_MUX_out, write_en_0_MUX_out}),
    .rindex({mem_address[7:5], mem_address[7:5], mem_address[7:5], mem_address[7:5]}),
    .windex({mem_address[7:5], mem_address[7:5], mem_address[7:5], mem_address[7:5]}),
    .datain({data_array_3_datain_MUX_out, data_array_2_datain_MUX_out, data_array_1_datain_MUX_out, data_array_0_datain_MUX_out}),
    .dataout({data_array_3_dataout, data_array_2_dataout, data_array_1_dataout, data_array_0_dataout})
);

// LRU array width is now 3.
l2_array #(.s_index(s_index), .width(3)) LRU_array (

    .clk(clk),
    .rst(rst),
    .read(read_array_flag),
    .load(LRU_array_load),
    .rindex(mem_address[7:5]),
    .windex(mem_address[7:5]),
    .datain(LRU_array_datain),
    .dataout(LRU_array_dataout)

);

always_comb begin : WRITE_EN_0_MUX

    unique case (write_en_0_MUX_sel)

        no_write       : write_en_0_MUX_out = '0;
        mem_write_cache: write_en_0_MUX_out = '1;

        default: 
        begin
            `BAD_MUX_SEL;
            write_en_0_MUX_out = '0;
        end
    endcase
end

always_comb begin : WRITE_EN_1_MUX

    unique case (write_en_1_MUX_sel)

        no_write       : write_en_1_MUX_out = '0;
        mem_write_cache: write_en_1_MUX_out = '1;

        default: 
        begin
            `BAD_MUX_SEL;
            write_en_1_MUX_out = '0;
        end
    endcase
end

always_comb begin : WRITE_EN_2_MUX

    unique case (write_en_2_MUX_sel)

        no_write       : write_en_2_MUX_out = '0;
        mem_write_cache: write_en_2_MUX_out = '1;

        default: 
        begin
            `BAD_MUX_SEL;
            write_en_2_MUX_out = '0;
        end
    endcase
end

always_comb begin : WRITE_EN_3_MUX

    unique case (write_en_3_MUX_sel)

        no_write       : write_en_3_MUX_out = '0;
        mem_write_cache: write_en_3_MUX_out = '1;

        default: 
        begin
            `BAD_MUX_SEL;
            write_en_3_MUX_out = '0;
        end
    endcase
end


always_comb begin : data_array_0_datain_MUX

  unique case (data_array_0_datain_MUX_sel)

      no_write       : data_array_0_datain_MUX_out = '0;
      mem_write_cache: data_array_0_datain_MUX_out = pmem_rdata;

      default: 
      begin
          `BAD_MUX_SEL;
          data_array_0_datain_MUX_out = '0;
      end
  endcase
end

always_comb begin : data_array_1_datain_MUX

  unique case (data_array_1_datain_MUX_sel)

      no_write       : data_array_1_datain_MUX_out = '0;
      mem_write_cache: data_array_1_datain_MUX_out = pmem_rdata;

      default: 
      begin
          `BAD_MUX_SEL;
          data_array_1_datain_MUX_out = '0;
      end
  endcase
end

always_comb begin : data_array_2_datain_MUX

  unique case (data_array_2_datain_MUX_sel)

      no_write       : data_array_2_datain_MUX_out = '0;
      mem_write_cache: data_array_2_datain_MUX_out = pmem_rdata;

      default: 
      begin
          `BAD_MUX_SEL;
          data_array_2_datain_MUX_out = '0;
      end
  endcase
end

always_comb begin : data_array_3_datain_MUX

  unique case (data_array_3_datain_MUX_sel)

      no_write       : data_array_3_datain_MUX_out = '0;
      mem_write_cache: data_array_3_datain_MUX_out = pmem_rdata;

      default: 
      begin
          `BAD_MUX_SEL;
          data_array_3_datain_MUX_out = '0;
      end
  endcase
end

always_comb begin : HIT_MISS_DETERMINATION 
  dataout = '0;
  hit = 1'b0;
  way_0_hit = 1'b0;
  way_1_hit = 1'b0;
  way_2_hit = 1'b0;
  way_3_hit = 1'b0;

  if(tag_array_0_dataout == prev_address[31:8])
  begin
      if(v_array_0_dataout == 1'b1)
      begin
          way_0_hit = 1'b1;
          dataout = data_array_0_dataout;
      end
  end
      
  if(tag_array_1_dataout == prev_address[31:8])
  begin
      if(v_array_1_dataout == 1'b1)
      begin
          way_1_hit = 1'b1;
          dataout = data_array_1_dataout;
      end
  end

  if(tag_array_2_dataout == prev_address[31:8])
  begin
      if(v_array_2_dataout == 1'b1)
      begin
          way_2_hit = 1'b1;
          dataout = data_array_2_dataout;
      end
  end
      
  if(tag_array_3_dataout == prev_address[31:8])
  begin
      if(v_array_3_dataout == 1'b1)
      begin
          way_3_hit = 1'b1;
          dataout = data_array_3_dataout;
      end
  end

  if(way_0_hit == 1'b1 || way_1_hit == 1'b1 || 
     way_2_hit == 1'b1 || way_3_hit == 1'b1)
      hit = 1'b1;

end






endmodule : p_i_cache_metadata_check
