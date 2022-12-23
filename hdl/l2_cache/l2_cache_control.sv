/* MODIFY. The cache controller. It is a state machine
that controls the behavior of the cache. */

module l2_cache_control 
import rv32i_types::*;
import cache_mux_types::*;
(

    input clk,
    input rst,


    /* CPU memory signals */
    input   logic           mem_read,
    input   logic           mem_write,
    output  logic           mem_resp,

    /* Physical memory signals */
    input   logic           pmem_resp,
    output  logic           pmem_read,
    output  logic           pmem_write,


    /* Control to EWB */
    output logic tag_check,
    output logic load_ewb,
    output logic wb_ewb,

    /* EWB to Control */
    input logic ewb_hit,

    input logic ewb_empty,

    input logic ewb_full,

    /* Datapath to Control */
    input logic hit,
    input logic way_0_hit,
    input logic way_1_hit,
    input logic way_2_hit,
    input logic way_3_hit,

    input logic v_array_0_dataout,
    input logic v_array_1_dataout,
    input logic v_array_2_dataout,
    input logic v_array_3_dataout,

    input logic d_array_0_dataout,
    input logic d_array_1_dataout,
    input logic d_array_2_dataout,
    input logic d_array_3_dataout,
    
    input logic [2:0] LRU_array_dataout,

    /* Control to Datapath */
    output logic v_array_0_load,
    output logic v_array_0_datain,
    output logic v_array_1_load,
    output logic v_array_1_datain,
    output logic v_array_2_load,
    output logic v_array_2_datain,
    output logic v_array_3_load,
    output logic v_array_3_datain,

    output logic d_array_0_load,
    output logic d_array_0_datain,
    output logic d_array_1_load,
    output logic d_array_1_datain,
    output logic d_array_2_load,
    output logic d_array_2_datain,
    output logic d_array_3_load,
    output logic d_array_3_datain,

    output logic tag_array_0_load,
    output logic tag_array_1_load,
    output logic tag_array_2_load,
    output logic tag_array_3_load,

    output logic LRU_array_load,
    output logic [2:0] LRU_array_datain,

    output dataarraymux_sel_t write_en_0_MUX_sel,
    output dataarraymux_sel_t write_en_1_MUX_sel,
    output dataarraymux_sel_t write_en_2_MUX_sel,
    output dataarraymux_sel_t write_en_3_MUX_sel,
    output dataarraymux_sel_t data_array_0_datain_MUX_sel,
    output dataarraymux_sel_t data_array_1_datain_MUX_sel,
    output dataarraymux_sel_t data_array_2_datain_MUX_sel,
    output dataarraymux_sel_t data_array_3_datain_MUX_sel,

    output logic [1:0] dataout_MUX_sel,

    output pmemaddressmux_sel_t pmem_address_MUX_sel

);

logic num_l2_miss_count;
logic num_l2_miss_overflow;
logic [perf_counter_width-1:0] num_l2_miss;

/* Count the total number of L2 cache misses. */
perf_counter #(.width(perf_counter_width)) l2miss (
    .clk(clk),
    .rst(rst),
    .count(num_l2_miss_count),
    .overflow(num_l2_miss_overflow),
    .out(num_l2_miss)
);


// enum int unsigned {
//     /* List of states */
//     DEFAULT, EWB_LOAD, WRITE_BACK, COUNTDOWN, HIT_DETECT, MEM_READ, HIT_DETECT2
// } state, next_state;

// logic V;
// logic counter;

// function void set_defaults();

//     /* CPU memory signals */
//     mem_resp = 1'b0;


//     /* Physical memory signals */
//     pmem_read = 1'b0;
//     pmem_write = 1'b0;

//     /* Control to Datapath */
//     v_array_0_load = 1'b0;
//     v_array_0_datain = 1'b0;
//     v_array_1_load = 1'b0;
//     v_array_1_datain = 1'b0;
//     v_array_2_load = 1'b0;
//     v_array_2_datain = 1'b0;
//     v_array_3_load = 1'b0;
//     v_array_3_datain = 1'b0;

//     d_array_0_load = 1'b0;
//     d_array_0_datain = 1'b0;
//     d_array_1_load = 1'b0;
//     d_array_1_datain = 1'b0;
//     d_array_2_load = 1'b0;
//     d_array_2_datain = 1'b0;
//     d_array_3_load = 1'b0;
//     d_array_3_datain = 1'b0;

