# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Sat Dec 27 19:51:28 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design updown_counter

create_clock -name "clock" -period 2.0 -waveform {0.0 1.0} [get_ports clk]
set_load -pin_load 0.15 [get_ports {count[7]}]
set_load -pin_load 0.15 [get_ports {count[6]}]
set_load -pin_load 0.15 [get_ports {count[5]}]
set_load -pin_load 0.15 [get_ports {count[4]}]
set_load -pin_load 0.15 [get_ports {count[3]}]
set_load -pin_load 0.15 [get_ports {count[2]}]
set_load -pin_load 0.15 [get_ports {count[1]}]
set_load -pin_load 0.15 [get_ports {count[0]}]
set_load -pin_load 0.15 [get_ports overflow]
set_clock_gating_check -setup 0.0 
set_max_fanout 20.000 [current_design]
set_input_transition 0.12 [get_ports clk]
set_input_transition 0.12 [get_ports rst]
set_input_transition 0.12 [get_ports enable]
set_input_transition 0.12 [get_ports up_down]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.01 [get_ports clk]
set_clock_uncertainty -hold 0.01 [get_ports clk]
