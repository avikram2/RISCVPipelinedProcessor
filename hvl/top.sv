module mp4_tb;
import rv32i_types::*;
`timescale 1ns/10ps

/********************* Do not touch for proper compilation *******************/
// Instantiate Interfaces
tb_itf itf();
rvfi_itf rvfi(itf.clk, itf.rst);

// Instantiate Testbench
source_tb tb(
    .magic_mem_itf(itf),
    .mem_itf(itf),
    .sm_itf(itf),
    .tb_itf(itf),
    .rvfi(rvfi)
);

// Dump signals
initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, mp4_tb, "+all");
end
/****************************** End do not touch *****************************/


/************************ Signals necessary for monitor **********************/

// Set high when a valid instruction is modifying regfile or PC
assign rvfi.commit = (dut.cpu.mem_wb_out.ctrl.load_regfile || dut.cpu.load_pc || dut.cpu.mem_wb_reg_load) && (dut.cpu.debug_WB_IR != 32'h00000013) && (dut.cpu.mem_wb_out.ctrl != '0); 
// Set high when target PC == Current PC for a branch
assign rvfi.halt = dut.cpu.debug_halt;
initial rvfi.order = 0;
always @(posedge itf.clk iff rvfi.commit) rvfi.order <= rvfi.order + 1; // Modify for OoO

assign rvfi.trap = 1'b0;
assign rvfi.inst = dut.cpu.debug_WB_IR;
assign rvfi.rs1_addr = dut.cpu.mem_wb_out.ctrl.rs1_id;
assign rvfi.rs2_addr = dut.cpu.mem_wb_out.ctrl.rs2_id;
assign rvfi.rs1_rdata = dut.cpu.regfile.data[dut.cpu.mem_wb_out.ctrl.rs1_id];
assign rvfi.rs2_rdata = dut.cpu.regfile.data[dut.cpu.mem_wb_out.ctrl.rs2_id];
assign rvfi.rd_addr = dut.cpu.mem_wb_out.ctrl.rd_id;
assign rvfi.load_regfile = dut.cpu.mem_wb_out.ctrl.load_regfile;
assign rvfi.rd_wdata = dut.cpu.regfile_MUX_out;
assign rvfi.pc_rdata = dut.cpu.debug_WB_PC;

always_comb
begin
    rvfi.pc_wdata = dut.cpu.debug_MEM_PC;

    if(dut.cpu.debug_MEM_IR == 32'h00000013 || dut.cpu.ex_mem_out.ctrl == '0)
        rvfi.pc_wdata = dut.cpu.debug_EX_PC;
    if((dut.cpu.debug_MEM_IR == 32'h00000013 || dut.cpu.ex_mem_out.ctrl == '0) &&
       (dut.cpu.debug_EX_IR == 32'h00000013 || dut.cpu.id_ex_out.ctrl == '0))
        rvfi.pc_wdata = dut.cpu.debug_ID_PC;
    if((dut.cpu.debug_MEM_IR == 32'h00000013 || dut.cpu.ex_mem_out.ctrl == '0) &&
       (dut.cpu.debug_EX_IR == 32'h00000013 || dut.cpu.id_ex_out.ctrl == '0)   &&
       (dut.cpu.debug_ID_IR == 32'h00000013))
        rvfi.pc_wdata = dut.cpu.if_id_in.pc;
end

assign rvfi.mem_rmask = ((dut.cpu.mem_wb_out.ctrl.opcode == op_load) || (dut.cpu.mem_wb_out.ctrl.mem_read)) ? dut.cpu.mem_wb_out.write_read_mask : 4'b0;
assign rvfi.mem_wmask = ((dut.cpu.mem_wb_out.ctrl.opcode == op_store) || (dut.cpu.mem_wb_out.ctrl.mem_write)) ? dut.cpu.mem_wb_out.write_read_mask : 4'b0;
assign rvfi.mem_rdata = dut.cpu.mem_wb_out.MDR;
assign rvfi.mem_addr = dut.cpu.mem_wb_out.alu_out_address;
assign rvfi.mem_wdata = dut.cpu.mem_wb_out.mem_data_out;

// possible_error: For an instruction that reads no rs1/rs2 register, this output can have an arbitrary value. However, if this output is nonzero then rvfi_rs1_rdata must carry the value stored in that register in the pre-state.
/*
Instruction and trap:
    rvfi.inst  [DONE]
    rvfi.trap  [This honestly not that useful]

Regfile:
    rvfi.rs1_addr [DONE]
    rvfi.rs2_addr [DONE]
    rvfi.rs1_rdata [DONE]
    rvfi.rs2_rdata [DONE]
    rvfi.load_regfile [DONE]
    rvfi.rd_addr [DONE]
    rvfi.rd_wdata [DONE]

PC:
    rvfi.pc_rdata [DONE]
    rvfi.pc_wdata [DONE]

Memory:
    rvfi.mem_addr [DONE]
    rvfi.mem_rmask [DONE]
    rvfi.mem_wmask [DONE]
    rvfi.mem_rdata [DONE]
    rvfi.mem_wdata [DONE]

Please refer to rvfi_itf.sv for more information.
*/

/**************************** End RVFIMON signals ****************************/

/********************* Assign Shadow Memory Signals Here *********************/

assign itf.inst_read = dut.instr_read;
assign itf.inst_addr = dut.instr_mem_address;
assign itf.inst_resp = dut.instr_mem_resp;
assign itf.inst_rdata = dut.instr_mem_rdata;

assign itf.data_read = dut.data_read;
assign itf.data_write = dut.data_write;
assign itf.data_mbe = dut.data_mbe;
assign itf.data_addr = dut.data_mem_address;
assign itf.data_wdata = dut.data_mem_wdata;
assign itf.data_resp = dut.data_mem_resp;
assign itf.data_rdata = dut.data_mem_rdata;
/*
The following signals need to be set:
icache signals:
    itf.inst_read
    itf.inst_addr
    itf.inst_resp
    itf.inst_rdata

dcache signals:
    itf.data_read
    itf.data_write
    itf.data_mbe
    itf.data_addr
    itf.data_wdata
    itf.data_resp
    itf.data_rdata

Please refer to tb_itf.sv for more information.
*/

/*********************** End Shadow Memory Assignments ***********************/

// Set this to the proper value
assign itf.registers = dut.cpu.regfile.data;

/*********************** Instantiate your design here ************************/
/*
The following signals need to be connected to your top level for CP2:
Burst Memory Ports:
    itf.mem_read
    itf.mem_write
    itf.mem_wdata
    itf.mem_rdata
    itf.mem_addr
    itf.mem_resp

Please refer to tb_itf.sv for more information.
*/

mp4 dut(
    .clk(itf.clk),
    .rst(itf.rst),

    .pmem_read(itf.mem_read),
    .pmem_write(itf.mem_write),
    .pmem_wdata(itf.mem_wdata),
    .pmem_rdata(itf.mem_rdata),
    .pmem_address(itf.mem_addr),
    .pmem_resp(itf.mem_resp)
);
/***************************** End Instantiation *****************************/

endmodule
