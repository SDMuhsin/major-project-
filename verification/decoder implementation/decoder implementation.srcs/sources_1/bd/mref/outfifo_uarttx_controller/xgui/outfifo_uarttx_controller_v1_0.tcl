# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BAUDRATE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLK_FREQ_FPGA" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLRREAD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INIT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TXMIT2" -parent ${Page_0}


}

proc update_PARAM_VALUE.BAUDRATE { PARAM_VALUE.BAUDRATE } {
	# Procedure called to update BAUDRATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAUDRATE { PARAM_VALUE.BAUDRATE } {
	# Procedure called to validate BAUDRATE
	return true
}

proc update_PARAM_VALUE.CLK_FREQ_FPGA { PARAM_VALUE.CLK_FREQ_FPGA } {
	# Procedure called to update CLK_FREQ_FPGA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_FREQ_FPGA { PARAM_VALUE.CLK_FREQ_FPGA } {
	# Procedure called to validate CLK_FREQ_FPGA
	return true
}

proc update_PARAM_VALUE.CLRREAD { PARAM_VALUE.CLRREAD } {
	# Procedure called to update CLRREAD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLRREAD { PARAM_VALUE.CLRREAD } {
	# Procedure called to validate CLRREAD
	return true
}

proc update_PARAM_VALUE.INIT { PARAM_VALUE.INIT } {
	# Procedure called to update INIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INIT { PARAM_VALUE.INIT } {
	# Procedure called to validate INIT
	return true
}

proc update_PARAM_VALUE.TXMIT2 { PARAM_VALUE.TXMIT2 } {
	# Procedure called to update TXMIT2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TXMIT2 { PARAM_VALUE.TXMIT2 } {
	# Procedure called to validate TXMIT2
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

proc update_MODELPARAM_VALUE.INIT { MODELPARAM_VALUE.INIT PARAM_VALUE.INIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INIT}] ${MODELPARAM_VALUE.INIT}
}

proc update_MODELPARAM_VALUE.CLRREAD { MODELPARAM_VALUE.CLRREAD PARAM_VALUE.CLRREAD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLRREAD}] ${MODELPARAM_VALUE.CLRREAD}
}

proc update_MODELPARAM_VALUE.TXMIT2 { MODELPARAM_VALUE.TXMIT2 PARAM_VALUE.TXMIT2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TXMIT2}] ${MODELPARAM_VALUE.TXMIT2}
}

