module pht 
import rv32i_types::*; 
#(
    parameter s_index = 4
)
(
    input logic clk,
    input logic rst,
    input logic increment,
    input logic decrement,
    input logic [s_index-1:0] rindex,
    input logic [s_index-1:0] windex,
    output logic out
);

/* Increment when the branch is taken. Decrement otherwise. */
/* If the counter is 10 or 11, the branch predictor determines taken. */
/* Initialized to Weakly Taken. */

localparam num_sets = 2**s_index;

logic [2:0] data [num_sets-1:0];
logic [2:0] in;

always_comb
begin
    in = data[windex];
    if(increment)
    begin
        if(data[windex] != 3'b111)
            in = data[windex] + 3'b001;
    end
    else if(decrement)
    begin
        if(data[windex] != 3'b000)
            in = data[windex] - 3'b001;
    end
end

always_ff @(posedge clk)
begin
    if (rst)
    begin
        for (int i = 0; i < num_sets; ++i)
            data[i] <= 3'b100;
    end
    else
    begin
        data[windex] <= in;
    end
end

always_comb
begin
    if((rindex == windex) && (decrement || increment))
        // transparent
        out = in[2];
    else
        out = data[rindex][2];

end

endmodule : pht
