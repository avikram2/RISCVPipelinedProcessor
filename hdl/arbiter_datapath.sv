
module arbiter_datapath
import rv32i_types::*;
(
	
    /* I-Cache Side Signals */
	input logic [31:0] i_pmem_address,
    output logic [255:0] i_pmem_rdata,

    /* D-Cache Side Signals */
    input logic [31:0] d_pmem_address,
    input logic [255:0] d_pmem_wdata,
    output logic [255:0] d_pmem_rdata,


	/* Physical Memory Side Signals */
	output logic [31:0] a_pmem_address,
	output logic [255:0] a_pmem_wdata,
	input logic [255:0] a_pmem_rdata,

	/* Control to Datapath */
	input arbiteraddressmux::arbiteraddressmux_sel_t arbiter_address_MUX_sel

);

assign a_pmem_wdata = d_pmem_wdata;
assign i_pmem_rdata = a_pmem_rdata;
assign d_pmem_rdata = a_pmem_rdata;


always_comb begin : ARBITERADDRESSMUX

    a_pmem_address = '0;

    unique case (arbiter_address_MUX_sel)
        arbiteraddressmux::d_cache       : a_pmem_address = d_pmem_address;
        arbiteraddressmux::i_cache       : a_pmem_address = i_pmem_address;
        default: ;
    endcase
end


endmodule : arbiter_datapath