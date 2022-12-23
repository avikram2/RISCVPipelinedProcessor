module perf_counter #(parameter width = 32)
(
    input logic clk,
    input logic rst,
    input logic count,
    output logic overflow,
    output logic [width-1:0] out
);

logic [width-1:0] data;
logic _overflow;

always_ff @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        data <= '0;
        _overflow <= 1'b0;
    end
    else
    begin
        if(count)
        begin
            data <= data + 1'b1;
        end

        if(data == '1)
        begin
            _overflow <= 1'b1;
        end
    end

end

always_comb
begin
    overflow = _overflow;
    out = data;
end

endmodule : perf_counter
