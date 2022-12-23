`ifndef SHADOW_MEMORY
`define SHADOW_MEMORY

module shadow_memory(tb_itf.sm sm_itf);

logic [255:0] _mem  [logic [31:5]];
logic [255:0] _imem [logic [31:5]];

function void _new(string filepath);
    $readmemh(filepath, _mem);
    $readmemh(filepath, _imem);
endfunction

function automatic logic [31:0] read_inst(logic [31:0] addr);
    logic [255:0] line;
    logic [31:0] rv;
    line = _imem[addr[31:5]];
    rv = line[8*{addr[4:2], 2'b00} +: 32];
    return rv;
endfunction

function automatic logic [31:0] read(logic [31:0] addr);
    logic [255:0] line;
    logic [31:0] rv;
    line = _mem[addr[31:5]];
    rv = line[8*{addr[4:2], 2'b00} +: 32];
    return rv;
endfunction

function automatic void write(logic [31:0] addr, logic [31:0] wdata,
                              logic [3:0] mem_byte_enable);
    logic [255:0] line;
    line = _mem[addr[31:5]];
    foreach (mem_byte_enable[i]) begin
        if (mem_byte_enable[i])
            line[8*({addr[4:2], 2'b00} + i) +: 8] = wdata[8*i +: 8];
    end
    _mem[addr[31:5]] = line;
endfunction

int errcount = 0;
initial begin
    logic [31:0] rdata_inst;
    logic [31:0] rdata_data;
    logic _read_data;
    string path;
    sm_itf.path_mb.peek(path);
    _new(path);
    fork
        begin : instruction
            forever begin
                @(sm_itf.smcb iff (sm_itf.smcb.read_a && sm_itf.smcb.resp_a))
                rdata_inst = read_inst(sm_itf.smcb.address_a);
                if (rdata_inst != sm_itf.smcb.rdata_a) begin
                    $display("%0t: ShadowMemory Error: Mismatch rdata:", $time,
                        " Expected %8h, Detected %8h", rdata_inst,
                        sm_itf.smcb.rdata_a);
                    errcount++;
                end
            end
        end

        begin : data
            forever begin
                @(sm_itf.smcb iff ((sm_itf.smcb.read_b || sm_itf.smcb.write) && sm_itf.smcb.resp_b))
                if (sm_itf.smcb.read_b) begin
                    rdata_data = read(sm_itf.smcb.address_b);
                    _read_data = 1'b1;
                end
                else begin
                    write(sm_itf.smcb.address_b, sm_itf.smcb.wdata,
                            sm_itf.smcb.mbe);
                    _read_data = 1'b0;
                end
                if (_read_data) begin
                    if (rdata_data != sm_itf.smcb.rdata_b) begin
                        $display("%0t: ShadowMemory Error: Mismatch rdata:", $time,
                            " Expected %8h, Detected %8h", rdata_data,
                            sm_itf.smcb.rdata_b);
                        errcount++;
                    end
                end
            end
        end
    join_none
end

endmodule

`endif
