module btb 
import rv32i_types::*; 
#(
    parameter s_index = 3
)
(
    input logic clk,
    input logic rst,
    input rv32i_word read_address,
    input rv32i_word write_address,
    input logic load,
    input btb_entry in,
    output btb_entry out,
    output logic read_hit
);

localparam s_tag = 32 - s_index - 2;

logic read_way_0_hit;
logic read_way_1_hit;
logic read_way_2_hit;
logic read_way_3_hit;

logic tag_array_0_load;
logic tag_array_1_load;
logic tag_array_2_load;
logic tag_array_3_load;

logic [s_tag-1:0] tag_array_0_datain;
logic [s_tag-1:0] tag_array_1_datain;
logic [s_tag-1:0] tag_array_2_datain;
logic [s_tag-1:0] tag_array_3_datain;

logic [s_tag-1:0] tag_array_0_dataout;
logic [s_tag-1:0] tag_array_1_dataout;
logic [s_tag-1:0] tag_array_2_dataout;
logic [s_tag-1:0] tag_array_3_dataout;

logic data_array_0_load;
logic data_array_1_load;
logic data_array_2_load;
logic data_array_3_load;

btb_entry data_array_0_datain;
btb_entry data_array_1_datain;
btb_entry data_array_2_datain;
btb_entry data_array_3_datain;

btb_entry data_array_0_dataout;
btb_entry data_array_1_dataout;
btb_entry data_array_2_dataout;
btb_entry data_array_3_dataout;

logic v_array_0_load;
logic v_array_1_load;
logic v_array_2_load;
logic v_array_3_load;

logic v_array_0_datain;
logic v_array_1_datain;
logic v_array_2_datain;
logic v_array_3_datain;

logic v_array_0_dataout;
logic v_array_1_dataout;
logic v_array_2_dataout;
logic v_array_3_dataout;

logic LRU_array_load;
logic [2:0] LRU_array_datain_read_hit;
logic [2:0] LRU_array_datain_write_miss;
logic LRU_array_load_read_hit;
logic LRU_array_load_write_miss;
logic [2:0] LRU_array_datain;
logic [2:0] LRU_array_dataout;

btb_array #(.s_index(s_index), .width(s_tag)) tag_array_0 (
    .clk(clk),
    .rst(rst),
    .load(tag_array_0_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(tag_array_0_datain),
    .out(tag_array_0_dataout)
);

btb_array #(.s_index(s_index), .width(s_tag)) tag_array_1 (
    .clk(clk),
    .rst(rst),
    .load(tag_array_1_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(tag_array_1_datain),
    .out(tag_array_1_dataout)
);


btb_array #(.s_index(s_index), .width(s_tag)) tag_array_2 (
    .clk(clk),
    .rst(rst),
    .load(tag_array_2_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(tag_array_2_datain),
    .out(tag_array_2_dataout)
);


btb_array #(.s_index(s_index), .width(s_tag)) tag_array_3 (
    .clk(clk),
    .rst(rst),
    .load(tag_array_3_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(tag_array_3_datain),
    .out(tag_array_3_dataout)
);

btb_array #(.s_index(s_index), .width(34)) data_array_0 (
    .clk(clk),
    .rst(rst),
    .load(data_array_0_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(data_array_0_datain),
    .out(data_array_0_dataout)
);

btb_array #(.s_index(s_index), .width(34)) data_array_1 (
    .clk(clk),
    .rst(rst),
    .load(data_array_1_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(data_array_1_datain),
    .out(data_array_1_dataout)
);

btb_array #(.s_index(s_index), .width(34)) data_array_2 (
    .clk(clk),
    .rst(rst),
    .load(data_array_2_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(data_array_2_datain),
    .out(data_array_2_dataout)
);

btb_array #(.s_index(s_index), .width(34)) data_array_3 (
    .clk(clk),
    .rst(rst),
    .load(data_array_3_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(data_array_3_datain),
    .out(data_array_3_dataout)
);

btb_array #(.s_index(s_index), .width(1)) v_array_0 (
    .clk(clk),
    .rst(rst),
    .load(v_array_0_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(v_array_0_datain),
    .out(v_array_0_dataout)
);

btb_array #(.s_index(s_index), .width(1)) v_array_1 (
    .clk(clk),
    .rst(rst),
    .load(v_array_1_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(v_array_1_datain),
    .out(v_array_1_dataout)
);

btb_array #(.s_index(s_index), .width(1)) v_array_2 (
    .clk(clk),
    .rst(rst),
    .load(v_array_2_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(v_array_2_datain),
    .out(v_array_2_dataout)
);

