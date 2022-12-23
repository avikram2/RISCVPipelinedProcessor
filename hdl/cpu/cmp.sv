module cmp
import rv32i_types::*;
(
    input branch_funct3_t cmpop,
    input logic [31:0] a, b,
    output logic f
);


always_comb
begin
    f = '0;
    unique case(cmpop)
        beq:   f = (a == b);
        bne:   f = (a != b);
        blt:   f = $signed(a) < $signed(b);
        bge:   f = $signed(a) >= $signed(b);
        bltu:  f = (a < b);
        bgeu:  f = (a >= b);
        default:; //$display("CMP DEFAULT");
    endcase
    
end
endmodule : cmp

