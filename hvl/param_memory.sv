`ifndef MEMORY_CLASS_SV
`define MEMORY_CLASS_SV
module ParamMemory
#(
    parameter int DELAY_MEM,         // In Cycles
    parameter int DELAY_PAGE_HIT,    // In Cycles
    parameter int BURST_LEN,         // In Bits
    parameter int CACHE_LINE_WIDTH,  // In Bits
    parameter int PAGE_SIZE          // In Bytes
)
(
    tb_itf.mem itf
);

localparam int BURST_WIDTH = CACHE_LINE_WIDTH / BURST_LEN;
localparam int ADDRLEN = 32;
localparam int CARELEN = ADDRLEN - $clog2(CACHE_LINE_WIDTH / 8);
localparam logic [ADDRLEN-1:0] mask = {{(CARELEN){1'b1}},
                                       {(ADDRLEN-CARELEN){1'b0}}};

logic [CACHE_LINE_WIDTH-1:0] _mem [logic [ADDRLEN-1:0]];
int signed pageno;

initial begin
    int iteration = 0;
    forever begin
        @(itf.mcb iff (itf.mcb.rst || itf.mcb.read || itf.mcb.write))
        case ({itf.mcb.rst, itf.mcb.read, itf.mcb.write})
            3'b100, 3'b101, 3'b111, 3'b110: begin
                reset();
            end
            3'b010: memread(itf.mcb.addr);
            3'b001: memwrite(itf.mcb.addr);
            default: $error("simultaneous read/write");
        endcase
    end
end

task reset;
    string s;
    if (pageno == -1)
        return;
    _mem.delete();
    itf.path_mb.get(s);
    $readmemh(s, _mem);
    $display("Reset Memory");
    pageno = -1;
endtask

task automatic memread(input logic [ADDRLEN-1:0] addr);
    int signed _pageno;
    int delay;
    logic [ADDRLEN-1:0] _addr;
    logic [31:0] _read_loc;
    _addr = addr & mask;
    _read_loc = _addr / (CACHE_LINE_WIDTH / 8);
    _pageno = addr / PAGE_SIZE;
    delay = _pageno == pageno ? DELAY_PAGE_HIT : DELAY_MEM;
    pageno = _pageno;
    fork : f
        begin : error_check
            // This process simply runs some assertions at each 
            // new cycle, asserting error and ending the read if any assertion
            // fails
            forever @(itf.mcb) begin
                read_steady: assert(itf.mcb.read) else begin
                    $display(
                        "Grading Error: PMEM Read Error: Read deasserted early"
                    );
                    itf.mcb.error <= 1'b1;
                    disable f;
                    break;
                end
                no_write: assert(!itf.mcb.write) else begin
                    $display("Grading Error: PMEM Read Error: Write asserted");
                    itf.mcb.error <= 1'b1;
                    disable f;
                    break;
                end
                addr_read_steady: assert(itf.mcb.addr == addr) else begin
                    $display("Grading Error: PMEM Read Error: Address changed");
                    $display("Address %8x != addr %8x", itf.mcb.addr, addr);
                    itf.mcb.error <= 1'b1;
                    disable f;
                    break;
                end
            end
        end
        begin : memreader
            // This process waits for 'duration' cycles and then does a burst
            // write.  Resp goes high the cycle before the first write is
            // done, so the writer must be careful about this point
            repeat (delay) @(itf.mcb);
            for (int i = 0; i < BURST_LEN; ++i) begin
                itf.mcb.rdata <= _mem[_read_loc][BURST_WIDTH*i +: BURST_WIDTH];
                itf.mcb.resp <= 1'b1;
                @(itf.mcb);
            end
            itf.mcb.resp <= 1'b0;
            disable f;
        end
    join
endtask

/*
 * Do a memory write --- executed on $rose(write)
*/
task automatic memwrite(input logic [31:0] addr);
    // Calculate the memory latency and update that 'charged' memory data
    int signed _pageno;
    int delay;
    logic [31:0] _addr;
    logic [31:0] _read_loc;
    _addr = addr & mask;
    _read_loc = _addr / (CACHE_LINE_WIDTH / 8);
    _pageno = addr / PAGE_SIZE;
    delay = _pageno == pageno ? DELAY_PAGE_HIT : DELAY_MEM;
    pageno = _pageno;

    fork : f
        begin : error_check
            // This process simply runs some assertions at each 
            // new cycle, asserting error and ending the read if any assertion
            // fails
            forever @(itf.mcb) begin
                write_steady: assert(itf.mcb.write) else begin
                    $display("PMEM Write Error: Write deasserted early\n");
                    itf.mcb.error <= 1'b1;
                    disable f;
                    break;
                end
                no_read: assert(!itf.mcb.read) else begin
                    $display("PMEM Write Error: Read asserted\n");
                    itf.mcb.error <= 1'b1;
                    disable f;
                    break;
                end
                addr_write_steady: assert(itf.mcb.addr == addr) else begin
                    $display("PMEM Write Error: Address changed\n");
                    $display("Address %8x != addr %8x", itf.mcb.addr, addr);
                    itf.mcb.error <= 1'b1;
                    disable f;
                    break;
                end
            end
        end
        begin : memwrite
            // This process waits for 'duration' cycles and then does a burst
            // write.  Resp goes high the cycle before the first write is
            // done, so the writer must be careful about this point
            repeat (delay) @(itf.mcb);
            for (int i = 0; i < BURST_LEN; ++i) begin
                itf.mcb.resp <= 1'b1;
                @(itf.mcb);
                _mem[_read_loc][BURST_WIDTH*i +: BURST_WIDTH] = itf.mcb.wdata;
            end
            itf.mcb.resp <= 1'b0;
            disable f;
        end
    join
endtask
endmodule

`endif
