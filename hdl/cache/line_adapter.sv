module line_adapter (
  output logic [255:0] mem_wdata_line,
  input logic [255:0] mem_rdata_line,
  input logic [31:0] mem_wdata,
  output logic [31:0] mem_rdata,
  input logic [3:0] mem_byte_enable,
  output logic [31:0] mem_byte_enable_line,
  input logic [31:0] address
);

assign mem_wdata_line = {8{mem_wdata}};
assign mem_rdata = mem_rdata_line[(32*address[4:2]) +: 32];
assign mem_byte_enable_line = {28'h0, mem_byte_enable} << (address[4:2]*4);

endmodule : line_adapter
