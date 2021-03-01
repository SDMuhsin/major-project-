# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BAUDRATE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLKS_PER_BIT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLK_FREQ_FPGA" -parent ${Page_0}
  ipgui::add_param $IPINST -name "s_CLEANUP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "s_IDLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "s_TX_DATA_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "s_TX_START_BIT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "s_TX_STOP_BIT" -parent ${Page_0}


}

proc update_PARAM_VALUE.BAUDRATE { PARAM_VALUE.BAUDRATE } {
	# Procedure called to update BAUDRATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAUDRATE { PARAM_VALUE.BAUDRATE } {
	# Procedure called to validate BAUDRATE
	return true
}

proc update_PARAM_VALUE.CLKS_PER_BIT { PARAM_VALUE.CLKS_PER_BIT } {
	# Procedure called to update CLKS_PER_BIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKS_PER_BIT { PARAM_VALUE.CLKS_PER_BIT } {
	# Procedure called to validate CLKS_PER_BIT
	return true
}

proc update_PARAM_VALUE.CLK_FREQ_FPGA { PARAM_VALUE.CLK_FREQ_FPGA } {
	# Procedure called to update CLK_FREQ_FPGA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_FREQ_FPGA { PARAM_VALUE.CLK_FREQ_FPGA } {
	# Procedure called to validate CLK_FREQ_FPGA
	return true
}

proc update_PARAM_VALUE.s_CLEANUP { PARAM_VALUE.s_CLEANUP } {
	# Procedure called to update s_CLEANUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.s_CLEANUP { PARAM_VALUE.s_CLEANUP } {
	# Procedure called to validate s_CLEANUP
	return true
}

proc update_PARAM_VALUE.s_IDLE { PARAM_VALUE.s_IDLE } {
	# Procedure called to update s_IDLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.s_IDLE { PARAM_VALUE.s_IDLE } {
	# Procedure called to validate s_IDLE
	return true
}

proc update_PARAM_VALUE.s_TX_DATA_BITS { PARAM_VALUE.s_TX_DATA_BITS } {
	# Procedure called to update s_TX_DATA_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.s_TX_DATA_BITS { PARAM_VALUE.s_TX_DATA_BITS } {
	# Procedure called to validate s_TX_DATA_BITS
	return true
}

proc update_PARAM_VALUE.s_TX_START_BIT { PARAM_VALUE.s_TX_START_BIT } {
	# Procedure called to update s_TX_START_BIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.s_TX_START_BIT { PARAM_VALUE.s_TX_START_BIT } {
	# Procedure called to validate s_TX_START_BIT
	return true
}

proc update_PARAM_VALUE.s_TX_STOP_BIT { PARAM_VALUE.s_TX_STOP_BIT } {
	# Procedure called to update s_TX_STOP_BIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.s_TX_STOP_BIT { PARAM_VALUE.s_TX_STOP_BIT } {
	# Procedure called to validate s_TX_STOP_BIT
	return true
}


proc update_MODELPARAM_VALUE.CLK_FREQ_FPGA { MODELPARAM_VALUE.CLK_FREQ_FPGA PARAM_VALUE.CLK_FREQ_FPGA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_FREQ_FPGA}] ${MODELPARAM_VALUE.CLK_FREQ_FPGA}
}

proc update_MODELPARAM_VALUE.BAUDRATE { MODELPARAM_VALUE.BAUDRATE PARAM_VALUE.BAUDRATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BAUDRATE}] ${MODELPARAM_VALUE.BAUDRATE}
}

proc update_MODELPARAM_VALUE.CLKS_PER_BIT { MODELPARAM_VALUE.CLKS_PER_BIT PARAM_VALUE.CLKS_PER_BIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKS_PER_BIT}] ${MODELPARAM_VALUE.CLKS_PER_BIT}
}

proc update_MODELPARAM_VALUE.s_IDLE { MODELPARAM_VALUE.s_IDLE PARAM_VALUE.s_IDLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.s_IDLE}] ${MODELPARAM_VALUE.s_IDLE}
}

proc update_MODELPARAM_VALUE.s_TX_START_BIT { MODELPARAM_VALUE.s_TX_START_BIT PARAM_VALUE.s_TX_START_BIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.s_TX_START_BIT}] ${MODELPARAM_VALUE.s_TX_START_BIT}
}

proc update_MODELPARAM_VALUE.s_TX_DATA_BITS { MODELPARAM_VALUE.s_TX_DATA_BITS PARAM_VALUE.s_TX_DATA_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.s_TX_DATA_BITS}] ${MODELPARAM_VALUE.s_TX_DATA_BITS}
}

proc update_MODELPARAM_VALUE.s_TX_STOP_BIT { MODELPARAM_VALUE.s_TX_STOP_BIT PARAM_VALUE.s_TX_STOP_BIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.s_TX_STOP_BIT}] ${MODELPARAM_VALUE.s_TX_STOP_BIT}
}

proc update_MODELPARAM_VALUE.s_CLEANUP { MODELPARAM_VALUE.s_CLEANUP PARAM_VALUE.s_CLEANUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.s_CLEANUP}] ${MODELPARAM_VALUE.s_CLEANUP}
}

