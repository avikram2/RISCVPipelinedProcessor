module p_d_cache_reg 
import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic load,
    input d_cache_pipeline_reg in,
    output d_cache_pipeline_reg out
);

d_cache_pipeline_reg data;

always_ff @ (posedge clk) begin
    if (rst) begin
        data <= '0;
    end

    else if (load) begin
        data <= in;
    end
end

always_comb begin

    out = data;

end

endmodule: p_d_cache_reg