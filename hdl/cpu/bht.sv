module bht 
import rv32i_types::*; 
#(
    parameter s_index = 4,
    parameter depth = 4
)
(
    input logic clk,
    input logic rst,
    input logic load, 
    input logic [s_index-1:0] rindex,
    input logic [s_index-1:0] windex,
    input logic in,
    output logic [depth-1:0] out
);


localparam num_sets = 2**s_index;

logic [depth-1:0] data [num_sets-1:0];
logic [depth-1:0] _in;

always_comb
begin
    _in = data[windex];
    if (load)
    begin
        _in = data[windex] << 1; 
        _in[0] = in;
    end
end

always_ff @(posedge clk)
begin
    if (rst)
    begin
        for (int i = 0; i < num_sets; ++i)
            data[i] <= '1;
    end
    else
    begin
        data[windex] <= _in;
    end
end

always_comb
begin
    if((rindex == windex) && load)
        // transparent
        out = _in;
    else
        out = data[rindex];

end

endmodule : bht
