module stall_control_unit
import rv32i_types::*; 
(

    /* Cache Responses */
    input logic instr_mem_resp,
    input logic data_mem_resp,

    /* Control Words*/
    input logic if_btb_read_hit,
    input btb_entry if_btb_out,
    input logic if_br_pr,
    input logic id_btb_read_hit,
    input btb_entry id_btb_out,
    input logic id_local_pr,
    input logic id_global_pr,
    input logic id_br_pr,
    input logic br_jal_wrong_target,
    input logic jalr_wrong_target,
    input rv32i_control_word id_ex_in_ctrl,
    input logic id_ex_in_br_en,
    input rv32i_control_word id_ex_out_ctrl,
    input rv32i_control_word ex_mem_out_ctrl,
    input rv32i_control_word mem_wb_out_ctrl,
    

    /* Pipeline Register Load Signals*/
    output logic load_pc,
    output logic if_id_reg_load,
    output logic id_ex_reg_load,
    output logic ex_mem_reg_load,
    output logic mem_wb_reg_load,
    
    /* Pipeline Register Flush Signals*/
    output logic if_id_reg_flush,
    output logic id_ex_reg_flush,
    output logic ex_mem_reg_flush,
    output logic mem_wb_reg_flush,

    output pcmux::pcmux_sel_t pc_MUX_sel,
    output logic btb_load,
    output logic ghr_load,
    output logic bht_load,

    output logic increment_pht,
    output logic decrement_pht,
    output logic increment_tournament_pht,
    output logic decrement_tournament_pht,

    output logic global_stall, 
    output logic continue_i_cache

);

logic local_c;
logic global_c;

function void set_defaults();
    load_pc = 1'b1;

    if_id_reg_load = 1'b1;
    id_ex_reg_load = 1'b1;
    ex_mem_reg_load = 1'b1;
    mem_wb_reg_load = 1'b1;

    if_id_reg_flush = 1'b0;
    id_ex_reg_flush = 1'b0;
    ex_mem_reg_flush = 1'b0;
    mem_wb_reg_flush = 1'b0;

    pc_MUX_sel = pcmux::pc_plus4;

    btb_load = 1'b0;
    ghr_load = 1'b0;
    bht_load = 1'b0;

    increment_pht = 1'b0;
    decrement_pht = 1'b0;
    increment_tournament_pht = 1'b0;
    decrement_tournament_pht = 1'b0;

    local_c = 1'b0;
    global_c = 1'b0;

    global_stall = 1'b0;
    continue_i_cache = 1'b1;
endfunction


function void pipeline_load(logic load_if_id, logic load_id_ex, logic load_ex_mem, logic load_mem_wb);
    if_id_reg_load = load_if_id;
    id_ex_reg_load = load_id_ex;
    ex_mem_reg_load = load_ex_mem;
    mem_wb_reg_load = load_mem_wb;
endfunction


function void pipeline_flush(logic flush_if_id, logic flush_id_ex, logic flush_ex_mem, logic flush_mem_wb);
    if_id_reg_flush = flush_if_id;
    id_ex_reg_flush = flush_id_ex;
    ex_mem_reg_flush = flush_ex_mem;
    mem_wb_reg_flush = flush_mem_wb;
endfunction

