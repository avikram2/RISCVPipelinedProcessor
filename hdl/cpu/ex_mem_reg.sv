module ex_mem_reg 
import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic flush,
    input logic load,
    input ex_mem_pipeline_reg in,
    output ex_mem_pipeline_reg out
);

ex_mem_pipeline_reg data;

always_ff @ (posedge clk) begin
    if (rst) begin
        data <= '0;
    end

    else if (load) begin
        if(flush)
            data <= '0;
        else
            data <= in;
    end
end

always_comb begin

    out = data;

end

endmodule: ex_mem_reg