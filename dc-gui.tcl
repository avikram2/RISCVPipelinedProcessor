set target_library [getenv STD_CELL_LIB]
set synthetic_library [list dw_foundation.sldb]
set link_library   [list "*" $target_library $synthetic_library]
set symbol_library [list generic.sdb]
read_file -format ddc synth.ddc 