//     tag_array_0_load = 1'b0;
//     tag_array_1_load = 1'b0;
//     tag_array_2_load = 1'b0;
//     tag_array_3_load = 1'b0;

//     LRU_array_load = 1'b0;
//     LRU_array_datain = 3'b000;

//     write_en_0_MUX_sel = no_write; 
//     write_en_1_MUX_sel = no_write;
//     write_en_2_MUX_sel = no_write; 
//     write_en_3_MUX_sel = no_write;
//     data_array_0_datain_MUX_sel = no_write;
//     data_array_1_datain_MUX_sel = no_write;
//     data_array_2_datain_MUX_sel = no_write;
//     data_array_3_datain_MUX_sel = no_write;

//     dataout_MUX_sel = 2'b00;

//     pmem_address_MUX_sel = cache_read_mem;
//     num_l2_miss_count = 1'b0;
    
//     V = 1'b0;
//     tag_check = 1'b0;
//     load_ewb = 1'b0;
//     wb_ewb = 1'b0;
//     counter = 1'b1;

// endfunction



// always_comb
// begin : state_actions

//     /* Default output assignments */
//     set_defaults();

//     /* Actions for each state */
//     case(state)
//         DEFAULT:;

//         EWB_LOAD: begin
//             load_ewb = 1'b1; //LOAD EWB with new write
//             V = 1'b1; //set valid
//             mem_resp = 1'b1; //respond that write is completed
//             counter = 1'b1; //reset counter
//         end

//         COUNTDOWN: begin
//             counter = (counter == '0)? '0: counter - 1;
//             tag_check = 1'b1; //CHECK Tag hit in case of read
//         end

//         WRITE_BACK: begin
//             pmem_write = 1'b1; //Write from Eviction buffer to memory
//             wb_ewb = 1'b1; //Dequeue entry from Eviction buffer
//         end

//         HIT_DETECT, HIT_DETECT2: begin
//             if (ewb_hit == 1'b1)
//             begin //If hit in EWB
//                 mem_resp = 1'b1;
//             end

//             else begin
//                 mem_resp = hit;
//                 if (hit)
//                 begin
//                     LRU_array_load = 1'b1;
//                     if(way_0_hit)
//                     begin
//                         LRU_array_datain = {1'b0, 1'b0, LRU_array_dataout[0]};
//                         dataout_MUX_sel = 2'b00;
//                     end

//                     else if (way_1_hit)
//                     begin
//                         LRU_array_datain = {1'b0, 1'b1, LRU_array_dataout[0]};
//                         dataout_MUX_sel = 2'b01;

//                     end 

//                     else if (way_2_hit)
//                     begin
//                         LRU_array_datain = {1'b1, LRU_array_dataout[1], 1'b0};
//                         dataout_MUX_sel = 2'b10;
//                     end


//                     else if (way_3_hit)
//                     begin
//                         LRU_array_datain = {1'b1, LRU_array_dataout[1], 1'b1};  
//                         dataout_MUX_sel = 2'b11;
//                     end
//                 end

//             end

//         end

