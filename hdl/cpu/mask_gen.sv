`define BAD_MUX_SEL $display("%0d: %s:  %0t: Illegal MUX Select", `__LINE__, `__FILE__, $time)

module mask_gen
import rv32i_types::*;
(
    input rv32i_word alu_out,
    input logic [2:0] funct3,
    
    output rv32i_mem_wmask write_read_mask

);

always_comb begin

    write_read_mask = '0; 

    unique case (funct3)

        3'b000, 3'b100: // SB, LB, LBU
        begin
            unique case(alu_out[1:0])
                2'b00: write_read_mask = 4'b0001;
                2'b01: write_read_mask = 4'b0010;
                2'b10: write_read_mask = 4'b0100;
                2'b11: write_read_mask = 4'b1000;
                default: ;
            endcase
        end
        3'b001, 3'b101: // SH, LHU, LH
        begin
            unique case(alu_out[1:0])
                2'b00: write_read_mask = 4'b0011;
                2'b10: write_read_mask = 4'b1100;
                default: ;
            endcase
        end
        3'b010: // SW, LW
        begin
            write_read_mask = 4'b1111;
        end
        default: ;
    endcase

end

endmodule: mask_gen