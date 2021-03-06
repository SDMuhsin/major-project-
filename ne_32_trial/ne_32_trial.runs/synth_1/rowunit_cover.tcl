# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7k160tffv676-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/mani/ne_32_trial/ne_32_trial.cache/wt [current_project]
set_property parent.project_path C:/Users/mani/ne_32_trial/ne_32_trial.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/row_processing_unit/row_processing_unit.srcs/sources_1/new/m2VG_pipelined_2.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/egencopy/egencopy.srcs/sources_1/imports/new/m4VG.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/egencopy/egencopy.srcs/sources_1/imports/new/m8VG.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/new/Absoluter_adder.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/egencopy/egencopy.srcs/sources_1/imports/new/m16VG.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/new/Absoluter_32.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/new/m32VG.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/row_processing_unit/row_processing_unit.srcs/sources_1/new/subtract_2.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/row_processing_unit/row_processing_unit.srcs/sources_1/new/adderW2.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/new/subtractor_32.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/new/Subtractor_pipelined.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/row_processing_unit/row_processing_unit.srcs/sources_1/new/recovunit_dp.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/row_processing_unit/row_processing_unit.srcs/sources_1/new/emsggen.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/new/AdderWc_pipelined.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/row_processing_unit/row_processing_unit.srcs/sources_1/new/RowUnit.v
  C:/Users/mani/ne_32_trial/ne_32_trial.srcs/sources_1/imports/mani/row_processing_unit/row_processing_unit.srcs/sources_1/new/rowunit_cover.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/mani/ne_32_trial/ne_32_trial.srcs/constrs_1/imports/Downloads/design_constr.xdc
set_property used_in_implementation false [get_files C:/Users/mani/ne_32_trial/ne_32_trial.srcs/constrs_1/imports/Downloads/design_constr.xdc]


synth_design -top rowunit_cover -part xc7k160tffv676-1 -flatten_hierarchy none


write_checkpoint -force -noxdef rowunit_cover.dcp

catch { report_utilization -file rowunit_cover_utilization_synth.rpt -pb rowunit_cover_utilization_synth.pb }