//         MEM_READ: begin
//             pmem_read = 1'b1;
//             pmem_address_MUX_sel = cache_read_mem;
//             mem_resp = hit;
//             if (pmem_resp == 1'b1)
//             begin
//                 if(v_array_0_dataout == 1'b0)
//                 begin
//                     tag_array_0_load = 1'b1;
//                     v_array_0_load = 1'b1;
//                     v_array_0_datain = 1'b1;
//                     d_array_0_load = 1'b1;
//                     d_array_0_datain = 1'b0;
//                     write_en_0_MUX_sel = mem_write_cache;
//                     data_array_0_datain_MUX_sel = mem_write_cache;
//                 end
//                 else if(v_array_1_dataout == 1'b0)
//                 begin
//                     tag_array_1_load = 1'b1;
//                     v_array_1_load = 1'b1;
//                     v_array_1_datain = 1'b1;
//                     d_array_1_load = 1'b1;
//                     d_array_1_datain = 1'b0;
//                     write_en_1_MUX_sel = mem_write_cache;
//                     data_array_1_datain_MUX_sel = mem_write_cache;
//                 end
//                 else if(v_array_2_dataout == 1'b0)
//                 begin
//                     tag_array_2_load = 1'b1;
//                     v_array_2_load = 1'b1;
//                     v_array_2_datain = 1'b1;
//                     d_array_2_load = 1'b1;
//                     d_array_2_datain = 1'b0;
//                     write_en_2_MUX_sel = mem_write_cache;
//                     data_array_2_datain_MUX_sel = mem_write_cache;
//                 end
//                 else if(v_array_3_dataout == 1'b0)
//                 begin
//                     tag_array_3_load = 1'b1;
//                     v_array_3_load = 1'b1;
//                     v_array_3_datain = 1'b1;
//                     d_array_3_load = 1'b1;
//                     d_array_3_datain = 1'b0;
//                     write_en_3_MUX_sel = mem_write_cache;
//                     data_array_3_datain_MUX_sel = mem_write_cache;
//                 end
//                 else
//                 begin
//                     if(LRU_array_dataout[2] == 1'b0)
//                     begin
//                         if(LRU_array_dataout[0] == 1'b0)
//                         begin
//                             // Alloc way 3
//                             tag_array_3_load = 1'b1;
//                             v_array_3_load = 1'b1;
//                             v_array_3_datain = 1'b1;
//                             d_array_3_load = 1'b1;
//                             d_array_3_datain = 1'b0;
//                             write_en_3_MUX_sel = mem_write_cache;
//                             data_array_3_datain_MUX_sel = mem_write_cache;
//                         end
//                         else
//                         begin
//                             // Alloc way 2
//                             tag_array_2_load = 1'b1;
//                             v_array_2_load = 1'b1;
//                             v_array_2_datain = 1'b1;
//                             d_array_2_load = 1'b1;
//                             d_array_2_datain = 1'b0;
//                             write_en_2_MUX_sel = mem_write_cache;
//                             data_array_2_datain_MUX_sel = mem_write_cache;
//                         end
//                     end
//                     else
//                     begin
//                         if(LRU_array_dataout[1] == 1'b0)
//                         begin
//                             // Alloc way 1
//                             tag_array_1_load = 1'b1;
//                             v_array_1_load = 1'b1;
//                             v_array_1_datain = 1'b1;
//                             d_array_1_load = 1'b1;
//                             d_array_1_datain = 1'b0;
//                             write_en_1_MUX_sel = mem_write_cache;
//                             data_array_1_datain_MUX_sel = mem_write_cache;
//                         end
//                         else
//                         begin
//                             // Alloc way 0
//                             tag_array_0_load = 1'b1;
//                             v_array_0_load = 1'b1;
//                             v_array_0_datain = 1'b1;
//                             d_array_0_load = 1'b1;
//                             d_array_0_datain = 1'b0;
//                             write_en_0_MUX_sel = mem_write_cache;
//                             data_array_0_datain_MUX_sel = mem_write_cache;
//                         end  
//                     end
//                 end
//             end
//         end
//     endcase
// end

// always_comb
// begin : next_state_logic
//     /* Next state information and conditions (if any)
//      * for transitioning between states */

//     next_state = state;

//     case(state)
//         DEFAULT:
//         begin
//             if (mem_write == 1'b1)
//             next_state = EWB_LOAD;
//             else if (mem_read == 1'b1)
//             next_state = HIT_DETECT2;
//             else if (V == 1'b1)
//             next_state = COUNTDOWN;
//         end

//         EWB_LOAD:
//         begin
//             next_state = COUNTDOWN;
//         end 

//         COUNTDOWN: begin
//             if (mem_read)
//             next_state = HIT_DETECT;
//             else if (~(mem_read || mem_write || counter) || mem_write)
//             next_state = WRITE_BACK;
//         end

//         WRITE_BACK: begin
//             if (pmem_resp == 1'b1) begin
//                 if (mem_write == 1'b1)
//                 next_state = EWB_LOAD;
//                 else
//                 next_state = DEFAULT;
//             end
//         end

//         HIT_DETECT: begin
//             if (ewb_hit == 1'b1 || hit == 1'b1)
//             begin
//                 next_state = COUNTDOWN;
//             end

//             else next_state = MEM_READ;

//         end

//         MEM_READ: begin
//             if (hit == 1'b1)
//             next_state = DEFAULT;
//         end

//         HIT_DETECT2: begin
//             if (ewb_hit == 1'b1 || hit == 1'b1)
//             begin
//                 next_state = DEFAULT;
//             end
//             else next_state = MEM_READ;
//         end


    
//     endcase
        
// end

