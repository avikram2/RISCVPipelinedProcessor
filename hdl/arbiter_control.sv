
module arbiter_control
import rv32i_types::*;
(
    input clk,
    input rst,
	
    /* I-Cache Side Signals */
    output logic i_pmem_resp,
    input logic i_pmem_read,

    /* D-Cache Side Signals */
    output logic d_pmem_resp,
    input logic d_pmem_read,
    input logic d_pmem_write,

    /* Memory Side Signals */
    input logic a_pmem_resp,
    output logic a_pmem_read,
    output logic a_pmem_write,

	/* Control to Datapath */
	output arbiteraddressmux::arbiteraddressmux_sel_t arbiter_address_MUX_sel
);

enum int unsigned {
    IDLE, 
    SERVE_D_CACHE, 
    SERVE_I_CACHE
} state, next_state;


function void set_defaults();


    i_pmem_resp = 1'b0;
    d_pmem_resp = 1'b0;
    a_pmem_write = 1'b0;
    a_pmem_read = 1'b0;    
	arbiter_address_MUX_sel = arbiteraddressmux::d_cache;

endfunction


always_comb
begin : state_actions

    set_defaults();

    case(state)
		IDLE:
		begin

		end
		SERVE_D_CACHE:
		begin
			arbiter_address_MUX_sel = arbiteraddressmux::d_cache;

			if (d_pmem_read)
                a_pmem_read = 1'b1;
            else if (d_pmem_write)
                a_pmem_write = 1'b1;

			d_pmem_resp = a_pmem_resp;
        
		end
		SERVE_I_CACHE:
		begin
			arbiter_address_MUX_sel = arbiteraddressmux::i_cache;

			a_pmem_read = 1'b1;
				
			i_pmem_resp = a_pmem_resp;
		end

    endcase
end

always_comb
begin : next_state_logic

    next_state = state;

    case(state)
		IDLE:
		begin
			if(d_pmem_read || d_pmem_write)
				next_state = SERVE_D_CACHE;
			else if(i_pmem_read)
				next_state = SERVE_I_CACHE;
		end
		SERVE_D_CACHE:
		begin
			if(a_pmem_resp)
				next_state = IDLE;
		end
		SERVE_I_CACHE:
		begin
			if(a_pmem_resp)
				next_state = IDLE;
		end
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

endmodule : arbiter_control