set target_library [getenv STD_CELL_LIB]
set synthetic_library [list dw_foundation.sldb]
set link_library   [list "*" $target_library $synthetic_library]
set symbol_library [list generic.sdb]

set design_clock_pin clk
set design_reset_pin rst

proc ::findFiles { baseDir pattern } {
  set dirs [ glob -nocomplain -type d [ file join $baseDir * ] ]
  set files {}
  foreach dir $dirs { 
    lappend files {*}[ findFiles $dir $pattern ] 
  }
  lappend files {*}[ glob -nocomplain -type f [ file join $baseDir $pattern ] ] 
  return $files
} 

suppress_message LINT-31
suppress_message LINT-52
suppress_message LINT-28
suppress_message LINT-29
suppress_message LINT-32
suppress_message LINT-33
suppress_message LINT-28
suppress_message LINT-1
suppress_message LINT-99
suppress_message LINT-2

set hdlin_check_no_latch true

set pkgs [glob ../pkg/*.sv]
foreach module $pkgs {
    puts "analyzing $module"
    analyze -library WORK -format sverilog "${module}"
}

set modules [ join [ findFiles ../hdl "*.sv" ] \n ]

foreach module $modules {
    puts "analyzing $module"
    analyze -library WORK -format sverilog "${module}"
}


elaborate mp4 
current_design mp4
check_design
read_saif -input ../sim/dump.fsdb.saif -instance mp4_tb/dut


set_max_area 500000 -ignore_tns
set clk_name $design_clock_pin
create_clock -period 5.5 -name my_clk $clk_name
set_dont_touch_network [get_clocks my_clk]
set_fix_hold [get_clocks my_clk]
set_clock_uncertainty 0.1 [get_clocks my_clk]
set_ideal_network [get_ports clk]

set_input_delay 1 [all_inputs] -clock my_clk
set_output_delay 1 [all_outputs] -clock my_clk
set_load 0.1 [all_outputs]
set_max_fanout 1 [all_inputs]
set_fanout_load 8 [all_outputs]

link
compile_ultra -no_autoungroup -gate_clock 

current_design mp4

report_area -hier > reports/area.rpt
report_timing > reports/timing.rpt
check_design > reports/check.rpt
report_power -analysis_effort high -hierarchy > reports/power.rpt

write_file -format ddc -hierarchy -output synth.ddc
exit