// always_ff @(posedge clk)
// begin: next_state_assignment
//     /* Assignment of next state on clock edge */
//     if (rst)
//     begin
//         state <= DEFAULT;
//     end
//     else
//     begin
//         state <= next_state;
//     end
// end

// endmodule : l2_cache_control

logic [5:0] counter;

enum int unsigned {
    /* List of states */
    DEFAULT, READ_WRITE, NO_WB_1,
    WRITE_BACK, DEQUEUE

} state, next_state;

function void set_defaults();

    /* CPU memory signals */
    mem_resp = 1'b0;


    /* Physical memory signals */
    pmem_read = 1'b0;
    pmem_write = 1'b0;

    /* Control to Datapath */
    v_array_0_load = 1'b0;
    v_array_0_datain = 1'b0;
    v_array_1_load = 1'b0;
    v_array_1_datain = 1'b0;
    v_array_2_load = 1'b0;
    v_array_2_datain = 1'b0;
    v_array_3_load = 1'b0;
    v_array_3_datain = 1'b0;

    d_array_0_load = 1'b0;
    d_array_0_datain = 1'b0;
    d_array_1_load = 1'b0;
    d_array_1_datain = 1'b0;
    d_array_2_load = 1'b0;
    d_array_2_datain = 1'b0;
    d_array_3_load = 1'b0;
    d_array_3_datain = 1'b0;

    tag_array_0_load = 1'b0;
    tag_array_1_load = 1'b0;
    tag_array_2_load = 1'b0;
    tag_array_3_load = 1'b0;

    LRU_array_load = 1'b0;
    LRU_array_datain = 3'b000;

    write_en_0_MUX_sel = no_write; 
    write_en_1_MUX_sel = no_write;
    write_en_2_MUX_sel = no_write; 
    write_en_3_MUX_sel = no_write;
    data_array_0_datain_MUX_sel = no_write;
    data_array_1_datain_MUX_sel = no_write;
    data_array_2_datain_MUX_sel = no_write;
    data_array_3_datain_MUX_sel = no_write;

    dataout_MUX_sel = 2'b00;

    pmem_address_MUX_sel = cache_read_mem;
    num_l2_miss_count = 1'b0;

    tag_check = 1'b1;
    load_ewb = 1'b0;
    wb_ewb = 1'b0;


endfunction



