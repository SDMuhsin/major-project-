# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param power.enableUnconnectedCarry8PinPower 1
set_param power.BramSDPPropagationFix 1
set_param power.enableCarry8RouteBelPower 1
set_param power.enableLutRouteBelPower 1
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7k70tfbv676-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.cache/wt [current_project]
set_property parent.project_path C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/Absoluter_18.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/Absoluter_adder.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/AdderWc_pipelined.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/RowUnit.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/Subtractor_pipelined.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/adderW2.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/emsggen.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/m16VG.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/m18VG.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/m2VG_pipelined_2.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/m4VG_2.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/m8VG.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/recovunit_dp.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/subtract_2.v
  C:/Users/Sankar/Documents/GitHub/major-project-/row_process_oct15_pipelined/row_process_oct15_pipelined.srcs/sources_1/new/rowunit_cover.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Sankar/Desktop/final proj/design_constr.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Sankar/Desktop/final proj/design_constr.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top rowunit_cover -part xc7k70tfbv676-1 -flatten_hierarchy none


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef rowunit_cover.dcp
create_report "synth_2_using_xc7k70tfbv676-1_synth_report_utilization_0" "report_utilization -file rowunit_cover_utilization_synth.rpt -pb rowunit_cover_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
