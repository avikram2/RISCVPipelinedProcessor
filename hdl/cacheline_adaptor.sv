module cacheline_adaptor
(
    input clk,
    input reset_n,

    // Port to LLC (Lowest Level Cache)
    input logic [255:0] line_i,
    output logic [255:0] line_o,    // a cache line is 32 BYTES
    input logic [31:0] address_i,
    input read_i,
    input write_i,
    output logic resp_o,

    // Port to memory
    input logic [63:0] burst_i,
    output logic [63:0] burst_o,     // each DRAM burst is 8 BYTES
    output logic [31:0] address_o,   // always assigned to address_i
    output logic read_o,
    output logic write_o,
    input resp_i
);

logic [255:0] buffer;
logic [2:0] read_pos;


assign address_o = address_i;

// FSM Ref: https://www.intel.com/content/www/us/en/docs/programmable/683082/22-1/systemverilog-state-machine-coding-example.html

enum int unsigned { INIT = 0, READ_WAIT_DRAM = 1, READ_BURST_0 = 2, 
                    READ_BURST_1 = 3, READ_BURST_2 = 4, READ_DONE = 6,
                    WRITE_WAIT = 7, WRITE_BURST_0 = 8, WRITE_BURST_1 = 9,
                    WRITE_BURST_2 = 10, WRITE_BURST_3 = 11, WRITE_DONE = 12} state, next_state;

always_comb begin

    next_state = state;
    case(state)
		INIT:
        begin
            if(read_i == 1'b1 && write_i == 1'b0)
                next_state = READ_WAIT_DRAM;
            if(read_i == 1'b0 && write_i == 1'b1)
                next_state = WRITE_WAIT;
        end
		READ_WAIT_DRAM:
        begin
            if(resp_i == 1'b1)
                next_state = READ_BURST_0;
        end
		READ_BURST_0: next_state = READ_BURST_1;
		READ_BURST_1: next_state = READ_BURST_2;
		READ_BURST_2: next_state = READ_DONE;
        READ_DONE: next_state = INIT;
        WRITE_WAIT:
        begin
            if(resp_i == 1'b1)
                next_state = WRITE_BURST_0;
        end
        WRITE_BURST_0: next_state = WRITE_BURST_1;
        WRITE_BURST_1: next_state = WRITE_BURST_2;
        WRITE_BURST_2: next_state = WRITE_DONE;
        WRITE_DONE: next_state = INIT;
	endcase
end

always_comb begin
   
    case(state)
		INIT:
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = '0;
            read_o = 1'b0;
            write_o = 1'b0;
            read_pos = 3'b111;
        end 
		READ_WAIT_DRAM: 
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = '0;
            read_o = 1'b1;
            write_o = 1'b0;
            read_pos = 3'b111;
        end
		READ_BURST_0: 
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = '0;
            read_o = 1'b1;
            write_o = 1'b0;
            read_pos = 3'b000;
        end
		READ_BURST_1:
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = '0;
            read_o = 1'b1;
            write_o = 1'b0;
            read_pos = 3'b001;
        end
		READ_BURST_2:
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = '0;
            read_o = 1'b1;
            write_o = 1'b0;
            read_pos = 3'b010;
        end
        READ_DONE:
        begin
            line_o = buffer;
            resp_o = 1'b1;
            burst_o = '0;
            read_o = 1'b0;
            write_o = 1'b0;
            read_pos = 3'b111;
        end
        WRITE_WAIT:
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = buffer[63:0];
            read_o = 1'b0;
            write_o = 1'b1;
            read_pos = 3'b111;
        end 
        WRITE_BURST_0:
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = buffer[127:64];
            read_o = 1'b0;
            write_o = 1'b1;
            read_pos = 3'b111;
        end 
        WRITE_BURST_1:
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = buffer[191:128];
            read_o = 1'b0;
            write_o = 1'b1;
            read_pos = 3'b111;
        end 
        WRITE_BURST_2:
        begin
            line_o = '0;
            resp_o = 1'b0;
            burst_o = buffer[255:192];
            read_o = 1'b0;
            write_o = 1'b1;
            read_pos = 3'b111;
        end
        WRITE_DONE:
        begin
            line_o = '0;
            resp_o = 1'b1;
            burst_o = '0;
            read_o = 1'b0;
            write_o = 1'b0;
            read_pos = 3'b111;
        end 
	endcase
end




always_ff @(posedge clk) begin
    if (~reset_n)
    begin
        // reset
        buffer <= '0;
        state <= INIT;
    end
    else
    begin
        state <= next_state;
        if(state == READ_WAIT_DRAM && resp_i == 1'b1)
            buffer[63:0] <= burst_i;
        else if(read_pos == 3'b000)
            buffer[127:64] <= burst_i;
        else if(read_pos == 3'b001)
            buffer[191:128] <= burst_i;
        else if(read_pos == 3'b010)
            buffer[255:192] <= burst_i;
        else if(state == WRITE_WAIT)
            buffer <= line_i;
    end
end


endmodule : cacheline_adaptor