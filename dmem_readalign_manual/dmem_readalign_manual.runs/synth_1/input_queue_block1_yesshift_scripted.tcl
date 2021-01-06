# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7k70tfbv676-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/sayed/Desktop/Programing/major project/major-project-/dmem_readalign_manual/dmem_readalign_manual.cache/wt} [current_project]
set_property parent.project_path {C:/Users/sayed/Desktop/Programing/major project/major-project-/dmem_readalign_manual/dmem_readalign_manual.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {{C:/Users/sayed/Desktop/Programing/major project/major-project-/dmem_readalign_manual/dmem_readalign_manual.srcs/sources_1/new/input_alone_yesshift_blockn.v}}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top input_queue_block1_yesshift_scripted -part xc7k70tfbv676-1


write_checkpoint -force -noxdef input_queue_block1_yesshift_scripted.dcp

catch { report_utilization -file input_queue_block1_yesshift_scripted_utilization_synth.rpt -pb input_queue_block1_yesshift_scripted_utilization_synth.pb }