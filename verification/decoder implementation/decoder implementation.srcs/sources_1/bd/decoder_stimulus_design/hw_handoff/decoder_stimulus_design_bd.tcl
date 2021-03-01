
################################################################
# This is a generated script based on design: decoder_stimulus_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source decoder_stimulus_design_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# ne_stimulus_DUT_cover, outfifo_uarttx_controller

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu9p-flga2104-2L-e
   set_property BOARD_PART xilinx.com:vcu118:part0:2.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name decoder_stimulus_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set default_250mhz_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_250mhz_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   ] $default_250mhz_clk1


  # Create ports
  set full [ create_bd_port -dir O full ]
  set o_Tx_Active [ create_bd_port -dir O o_Tx_Active ]
  set o_Tx_Serial [ create_bd_port -dir O o_Tx_Serial ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset
  set start [ create_bd_port -dir I start ]
  set transmit_Ready [ create_bd_port -dir O transmit_Ready ]
  set transmit_en [ create_bd_port -dir I transmit_en ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {40.0} \
   CONFIG.CLKOUT1_JITTER {157.586} \
   CONFIG.CLKOUT1_PHASE_ERROR {253.053} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {44.680756} \
   CONFIG.CLKOUT2_JITTER {124.834} \
   CONFIG.CLKOUT2_PHASE_ERROR {253.053} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {160.906} \
   CONFIG.CLKOUT3_PHASE_ERROR {253.053} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {38.876878059} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_JITTER {124.834} \
   CONFIG.CLKOUT4_PHASE_ERROR {253.053} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {default_250mhz_clk1} \
   CONFIG.CLK_OUT1_PORT {in_clk} \
   CONFIG.CLK_OUT2_PORT {clk} \
   CONFIG.CLK_OUT3_PORT {out_clk} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {78.125} \
   CONFIG.MMCM_CLKIN1_PERIOD {4.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {33.625} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {6} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {39} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {6} \
   CONFIG.MMCM_DIVCLK_DIVIDE {13} \
   CONFIG.NUM_OUT_CLKS {4} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz_0

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Full_Threshold_Assert_Value {1022} \
   CONFIG.Full_Threshold_Negate_Value {1021} \
   CONFIG.Input_Data_Width {32} \
   CONFIG.Output_Data_Width {8} \
   CONFIG.Output_Depth {4096} \
   CONFIG.Read_Data_Count_Width {12} \
   CONFIG.asymmetric_port_width {true} \
 ] $fifo_generator_0

  # Create instance: ne_stimulus_DUT_cover_0, and set properties
  set block_name ne_stimulus_DUT_cover
  set block_cell_name ne_stimulus_DUT_cover_0
  if { [catch {set ne_stimulus_DUT_cover_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ne_stimulus_DUT_cover_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: outfifo_uarttx_contr_0, and set properties
  set block_name outfifo_uarttx_controller
  set block_cell_name outfifo_uarttx_contr_0
  if { [catch {set outfifo_uarttx_contr_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $outfifo_uarttx_contr_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net default_250mhz_clk1_1 [get_bd_intf_ports default_250mhz_clk1] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk [get_bd_pins clk_wiz_0/clk] [get_bd_pins ne_stimulus_DUT_cover_0/clk]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins fifo_generator_0/clk] [get_bd_pins outfifo_uarttx_contr_0/out_clk]
  connect_bd_net -net clk_wiz_0_in_clk [get_bd_pins clk_wiz_0/in_clk] [get_bd_pins ne_stimulus_DUT_cover_0/in_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins ne_stimulus_DUT_cover_0/rst] [get_bd_pins outfifo_uarttx_contr_0/rst]
  connect_bd_net -net clk_wiz_0_out_clk [get_bd_pins clk_wiz_0/out_clk] [get_bd_pins ne_stimulus_DUT_cover_0/out_clk]
  connect_bd_net -net fifo_generator_0_dout [get_bd_pins fifo_generator_0/dout] [get_bd_pins outfifo_uarttx_contr_0/i_Tx_Byte]
  connect_bd_net -net fifo_generator_0_empty [get_bd_pins fifo_generator_0/empty] [get_bd_pins outfifo_uarttx_contr_0/outfifo_empty]
  connect_bd_net -net fifo_generator_0_full [get_bd_ports full] [get_bd_pins fifo_generator_0/full]
  connect_bd_net -net ne_stimulus_DUT_cover_0_outfiforst [get_bd_pins fifo_generator_0/srst] [get_bd_pins ne_stimulus_DUT_cover_0/outfiforst]
  connect_bd_net -net ne_stimulus_DUT_cover_0_outpvalid [get_bd_pins fifo_generator_0/wr_en] [get_bd_pins ne_stimulus_DUT_cover_0/outpvalid]
  connect_bd_net -net ne_stimulus_DUT_cover_0_y [get_bd_pins fifo_generator_0/din] [get_bd_pins ne_stimulus_DUT_cover_0/y]
  connect_bd_net -net outfifo_uarttx_contr_0_o_Tx_Active [get_bd_ports o_Tx_Active] [get_bd_pins outfifo_uarttx_contr_0/o_Tx_Active]
  connect_bd_net -net outfifo_uarttx_contr_0_o_Tx_Serial [get_bd_ports o_Tx_Serial] [get_bd_pins outfifo_uarttx_contr_0/o_Tx_Serial]
  connect_bd_net -net outfifo_uarttx_contr_0_outfifo_rden [get_bd_pins fifo_generator_0/rd_en] [get_bd_pins outfifo_uarttx_contr_0/outfifo_rden]
  connect_bd_net -net outfifo_uarttx_contr_0_transmit_Ready [get_bd_ports transmit_Ready] [get_bd_pins outfifo_uarttx_contr_0/transmit_Ready]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net start_1 [get_bd_ports start] [get_bd_pins ne_stimulus_DUT_cover_0/start]
  connect_bd_net -net transmit_en_1 [get_bd_ports transmit_en] [get_bd_pins outfifo_uarttx_contr_0/transmit_en]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


