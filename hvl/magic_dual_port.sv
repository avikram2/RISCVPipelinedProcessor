/*
 * Dual-port magic memory
 *
 */

module magic_memory_dp
(
    tb_itf.magic_mem itf
);

timeunit 1ns;
timeprecision 1ns;

logic [7:0] mem [logic [31:0]];

initial
begin
    string s;
    itf.path_mb.peek(s);
    $readmemh(s, mem);
end

always @(itf.mmcb)
begin : response
    if (itf.mmcb.read_a) begin
        itf.mmcb.resp_a <= 1'b1;
        for (int i = 0; i < 4; i++) begin
            itf.mmcb.rdata_a[i*8 +: 8] <= mem[itf.mmcb.address_a+i];
        end
    end else begin
        itf.mmcb.resp_a <= 1'b0;
    end

    if (itf.mmcb.read_b) begin
        itf.mmcb.resp_b <= 1'b1;
        for (int i = 0; i < 4; i++) begin
            itf.mmcb.rdata_b[i*8 +: 8] <= mem[itf.mmcb.address_b+i];
        end
    end else if (itf.mmcb.write) begin
        itf.mmcb.resp_b <= 1'b1;
        for (int i = 0; i < 4; i++) begin
            if (itf.mmcb.wmask[i])
            begin
                mem[itf.mmcb.address_b+i] = itf.mmcb.wdata[i*8 +: 8];
            end
        end
    end else begin
        itf.mmcb.resp_b <= 1'b0;
    end
end : response

endmodule : magic_memory_dp
