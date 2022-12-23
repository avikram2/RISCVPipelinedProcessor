package cache_mux_types;

typedef enum bit [1:0] {
    no_write          = 2'b00
    ,cpu_write_cache  = 2'b01
    ,mem_write_cache  = 2'b10
} dataarraymux_sel_t;


typedef enum bit {
    cache_read_mem = 1'b0
    ,cache_write_mem = 1'b1
} pmemaddressmux_sel_t;

typedef enum bit {
    curr_cpu_address = 1'b0
    ,prev_cpu_address = 1'b1
} paddressmux_sel_t;

endpackage : cache_mux_types