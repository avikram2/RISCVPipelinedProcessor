module id_ex_reg 
import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic flush,
    input logic load,
    input id_ex_pipeline_reg in,
    output id_ex_pipeline_reg out
);

id_ex_pipeline_reg data;

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

endmodule: id_ex_reg