always_comb
begin
    set_defaults();

    if(~instr_mem_resp)
    begin
        load_pc = 1'b0;
        pipeline_load(1'b0, 1'b0, 1'b0, 1'b0);
        global_stall = 1'b1;
        //continue_i_cache = 1'b1;
    end

    /* (Need CMP/ADDR Adder) after (Need ALU) */
    if((id_ex_out_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_out_ctrl.funct3) != slt)  ||
       (id_ex_out_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_out_ctrl.funct3) != sltu) ||
       (id_ex_out_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_out_ctrl.funct3) != slt)  ||
       (id_ex_out_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_out_ctrl.funct3) != sltu) ||
       id_ex_out_ctrl.opcode == op_auipc)
    begin
        if(id_ex_in_ctrl.opcode == op_br || 
          (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt)  ||
          (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu) ||
          (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt)  ||
          (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu))
        begin
            if((id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id || id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs2_id) && (id_ex_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b1, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b1, 1'b0, 1'b0);
                continue_i_cache = 1'b0;
            end
        end

        if(id_ex_in_ctrl.opcode == op_jalr)
        begin
            if((id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id) && (id_ex_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b1, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b1, 1'b0, 1'b0);
                continue_i_cache = 1'b0;
            end
        end

    end


    
    /* (Need CMP/ADDR Adder) after LD */
    if (id_ex_out_ctrl.opcode == op_load)
    begin
        if(id_ex_in_ctrl.opcode == op_br || 
          (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt)  ||
          (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu) ||
          (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt)  ||
          (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu))
        begin
            if((id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id || id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs2_id) && (id_ex_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b1, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b1, 1'b0, 1'b0);
                continue_i_cache = 1'b0;
            end
        end

        if(id_ex_in_ctrl.opcode == op_jalr)
        begin
            if((id_ex_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id) && (id_ex_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b1, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b1, 1'b0, 1'b0);
                continue_i_cache = 1'b0;
            end
        end
    end

    if(ex_mem_out_ctrl.opcode == op_load)
    begin
        if(id_ex_in_ctrl.opcode == op_br || 
          (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt)  ||
          (id_ex_in_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu) ||
          (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == slt)  ||
          (id_ex_in_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_in_ctrl.funct3) == sltu))
        begin
            if((ex_mem_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id || ex_mem_out_ctrl.rd_id == id_ex_in_ctrl.rs2_id) && (ex_mem_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b1, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b1, 1'b0, 1'b0);
                continue_i_cache = 1'b0;
            end
        end

        if(id_ex_in_ctrl.opcode == op_jalr)
        begin
            if((ex_mem_out_ctrl.rd_id == id_ex_in_ctrl.rs1_id) && (ex_mem_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b1, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b1, 1'b0, 1'b0);
                continue_i_cache = 1'b0;
            end
        end
    end

    /* (Need ALU) after LD */
    if(ex_mem_out_ctrl.opcode == op_load)
    begin
        if((id_ex_out_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_out_ctrl.funct3) != slt)  ||
           (id_ex_out_ctrl.opcode == op_reg && arith_funct3_t'(id_ex_out_ctrl.funct3) != sltu) ||
           (id_ex_out_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_out_ctrl.funct3) != slt)  ||
           (id_ex_out_ctrl.opcode == op_imm && arith_funct3_t'(id_ex_out_ctrl.funct3) != sltu))
        begin
            if((ex_mem_out_ctrl.rd_id == id_ex_out_ctrl.rs1_id || ex_mem_out_ctrl.rd_id == id_ex_out_ctrl.rs2_id) && (ex_mem_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b0, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b0, 1'b1, 1'b0);
                continue_i_cache = 1'b0;
            end
        end
        if (id_ex_out_ctrl.opcode == op_store)
        begin
            if ((ex_mem_out_ctrl.rd_id == id_ex_out_ctrl.rs1_id) && (ex_mem_out_ctrl.rd_id != 0))
            begin
                load_pc = 1'b0;
                pipeline_load(1'b0, 1'b0, 1'b1, 1'b1);
                pipeline_flush(1'b0, 1'b0, 1'b1, 1'b0);
                continue_i_cache = 1'b0;
            end
        end

    end

    /* Drive pc_MUX_sel by IF stage first. */
    if (if_btb_read_hit == 1'b1)
    begin 
        if (if_btb_out.br_jal_jalr == br)
        begin
            if (if_br_pr == 1'b1) 
                pc_MUX_sel = pcmux::btb_out;
            else
                pc_MUX_sel = pcmux::pc_plus4;
        end 
        else if (if_btb_out.br_jal_jalr == jal)
            pc_MUX_sel = pcmux::btb_out;
        else if (if_btb_out.br_jal_jalr == jalr)
            pc_MUX_sel = pcmux::btb_out;	
    end
    /* BTB Miss */
    else 
        pc_MUX_sel = pcmux::pc_plus4;


    /* Drive pc_MUX_sel by ID stage  (Overwrite pc_MUX_sel) */
    if(id_ex_in_ctrl.opcode == op_br)
    begin 
        if(id_btb_read_hit == 1'b1 && (id_br_pr == id_ex_in_br_en))
        begin
            if(br_jal_wrong_target)
            begin
                if_id_reg_flush = 1'b1;
                if(id_ex_in_br_en == 1'b1)
                    pc_MUX_sel = pcmux::adder_out;  
                if(id_ex_in_br_en == 1'b0)
                    pc_MUX_sel = pcmux::if_id_out_pc_plus4; 
                btb_load = 1'b1;
            end
        end
        else if(id_btb_read_hit == 1'b1 && (id_br_pr != id_ex_in_br_en))
        begin
            if_id_reg_flush = 1'b1;
            if(id_ex_in_br_en == 1'b1)
                pc_MUX_sel = pcmux::adder_out;  
            if(id_ex_in_br_en == 1'b0)
                pc_MUX_sel = pcmux::if_id_out_pc_plus4; 
            if(br_jal_wrong_target)
                btb_load = 1'b1;
        end
        else if(id_btb_read_hit == 1'b0 && id_ex_in_br_en == 1'b1)  // whenever BTB is a miss, always fetch PC+4
        begin 
            if_id_reg_flush = 1'b1;
            btb_load = 1'b1;
            pc_MUX_sel = pcmux::adder_out;
        end
    end 
    else if(id_ex_in_ctrl.opcode == op_jal)
    begin 
        if(id_btb_read_hit == 1'b1)
        begin
            if(br_jal_wrong_target)
            begin
                if_id_reg_flush = 1'b1;
                pc_MUX_sel = pcmux::adder_out;
                btb_load = 1'b1;
            end
        end
        else if(id_btb_read_hit == 1'b0)
        begin 
            if_id_reg_flush = 1'b1;
            btb_load = 1'b1;
            pc_MUX_sel = pcmux::adder_out;
        end
    end
    else if(id_ex_in_ctrl.opcode == op_jalr)
    begin 
        if(id_btb_read_hit == 1'b1 && (jalr_wrong_target == 1'b1))
        begin
            if_id_reg_flush = 1'b1;
            btb_load = 1'b1;
            pc_MUX_sel = pcmux::adder_mod2;
        end 
        if(id_btb_read_hit == 1'b0)
        begin 
            if_id_reg_flush = 1'b1;
            btb_load = 1'b1;
            pc_MUX_sel = pcmux::adder_mod2;
        end 
    end

    /* Update GHR/BHT */
    if((id_ex_in_ctrl.opcode == op_br) && (if_id_reg_load == 1'b1))
    begin
        ghr_load = 1'b1;
        bht_load = 1'b1;
    end


    /* Update PHT */
    if(id_ex_in_ctrl.opcode == op_br && (if_id_reg_load == 1'b1))
    begin	
        if(id_ex_in_br_en == 1'b1)
            increment_pht = 1'b1;
        else
            decrement_pht = 1'b1;
    end 

    /* Update Tournament PHT */
    if(id_ex_in_ctrl.opcode == op_br && (if_id_reg_load == 1'b1))
    begin	
        if(id_ex_in_br_en == id_local_pr)
            local_c = 1'b1;
        if(id_ex_in_br_en == id_global_pr)
            global_c = 1'b1;
        if(local_c != global_c)
        begin
            if(local_c == 1'b1)
                decrement_tournament_pht = 1'b1;  // local predictor is RIGHT, global predictor is WRONG, and we let the number go DOWN, so if the counter value is low, it means local is right a lot recently
            else if(global_c == 1'b1)
                increment_tournament_pht = 1'b1;
        end
    end 

    /* Data Cache Miss */
    if(data_mem_resp == 1'b0 && (ex_mem_out_ctrl.mem_read == 1'b1 || ex_mem_out_ctrl.mem_write == 1'b1))
    begin
        load_pc = 1'b0;
        pipeline_load(1'b0, 1'b0, 1'b0, 1'b0);
        global_stall = 1'b1;
        continue_i_cache = 1'b0;
    end

end

endmodule : stall_control_unit
