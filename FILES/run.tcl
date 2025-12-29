read_libs /home/install/FOUNDRY/digital/90nm/dig/lib/slow.lib
read_hdl n_bit_counter.v
elaborate
read_sdc constraints.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
syn_generic
syn_map
syn_opt
report_timing > n_bit_counter_timing.rep
report_area > n_bit_counter_area.rep
report_power > n_bit_counter_power.rep 
write_hdl > n_bit_counter_netlist.v
write_sdc > n_bit_counter_output_constaints.sdc
report_gates > n_bit_counter_gates.v
gui_show
