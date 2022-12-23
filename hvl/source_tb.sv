`ifndef SOURCE_TB
`define SOURCE_TB

`define MAGIC_MEM 0
`define PARAM_MEM 1
`define MEMORY `PARAM_MEM
// possible_error_CP2: probably should change this MACRO to go from Magic to Param Mem

// Set these to 1 to enable the feature for CP2
// possible_error_CP2: enable/disable SM and RVFI
`define USE_SHADOW_MEMORY 0
`define USE_RVFI_MONITOR 0

`include "tb_itf.sv"

module source_tb(
    tb_itf.magic_mem magic_mem_itf,
    tb_itf.mem mem_itf,
    tb_itf.sm sm_itf,
    tb_itf.tb tb_itf,
    rvfi_itf rvfi
);

initial begin
    $display("Compilation Successful");
    tb_itf.path_mb.put("memory.lst");
    tb_itf.rst = 1'b1;
    repeat (5) @(posedge tb_itf.clk);
    tb_itf.rst = 1'b0;
end

/**************************** Halting Conditions *****************************/
int timeout = 100000000;

always @(posedge tb_itf.clk) begin
    if (rvfi.halt)
        $finish;
    if (timeout == 0) begin
        $display("TOP: Timed out");
        $finish;
    end
    timeout <= timeout - 1;
end

always @(rvfi.errcode iff (rvfi.errcode != 0)) begin
    repeat(5) @(posedge itf.clk);
    $display("TOP: Errcode: %0d", rvfi.errcode);
    $finish;
end

/************************** End Halting Conditions ***************************/
`define PARAM_RESPONSE_NS 50 * 10
`define PARAM_RESPONSE_CYCLES $ceil(`PARAM_RESPONSE_NS / `PERIOD_NS)
`define PAGE_RESPONSE_CYCLES $ceil(`PARAM_RESPONSE_CYCLES / 2.0)

generate
    if (`MEMORY == `MAGIC_MEM) begin : memory
        magic_memory_dp mem(magic_mem_itf);
    end
    else if (`MEMORY == `PARAM_MEM) begin : memory
        ParamMemory #(`PARAM_RESPONSE_CYCLES, `PAGE_RESPONSE_CYCLES, 4, 256, 512) mem(mem_itf);
    end
endgenerate

generate
    if (`USE_SHADOW_MEMORY) begin
        shadow_memory sm(sm_itf);
    end

    if (`USE_RVFI_MONITOR) begin
        /* Instantiate RVFI Monitor */
        riscv_formal_monitor_rv32imc monitor(
            .clock(rvfi.clk),
            .reset(rvfi.rst),
            .rvfi_valid(rvfi.commit),
            .rvfi_order(rvfi.order),
            .rvfi_insn(rvfi.inst),
            .rvfi_trap(rvfi.trap),
            .rvfi_halt(rvfi.halt),
            .rvfi_intr(1'b0),
            .rvfi_mode(2'b00),
            .rvfi_rs1_addr(rvfi.rs1_addr),
            .rvfi_rs2_addr(rvfi.rs2_addr),
            .rvfi_rs1_rdata(rvfi.rs1_addr ? rvfi.rs1_rdata : 0),
            .rvfi_rs2_rdata(rvfi.rs2_addr ? rvfi.rs2_rdata : 0),
            .rvfi_rd_addr(rvfi.load_regfile ? rvfi.rd_addr : 5'b0),
            .rvfi_rd_wdata(rvfi.load_regfile ? rvfi.rd_wdata : 0),
            .rvfi_pc_rdata(rvfi.pc_rdata),
            .rvfi_pc_wdata(rvfi.pc_wdata),
            .rvfi_mem_addr({rvfi.mem_addr[31:2], 2'b0}),
            .rvfi_mem_rmask(rvfi.mem_rmask),
            .rvfi_mem_wmask(rvfi.mem_wmask),
            .rvfi_mem_rdata(rvfi.mem_rdata),
            .rvfi_mem_wdata(rvfi.mem_wdata),
            .rvfi_mem_extamo(1'b0),
            .errcode(rvfi.errcode)
        );
    end
endgenerate

endmodule

`endif