btb_array #(.s_index(s_index), .width(1)) v_array_3 (
    .clk(clk),
    .rst(rst),
    .load(v_array_3_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(v_array_3_datain),
    .out(v_array_3_dataout)
);

btb_array #(.s_index(s_index), .width(3)) LRU_array (
    .clk(clk),
    .rst(rst),
    .load(LRU_array_load),
    .rindex(read_address[s_index+1:2]),
    .windex(write_address[s_index+1:2]),
    .in(LRU_array_datain),
    .out(LRU_array_dataout)
);

function void allocate_way(logic [1:0] way_idx, logic [s_tag-1:0] new_tag, btb_entry data_in);

    if (way_idx == 2'b00)
    begin
        tag_array_0_datain = new_tag;
        tag_array_0_load = 1'b1;

        data_array_0_datain = data_in;
        data_array_0_load = 1'b1;

        v_array_0_datain = 1'b1;
        v_array_0_load = 1'b1;

    end

    else if (way_idx == 2'b01)
    begin
        tag_array_1_datain = new_tag;
        tag_array_1_load = 1'b1;

        data_array_1_datain = data_in;
        data_array_1_load = 1'b1;

        v_array_1_datain = 1'b1;
        v_array_1_load = 1'b1;

    end

    else if (way_idx == 2'b10)
    begin
        tag_array_2_datain = new_tag;
        tag_array_2_load = 1'b1;

        data_array_2_datain = data_in;
        data_array_2_load = 1'b1;

        v_array_2_datain = 1'b1;
        v_array_2_load = 1'b1;
    end
    
    else if (way_idx == 2'b11)
    begin
        tag_array_3_datain = new_tag;
        tag_array_3_load = 1'b1;

        data_array_3_datain = data_in;
        data_array_3_load = 1'b1;

        v_array_3_datain = 1'b1;
        v_array_3_load = 1'b1;
    end

endfunction

function void set_defaults_read();

    read_way_0_hit = 1'b0;
    read_way_1_hit = 1'b0;
    read_way_2_hit = 1'b0;
    read_way_3_hit = 1'b0;
    read_hit= 1'b0;
    out = '0;

    LRU_array_datain_read_hit = '0;
    LRU_array_load_read_hit = 1'b0;
    
endfunction

function void set_defaults_write();

    tag_array_0_load = 1'b0;
    tag_array_1_load = 1'b0;
    tag_array_2_load = 1'b0;
    tag_array_3_load = 1'b0;
    tag_array_0_datain = '0;
    tag_array_1_datain = '0;
    tag_array_2_datain = '0;
    tag_array_3_datain = '0;
    
    data_array_0_load = 1'b0;
    data_array_1_load = 1'b0;
    data_array_2_load = 1'b0;
    data_array_3_load = 1'b0;
    data_array_0_datain = '0;
    data_array_1_datain = '0;
    data_array_2_datain = '0;
    data_array_3_datain = '0;
    
    v_array_0_load = 1'b0;
    v_array_1_load = 1'b0;
    v_array_2_load = 1'b0;
    v_array_3_load = 1'b0;
    v_array_0_datain = '0;
    v_array_1_datain = '0;
    v_array_2_datain = '0;
    v_array_3_datain = '0;

    LRU_array_datain_write_miss = '0;
    LRU_array_load_write_miss = 1'b0;

endfunction

always_comb begin : READ_HIT_MISS_DETERMINATION 

    set_defaults_read();

    if(tag_array_0_dataout == read_address[31:s_index+2])
    begin
        if(v_array_0_dataout == 1'b1)
        begin
            read_way_0_hit = 1'b1;
            out = data_array_0_dataout;
            LRU_array_datain_read_hit = {1'b0, 1'b0, LRU_array_dataout[0]};
            LRU_array_load_read_hit = 1'b1;
        end
    end
        
    else if(tag_array_1_dataout == read_address[31:s_index+2])
    begin
        if(v_array_1_dataout == 1'b1)
        begin
            read_way_1_hit = 1'b1;
            out = data_array_1_dataout;
            LRU_array_datain_read_hit = {1'b0, 1'b1, LRU_array_dataout[0]};
            LRU_array_load_read_hit = 1'b1;
        end
    end

    else if(tag_array_2_dataout == read_address[31:s_index+2])
    begin
        if(v_array_2_dataout == 1'b1)
        begin
            read_way_2_hit = 1'b1;
            out = data_array_2_dataout;
            LRU_array_datain_read_hit = {1'b1, LRU_array_dataout[1], 1'b0};
            LRU_array_load_read_hit = 1'b1;
        end
    end

    else if(tag_array_3_dataout == read_address[31:s_index+2])
    begin
        if(v_array_3_dataout == 1'b1)
        begin
            read_way_3_hit = 1'b1;
            out = data_array_3_dataout;
            LRU_array_datain_read_hit = {1'b1, LRU_array_dataout[1], 1'b1};
            LRU_array_load_read_hit = 1'b1;
        end
    end

    if(read_way_0_hit || read_way_1_hit || read_way_2_hit || read_way_3_hit)
    begin
        read_hit = 1'b1;        
    end

end


always_comb begin : WRITE_HIT_MISS_DETERMINATION 

    set_defaults_write();

    if (load)
    begin
        if((tag_array_0_dataout == write_address[31:s_index+2]) && (v_array_0_dataout == 1'b1))
        begin
            data_array_0_datain = in;
            data_array_0_load = 1'b1;
        end
            
        else if((tag_array_1_dataout == write_address[31:s_index+2]) && (v_array_1_dataout == 1'b1))
        begin
            data_array_1_datain = in;
            data_array_1_load = 1'b1;
        end

        else if((tag_array_2_dataout == write_address[31:s_index+2]) && (v_array_2_dataout == 1'b1))
        begin
            data_array_2_datain = in;
            data_array_2_load = 1'b1;
        end

        else if((tag_array_3_dataout == write_address[31:s_index+2]) && (v_array_3_dataout == 1'b1))
        begin
            data_array_3_datain = in;
            data_array_3_load = 1'b1;
        end

        /* Write Miss */
        else 
        begin
 
            if(v_array_0_dataout == 1'b0)
            begin
                allocate_way(2'b00, write_address[31:s_index+2], in);
                LRU_array_datain_write_miss = {1'b0, 1'b0, LRU_array_dataout[0]};
                LRU_array_load_write_miss = 1'b1;
            end
            else if(v_array_1_dataout == 1'b0)
            begin
                allocate_way(2'b01, write_address[31:s_index+2], in);
                LRU_array_datain_write_miss = {1'b0, 1'b1, LRU_array_dataout[0]}; // 1
                LRU_array_load_write_miss = 1'b1;
            end
            else if(v_array_2_dataout == 1'b0)
            begin
                
                allocate_way(2'b10, write_address[31:s_index+2], in);
                LRU_array_datain_write_miss =  {1'b1, LRU_array_dataout[1], 1'b0}; // 2
                LRU_array_load_write_miss = 1'b1;
            end
            else if(v_array_3_dataout == 1'b0)
            begin
                allocate_way(2'b11, write_address[31:s_index+2], in);
                LRU_array_datain_write_miss = {1'b1, LRU_array_dataout[1], 1'b1}; // 3
                LRU_array_load_write_miss = 1'b1;
            end
            else
            begin
                if(LRU_array_dataout[2] == 1'b0)
                begin
                    if(LRU_array_dataout[0] == 1'b0)
                    begin
                        // Alloc way 3
                        allocate_way(2'b11, write_address[31:s_index+2], in);
                        LRU_array_datain_write_miss = {1'b1, LRU_array_dataout[1], 1'b1}; // 3
                        LRU_array_load_write_miss = 1'b1;
                    end
                    else
                    begin
                        // Alloc way 2
                        allocate_way(2'b10, write_address[31:s_index+2], in);
                        LRU_array_datain_write_miss = {1'b1, LRU_array_dataout[1], 1'b0}; // 2
                        LRU_array_load_write_miss = 1'b1;
                    end
                end
                else
                begin
                    if(LRU_array_dataout[1] == 1'b0)
                    begin
                        // Alloc way 1
                        allocate_way(2'b01, write_address[31:s_index+2], in);
                        LRU_array_datain_write_miss = {1'b0, 1'b1, LRU_array_dataout[0]}; // 1
                        LRU_array_load_write_miss = 1'b1;
                    end
                    else
                    begin
                        // Alloc way 0
                        allocate_way(2'b00, write_address[31:s_index+2], in);
                        LRU_array_datain_write_miss = {1'b0, 1'b0, LRU_array_dataout[0]}; // 0
                        LRU_array_load_write_miss = 1'b1;
                    end  
                end
            end

        end
    end

end

always_comb
begin
    if(read_hit)
    begin
        LRU_array_datain = LRU_array_datain_read_hit;
        LRU_array_load = LRU_array_load_read_hit;
    end
    else
    begin
        LRU_array_datain = LRU_array_datain_write_miss;
        LRU_array_load = LRU_array_load_write_miss;
    end
end

endmodule : btb
