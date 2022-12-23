module forward_control_unit
import rv32i_types::*; 
(
    /* Inputs Required for Forwarding Detection */
    input rv32i_control_word id_ex_in_ctrl,
    input rv32i_control_word id_ex_out_ctrl,
    input rv32i_control_word ex_mem_out_ctrl,
    input rv32i_control_word mem_wb_out_ctrl,
    
    /* Forwarding MUX Selection Signals */
    output idforwardamux::idforwardamux_sel_t id_forward_A_MUX_sel,
    output idforwardbmux::idforwardbmux_sel_t id_forward_B_MUX_sel,
    output exforwardamux::exforwardamux_sel_t ex_forward_A_MUX_sel,
    output exforwardbmux::exforwardbmux_sel_t ex_forward_B_MUX_sel,
    output wbmemforwardmux::wbmemforwardmux_sel_t wb_mem_forward_MUX_sel 
);



function void set_defaults_mem();

    wb_mem_forward_MUX_sel = wbmemforwardmux::no_forward;

endfunction

function void set_defaults_ex();

    ex_forward_A_MUX_sel = exforwardamux::no_forward;
    ex_forward_B_MUX_sel = exforwardbmux::no_forward;

endfunction

function void set_defaults_id();

    id_forward_A_MUX_sel = idforwardamux::no_forward;
    id_forward_B_MUX_sel = idforwardbmux::no_forward;
    
endfunction



always_comb begin: MEM_EX_AND_WB_EX


    set_defaults_ex();
    /* MEM-EX Forward Path */
    if(ex_mem_out_ctrl.load_regfile && (ex_mem_out_ctrl.rd_id == id_ex_out_ctrl.rs1_id) && ex_mem_out_ctrl.rd_id != 0)
    begin
        if(ex_mem_out_ctrl.opcode != op_load) 
        begin
            if(ex_mem_out_ctrl.opcode == op_lui)
                ex_forward_A_MUX_sel = exforwardamux::mem_imm;
            else if (ex_mem_out_ctrl.regfile_MUX_sel == regfilemux::br_en)
                ex_forward_A_MUX_sel = exforwardamux::mem_br_en;
            else
                ex_forward_A_MUX_sel = exforwardamux::mem_alu_out;
        end
    end

    if(ex_mem_out_ctrl.load_regfile && (ex_mem_out_ctrl.rd_id == id_ex_out_ctrl.rs2_id) && ex_mem_out_ctrl.rd_id != 0)
    begin
        if(ex_mem_out_ctrl.opcode != op_load)
        begin
            if (ex_mem_out_ctrl.opcode == op_lui)
                ex_forward_B_MUX_sel = exforwardbmux::mem_imm;
            else if (ex_mem_out_ctrl.regfile_MUX_sel == regfilemux::br_en)
                ex_forward_B_MUX_sel = exforwardbmux::mem_br_en;
            else
                ex_forward_B_MUX_sel = exforwardbmux::mem_alu_out;
        end
    end

    /* WB-EX Forward Path */
    if (mem_wb_out_ctrl.load_regfile && (mem_wb_out_ctrl.rd_id == id_ex_out_ctrl.rs1_id) && mem_wb_out_ctrl.rd_id != 0)
    begin 
        if (ex_forward_A_MUX_sel == exforwardamux::no_forward) begin //Double Data Hazards
            ex_forward_A_MUX_sel = exforwardamux::wb_regfile_MUX_out;
        end
    end 
    if (mem_wb_out_ctrl.load_regfile && (mem_wb_out_ctrl.rd_id == id_ex_out_ctrl.rs2_id) && mem_wb_out_ctrl.rd_id != 0)
    begin 
        if (ex_forward_B_MUX_sel == exforwardbmux::no_forward) begin //Double Data Hazards, unset
            ex_forward_B_MUX_sel = exforwardbmux::wb_regfile_MUX_out;
        end 
    end

end

always_comb begin : EX_ID_AND_MEM_ID

    set_defaults_id();

    if(id_ex_in_ctrl.opcode == op_br || id_ex_in_ctrl.opcode == op_jalr || 
      (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu) ||
      (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt)  || 
      (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu) || 
      (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt))
    begin
        /* EX-ID Forwarding Path */

        if (id_ex_out_ctrl.load_regfile && (id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id) && id_ex_out_ctrl.rd_id != 0)
        begin

            if (id_ex_out_ctrl.opcode == op_lui)
                id_forward_A_MUX_sel = idforwardamux::ex_imm;

            else if (id_ex_out_ctrl.regfile_MUX_sel == regfilemux::br_en) //anything which loads br_en into reg file    
                id_forward_A_MUX_sel = idforwardamux::ex_br_en;
        end

        if (id_ex_out_ctrl.load_regfile && (id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs2_id) && id_ex_out_ctrl.rd_id != 0)
        begin

            if (id_ex_out_ctrl.opcode == op_lui)
                id_forward_B_MUX_sel = idforwardbmux::ex_imm;

            else if (id_ex_out_ctrl.regfile_MUX_sel == regfilemux::br_en) //anything which loads br_en into reg file    
                id_forward_B_MUX_sel = idforwardbmux::ex_br_en;
        end

        /* MEM-ID Forwarding Path */

        if (ex_mem_out_ctrl.load_regfile && (ex_mem_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id) && ex_mem_out_ctrl.rd_id != 0)
        begin
            if (id_forward_A_MUX_sel == idforwardamux::no_forward)
            begin
                if (ex_mem_out_ctrl.opcode == op_jal || ex_mem_out_ctrl.opcode == op_jalr)
                    id_forward_A_MUX_sel = idforwardamux::mem_pc_plus4;
                else if (ex_mem_out_ctrl.opcode == op_lui)
                    id_forward_A_MUX_sel = idforwardamux::mem_imm;
                else if (ex_mem_out_ctrl.opcode != op_load)
                    id_forward_A_MUX_sel = idforwardamux::mem_alu_out;
            end

        end

        if (ex_mem_out_ctrl.load_regfile && (ex_mem_out_ctrl.rd_id == id_ex_in_ctrl.rs2_id) && ex_mem_out_ctrl.rd_id != 0)
        begin
            if (id_forward_B_MUX_sel == idforwardbmux::no_forward)
            begin
                if (ex_mem_out_ctrl.opcode == op_jal || ex_mem_out_ctrl.opcode == op_jalr)
                    id_forward_B_MUX_sel = idforwardbmux::mem_pc_plus4;
                else if (ex_mem_out_ctrl.opcode == op_lui)
                    id_forward_B_MUX_sel = idforwardbmux::mem_imm;
                else if (ex_mem_out_ctrl.opcode != op_load)
                    id_forward_B_MUX_sel = idforwardbmux::mem_alu_out;
            end

        end
        
    end

end


always_comb begin : WB_MEM

    set_defaults_mem();
    
    if (mem_wb_out_ctrl.opcode == op_load)
    begin
        if (ex_mem_out_ctrl.opcode == op_store) // needed!
        begin
            if (mem_wb_out_ctrl.load_regfile && (mem_wb_out_ctrl.rd_id == ex_mem_out_ctrl.rs2_id) && mem_wb_out_ctrl.rd_id != 0)
                wb_mem_forward_MUX_sel = wbmemforwardmux::regfile_MUX_out;
        end
        
    end

end


endmodule : forward_control_unit