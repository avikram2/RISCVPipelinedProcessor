module pc_register #(parameter width = 32)
(
    input clk,
    input rst,
    input load,
    input [width-1:0] in,
    output logic [width-1:0] out
);

/*
* PC needs to start at 0x60
 */
logic [width-1:0] data;

always_ff @(posedge clk)
begin
    if (rst)
    begin
        data <= 32'h00000060;
    end
    else if (load)
    begin
        data <= in;
    end
    else
    begin
        data <= data;
    end
end

always_comb
begin
    out = data;
end

endmodule : pc_register
