module ghr 
import rv32i_types::*; 
#(
    parameter depth = 4
)
(
    input logic clk,
    input logic rst,
    input logic load, 
    input logic in,
    output logic [depth-1:0] out
);

/* LSB is the most recent history. */
/* 1 is taken. 0 is not taken. */
/* Initialize to all taken. */

logic [depth-1:0] data;
logic [depth-1:0] _in;

always_comb
begin
    _in = data;
    if (load)
    begin
        _in = data << 1; // will place 0 in LSB
        _in[0] = in; // update LSB with correct value
    end
end

always_ff @(posedge clk)
begin
    if (rst)
    begin
        data <= '1;
    end
    else
    begin
        data <= _in;
    end
end

always_comb
begin
    if(load)
        // transparent
        out = _in;
    else
        out = data;

end

endmodule : ghr
