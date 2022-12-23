module pc_inc
import rv32i_types::*;
(
    input rv32i_word in,
    output rv32i_word out
);

assign out = in + 32'd4;

endmodule : pc_inc
