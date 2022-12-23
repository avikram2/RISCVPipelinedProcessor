
module alu
import rv32i_types::*;
(
    input alu_ops aluop,
    input [31:0] a, b,
    output logic [31:0] f
);

always_comb
begin
    unique case (aluop)
        alu_add:  f = a + b;
        alu_sll:  f = a << b[4:0];
        alu_sra:  f = $signed(a) >>> b[4:0];
        alu_sub:  f = a - b;
        alu_xor:  f = a ^ b;
        alu_srl:  f = a >> b[4:0];
        alu_or:   f = a | b;
        alu_and:  f = a & b;
    endcase
end

endmodule : alu