always_comb
begin : state_actions

    /* Default output assignments */
    set_defaults();

    /* Actions for each state */
    case(state)
        DEFAULT: begin
            if (ewb_empty == 1'b0)
                counter -= 6'b1;
        end
        READ_WRITE:
        begin
            counter = '1; // RESET COUNTER
            if(hit)
            begin
                mem_resp = 1'b1;
                LRU_array_load = 1'b1;
                if(way_0_hit)
                    LRU_array_datain = {1'b0, 1'b0, LRU_array_dataout[0]};
                else if (way_1_hit)
                    LRU_array_datain = {1'b0, 1'b1, LRU_array_dataout[0]};
                else if (way_2_hit)
                    LRU_array_datain = {1'b1, LRU_array_dataout[1], 1'b0};
                else if (way_3_hit)
                    LRU_array_datain = {1'b1, LRU_array_dataout[1], 1'b1};  
            end
            else if (ewb_hit == 1'b1)
            mem_resp = 1'b1;

            else num_l2_miss_count = 1'b1;

            if(mem_read)
            begin
                if(way_0_hit == 1'b1 && way_1_hit == 1'b0 && way_2_hit == 1'b0 && way_3_hit == 1'b0)
                    dataout_MUX_sel = 2'b00;
                else if(way_0_hit == 1'b0 && way_1_hit == 1'b1 && way_2_hit == 1'b0 && way_3_hit == 1'b0)
                    dataout_MUX_sel = 2'b01;
                else if(way_0_hit == 1'b0 && way_1_hit == 1'b0 && way_2_hit == 1'b1 && way_3_hit == 1'b0)
                    dataout_MUX_sel = 2'b10;
                else if (way_0_hit == 1'b0 && way_1_hit == 1'b0 && way_2_hit == 1'b0 && way_3_hit == 1'b1)
                    dataout_MUX_sel = 2'b11;
            end
            else if(mem_write)
            begin
                if(hit && way_0_hit)
                begin
                    write_en_0_MUX_sel = cpu_write_cache;
                    data_array_0_datain_MUX_sel = cpu_write_cache;
                    d_array_0_load = 1'b1;
                    d_array_0_datain = 1'b1;
                end
                else if(hit && way_1_hit)
                begin
                    write_en_1_MUX_sel = cpu_write_cache;
                    data_array_1_datain_MUX_sel = cpu_write_cache;
                    d_array_1_load = 1'b1;
                    d_array_1_datain = 1'b1;
                end
                else if(hit && way_2_hit)
                begin
                    write_en_2_MUX_sel = cpu_write_cache;
                    data_array_2_datain_MUX_sel = cpu_write_cache;
                    d_array_2_load = 1'b1;
                    d_array_2_datain = 1'b1;
                end
                else if(hit && way_3_hit)
                begin
                    write_en_3_MUX_sel = cpu_write_cache;
                    data_array_3_datain_MUX_sel = cpu_write_cache;
                    d_array_3_load = 1'b1;
                    d_array_3_datain = 1'b1;
                end
            end
        end
        NO_WB_1:
        begin
            pmem_read = 1'b1;
            pmem_address_MUX_sel = cache_read_mem;

            if (pmem_resp == 1'b1) 
            begin
                if(v_array_0_dataout == 1'b0)
                begin
                    tag_array_0_load = 1'b1;
                    v_array_0_load = 1'b1;
                    v_array_0_datain = 1'b1;
                    d_array_0_load = 1'b1;
                    d_array_0_datain = 1'b0;
                    write_en_0_MUX_sel = mem_write_cache;
                    data_array_0_datain_MUX_sel = mem_write_cache;
                end
                else if(v_array_1_dataout == 1'b0)
                begin
                    tag_array_1_load = 1'b1;
                    v_array_1_load = 1'b1;
                    v_array_1_datain = 1'b1;
                    d_array_1_load = 1'b1;
                    d_array_1_datain = 1'b0;
                    write_en_1_MUX_sel = mem_write_cache;
                    data_array_1_datain_MUX_sel = mem_write_cache;
                end
                else if(v_array_2_dataout == 1'b0)
                begin
                    tag_array_2_load = 1'b1;
                    v_array_2_load = 1'b1;
                    v_array_2_datain = 1'b1;
                    d_array_2_load = 1'b1;
                    d_array_2_datain = 1'b0;
                    write_en_2_MUX_sel = mem_write_cache;
                    data_array_2_datain_MUX_sel = mem_write_cache;
                end
                else if(v_array_3_dataout == 1'b0)
                begin
                    tag_array_3_load = 1'b1;
                    v_array_3_load = 1'b1;
                    v_array_3_datain = 1'b1;
                    d_array_3_load = 1'b1;
                    d_array_3_datain = 1'b0;
                    write_en_3_MUX_sel = mem_write_cache;
                    data_array_3_datain_MUX_sel = mem_write_cache;
                end
                else
                begin
                    if(LRU_array_dataout[2] == 1'b0)
                    begin
                        if(LRU_array_dataout[0] == 1'b0)
                        begin
                            // Alloc way 3
                            tag_array_3_load = 1'b1;
                            v_array_3_load = 1'b1;
                            v_array_3_datain = 1'b1;
                            d_array_3_load = 1'b1;
                            d_array_3_datain = 1'b0;
                            write_en_3_MUX_sel = mem_write_cache;
                            data_array_3_datain_MUX_sel = mem_write_cache;
                        end
                        else
                        begin
                            // Alloc way 2
                            tag_array_2_load = 1'b1;
                            v_array_2_load = 1'b1;
                            v_array_2_datain = 1'b1;
                            d_array_2_load = 1'b1;
                            d_array_2_datain = 1'b0;
                            write_en_2_MUX_sel = mem_write_cache;
                            data_array_2_datain_MUX_sel = mem_write_cache;
                        end
                    end
                    else
                    begin
                        if(LRU_array_dataout[1] == 1'b0)
                        begin
                            // Alloc way 1
                            tag_array_1_load = 1'b1;
                            v_array_1_load = 1'b1;
                            v_array_1_datain = 1'b1;
                            d_array_1_load = 1'b1;
                            d_array_1_datain = 1'b0;
                            write_en_1_MUX_sel = mem_write_cache;
                            data_array_1_datain_MUX_sel = mem_write_cache;
                        end
                        else
                        begin
                            // Alloc way 0
                            tag_array_0_load = 1'b1;
                            v_array_0_load = 1'b1;
                            v_array_0_datain = 1'b1;
                            d_array_0_load = 1'b1;
                            d_array_0_datain = 1'b0;
                            write_en_0_MUX_sel = mem_write_cache;
                            data_array_0_datain_MUX_sel = mem_write_cache;
                        end  
                    end
                end
                end
            end
            
            WRITE_BACK:
            begin
                if(LRU_array_dataout[2] == 1'b0)
                begin
                    if(LRU_array_dataout[0] == 1'b0)
                    begin
                        // Alloc way 3
                        load_ewb = 1'b1;
                        dataout_MUX_sel = 2'b11;
                        pmem_address_MUX_sel = cache_write_mem;
                        v_array_3_load = 1'b1;
                        v_array_3_datain = 1'b0;
                    end
                    else
                    begin
                        // Alloc way 2
                        load_ewb = 1'b1;
                        dataout_MUX_sel = 2'b10;
                        pmem_address_MUX_sel = cache_write_mem;
                        v_array_2_load = 1'b1;
                        v_array_2_datain = 1'b0;
                    end
                end
                else
                begin
                    if(LRU_array_dataout[1] == 1'b0)
                    begin
                        // Alloc way 1
                        load_ewb = 1'b1;
                        dataout_MUX_sel = 2'b01;
                        pmem_address_MUX_sel = cache_write_mem;
                        v_array_1_load = 1'b1;
                        v_array_1_datain = 1'b0;
                    end
                    else
                    begin
                        // Alloc way 0
                        load_ewb = 1'b1;
                        dataout_MUX_sel = 2'b00;
                        pmem_address_MUX_sel = cache_write_mem;
                        v_array_0_load = 1'b1;
                        v_array_0_datain = 1'b0;
                    end  
                end
        end

        DEQUEUE:
        begin
            counter = '1; // RESET COUNTER
            if (pmem_resp == 1'b0)
            pmem_write = 1'b1;
            else
            wb_ewb = 1'b1;
        end

    endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */

    next_state = state;

    case(state)
        DEFAULT:
        begin

            if (ewb_full == 1'b1)
                next_state = DEQUEUE;

            else if(mem_read == 1'b1 || mem_write == 1'b1)
                next_state = READ_WRITE;

            else if (ewb_empty == 1'b0 && counter == '0)
                next_state = DEQUEUE;
        end
        READ_WRITE:
        begin
            if(hit == 1'b1 || ewb_hit == 1'b1)
            begin
                next_state = DEFAULT;
            end

            else if(v_array_0_dataout == 1'b0 || v_array_1_dataout == 1'b0 || v_array_2_dataout == 1'b0 || v_array_3_dataout == 1'b0)
            begin
                next_state = NO_WB_1;
            end
            else
            begin
                if(LRU_array_dataout[2] == 1'b0)
                begin
                    if(LRU_array_dataout[0] == 1'b0)
                    begin
                        // Alloc way 3
                        if(d_array_3_dataout == 1'b0)
                            next_state = NO_WB_1;
                        else
                            next_state = WRITE_BACK;
                    end
                    else
                    begin
                        // Alloc way 2
                        if(d_array_2_dataout == 1'b0)
                            next_state = NO_WB_1;
                        else
                            next_state = WRITE_BACK;
                    end
                end
                else
                begin
                    if(LRU_array_dataout[1] == 1'b0)
                    begin
                        // Alloc way 1
                        if(d_array_1_dataout == 1'b0)
                            next_state = NO_WB_1;
                        else
                            next_state = WRITE_BACK;
                    end
                    else
                    begin
                        // Alloc way 0
                        if(d_array_0_dataout == 1'b0)
                            next_state = NO_WB_1;
                        else
                            next_state = WRITE_BACK;
                    end  
                end

            end
        end
        NO_WB_1:
        begin
            if(pmem_resp == 1'b1)
            begin
                next_state = READ_WRITE;
            end
        end
        WRITE_BACK:
        begin
            next_state = NO_WB_1;
        end

        DEQUEUE: begin
            if (pmem_resp == 1'b1)
            begin
                next_state = DEFAULT;
                if (mem_read == 1'b1 || mem_write == 1'b1)
                next_state = READ_WRITE;
            end
        end

    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if (rst)
    begin
        state <= DEFAULT;
    end
    else
    begin
        state <= next_state;
    end
end

endmodule : l2_cache_control


