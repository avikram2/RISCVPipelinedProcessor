`define BAD_MUX_SEL $display("%0d: %s:  %0t: Illegal MUX Select", `__LINE__, `__FILE__, $time)

module immediate_gen
import rv32i_types::*;
(
    input logic [31:0] ir,
    
    output rv32i_word imm

);

rv32i_word i_imm;
rv32i_word s_imm;
rv32i_word b_imm;
rv32i_word u_imm;
rv32i_word j_imm;
rv32i_opcode opcode;

assign i_imm = {{21{ir[31]}}, ir[30:20]};
assign s_imm = {{21{ir[31]}}, ir[30:25], ir[11:7]};
assign b_imm = {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0};
assign u_imm = {ir[31:12], 12'h000};
assign j_imm = {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0};

assign opcode = rv32i_opcode'(ir[6:0]);

always_comb begin

    imm = '0; // set to 0 for debugging

    unique case(opcode)

        op_lui, op_auipc: 
        begin
            imm = u_imm;
        end

        op_jal: 
        begin
            imm = j_imm;
        end

        op_jalr: 
        begin
            imm = i_imm;
        end

        op_br: 
        begin
            imm = b_imm;
        end 

        op_load: 
        begin
            imm = i_imm;
        end

        op_store:
        begin
            imm = s_imm;
        end

        op_imm: 
        begin
            imm = i_imm;
        end

        default:
        begin
            
            // $display("%0b", opcode);
        end 
    endcase

end


endmodule : immediate_gen