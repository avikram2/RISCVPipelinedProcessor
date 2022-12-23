module btb_array 
import rv32i_types::*;
#(
    parameter s_index = 3,
    parameter width = 32
)
(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [s_index-1:0] rindex,
    input logic [s_index-1:0] windex,
    input [width-1:0] in,
    output logic [width-1:0] out
);

localparam num_sets = 2**s_index;

logic [width-1:0] data [num_sets];

always_ff @(posedge clk)
begin
    if (rst)
    begin
        for (int i = 0; i < num_sets; ++i)
            data[i] <= '0;
    end
    else if (load)     
        data[windex] <= in;
end

always_comb
begin
    // if((rindex == windex) && load)
    //     // transparent
    //     out = in;
    // else
    out = data[rindex];
end

endmodule : btb_array
