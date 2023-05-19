create_clock -period 2.50 -name vclk
set_input_delay -max 0.50 -clock vclk [all_inputs]
set_output_delay -max 0.50 -clock vclk [all_outputs]

