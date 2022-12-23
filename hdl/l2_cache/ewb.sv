module ewb
import rv32i_types::*;
#(
    width = 256,
    index = 3, 
    tag = 24, 
    cap = 8
)
(
    input logic clk,
    input logic rst, 

    // valid-ready input protocol
    input logic [width-1:0] data_i,
    input logic [31:0] addr_i,
    input logic valid_i,
    output logic full_o,

    input logic tag_check,
    input logic [26:0] tag_i,
    output logic hit_o,
    output logic [width-1:0] read_o,

    // valid-yumi output protocol
    output logic empty_o,
    output logic [width-1:0] data_o,
    output logic [31:0] addr_o,
    input logic yumi_i,

    input logic write_ewb_i,
    input logic [width-1:0] replace_i
);

/******************************** Declarations *******************************/
// Need memory to hold queued data
logic [width-1:0] queue_data [cap];
logic [31:0] queue_addr [cap];
logic queue_valid [cap];

// Pointers which point to the read and write ends of the queue
logic [index-1:0] read_ptr, write_ptr, read_ptr_next, write_ptr_next;
logic [index:0] queue_counter;

assign write_ptr_next = ({29'b0, write_ptr} == cap-1)? '0: write_ptr + 3'b1;
assign read_ptr_next = ({29'b0, read_ptr} == cap-1)? '0: read_ptr + 3'b1;

// Helper logic
logic enqueue, dequeue;

assign full_o = ({28'b0, queue_counter} == cap)? 1'b1: 1'b0;
assign empty_o = (queue_counter == '0)? 1'b1: 1'b0;
assign enqueue = (valid_i == 1'b1) && (full_o == 1'b0);
assign dequeue = (yumi_i == 1'b1) && (empty_o == 1'b0);

/*************************** Non-Blocking Assignments ************************/
always_ff @(posedge clk) begin
    if (rst) begin
        read_ptr  <= '0;
        write_ptr <= '0;
        queue_counter <= '0;
        for (int i = 0; i < cap; ++i)
        begin
            queue_data[i] <= '0;
            queue_addr[i] <= '0;
            queue_valid[i] <= '0;
        end
    end
    else begin
        case ({enqueue, dequeue})
            2'b01: begin : dequeue_case
                queue_valid[read_ptr] <= 1'b0;
                read_ptr <= read_ptr_next;
                queue_counter <= queue_counter - 4'b1;
            end
            2'b10: begin : enqueue_case
                queue_data[write_ptr] <= data_i;
                queue_addr[write_ptr] <= addr_i;
                queue_valid[write_ptr] <= 1'b1;
                write_ptr <= write_ptr_next;
                queue_counter <= queue_counter + 4'b1;
            end
            default:;
        endcase

//queue_data[(i+read_ptr)%cap] <= replace_i;
        if (queue_addr[0][31:5] == tag_i)
        begin
                if (write_ewb_i == 1'b1)
                begin
                    queue_data[0] <= replace_i;
                    queue_valid[0] <= 1'b1;
                end
        end

        else if (queue_addr[1][31:5] == tag_i) begin
            if (write_ewb_i == 1'b1)
            begin
                queue_data[1] <= replace_i;
                queue_valid[1] <= 1'b1;
            end

        end

        else if (queue_addr[2][31:5] == tag_i) begin
            if (write_ewb_i == 1'b1)
            begin
                queue_data[2] <= replace_i;
                queue_valid[2] <= 1'b1;
            end

        end


        else if (queue_addr[3][31:5] == tag_i) begin
            if (write_ewb_i == 1'b1)
            begin
                queue_data[3] <= replace_i;
                queue_valid[3] <= 1'b1;
            end

        end

        else if (queue_addr[4][31:5] == tag_i) begin
            if (write_ewb_i == 1'b1)
            begin
                queue_data[4] <= replace_i;
                queue_valid[4] <= 1'b1;
            end
        end

        else if (queue_addr[5][31:5] == tag_i) begin
            if (write_ewb_i == 1'b1)
            begin
                queue_data[5] <= replace_i;
                queue_valid[5] <= 1'b1;
            end

        end

        else if (queue_addr[6][31:5] == tag_i) begin
            if (write_ewb_i == 1'b1)
            begin
                queue_data[6] <= replace_i;
                queue_valid[6] <= 1'b1;
            end
        end
        
        else if (queue_addr[7][31:5] == tag_i) begin
            if (write_ewb_i == 1'b1)
            begin
                queue_data[7] <= replace_i;
                queue_valid[7] <= 1'b1;
            end

        end


    end

    end

always_comb begin
    hit_o = 1'b0;
    read_o = '0;
        if (queue_addr[0][31:5] == tag_i && queue_valid[0] == 1'b1)
        begin
                read_o = queue_data[0];
                hit_o = 1'b1;
                
        end

        else if (queue_addr[1][31:5] == tag_i && queue_valid[1] == 1'b1) begin
            read_o = queue_data[1];
            hit_o = 1'b1;

        end

        else if (queue_addr[2][31:5] == tag_i && queue_valid[2] == 1'b1) begin
            read_o = queue_data[2];
            hit_o = 1'b1;

        end


        else if (queue_addr[3][31:5] == tag_i && queue_valid[3] == 1'b1) begin
            read_o = queue_data[3];
            hit_o = 1'b1;

        end

        else if (queue_addr[4][31:5] == tag_i && queue_valid[4] == 1'b1) begin
            read_o = queue_data[4];
            hit_o = 1'b1;
        end

        else if (queue_addr[5][31:5] == tag_i && queue_valid[5] == 1'b1) begin
            read_o = queue_data[5];
            hit_o = 1'b1;

        end

        else if (queue_addr[6][31:5] == tag_i && queue_valid[6] == 1'b1) begin
            read_o = queue_data[6];
            hit_o = 1'b1;

        end
        
        else if (queue_addr[7][31:5] == tag_i && queue_valid[7] == 1'b1) begin
            read_o = queue_data[7];
            hit_o = 1'b1;

        end
end

assign data_o = queue_data[read_ptr];
assign addr_o = queue_addr[read_ptr];

endmodule : ewb
