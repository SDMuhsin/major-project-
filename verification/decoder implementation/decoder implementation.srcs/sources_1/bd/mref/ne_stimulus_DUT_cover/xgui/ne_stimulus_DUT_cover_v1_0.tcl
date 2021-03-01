# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDRESSWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HDDW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "READDEFAULTCASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Wc" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDRESSWIDTH { PARAM_VALUE.ADDRESSWIDTH } {
	# Procedure called to update ADDRESSWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESSWIDTH { PARAM_VALUE.ADDRESSWIDTH } {
	# Procedure called to validate ADDRESSWIDTH
	return true
}

proc update_PARAM_VALUE.DEPTH { PARAM_VALUE.DEPTH } {
	# Procedure called to update DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEPTH { PARAM_VALUE.DEPTH } {
	# Procedure called to validate DEPTH
	return true
}

proc update_PARAM_VALUE.DW { PARAM_VALUE.DW } {
	# Procedure called to update DW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DW { PARAM_VALUE.DW } {
	# Procedure called to validate DW
	return true
}

proc update_PARAM_VALUE.HDDW { PARAM_VALUE.HDDW } {
	# Procedure called to update HDDW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HDDW { PARAM_VALUE.HDDW } {
	# Procedure called to validate HDDW
	return true
}

proc update_PARAM_VALUE.READDEFAULTCASE { PARAM_VALUE.READDEFAULTCASE } {
	# Procedure called to update READDEFAULTCASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READDEFAULTCASE { PARAM_VALUE.READDEFAULTCASE } {
	# Procedure called to validate READDEFAULTCASE
	return true
}

proc update_PARAM_VALUE.W { PARAM_VALUE.W } {
	# Procedure called to update W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W { PARAM_VALUE.W } {
	# Procedure called to validate W
	return true
}

proc update_PARAM_VALUE.Wc { PARAM_VALUE.Wc } {
	# Procedure called to update Wc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Wc { PARAM_VALUE.Wc } {
	# Procedure called to validate Wc
	return true
}


proc update_MODELPARAM_VALUE.W { MODELPARAM_VALUE.W PARAM_VALUE.W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W}] ${MODELPARAM_VALUE.W}
}

proc update_MODELPARAM_VALUE.Wc { MODELPARAM_VALUE.Wc PARAM_VALUE.Wc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Wc}] ${MODELPARAM_VALUE.Wc}
}

proc update_MODELPARAM_VALUE.HDDW { MODELPARAM_VALUE.HDDW PARAM_VALUE.HDDW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HDDW}] ${MODELPARAM_VALUE.HDDW}
}

proc update_MODELPARAM_VALUE.DEPTH { MODELPARAM_VALUE.DEPTH PARAM_VALUE.DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEPTH}] ${MODELPARAM_VALUE.DEPTH}
}

proc update_MODELPARAM_VALUE.ADDRESSWIDTH { MODELPARAM_VALUE.ADDRESSWIDTH PARAM_VALUE.ADDRESSWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESSWIDTH}] ${MODELPARAM_VALUE.ADDRESSWIDTH}
}

proc update_MODELPARAM_VALUE.DW { MODELPARAM_VALUE.DW PARAM_VALUE.DW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DW}] ${MODELPARAM_VALUE.DW}
}

proc update_MODELPARAM_VALUE.READDEFAULTCASE { MODELPARAM_VALUE.READDEFAULTCASE PARAM_VALUE.READDEFAULTCASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.READDEFAULTCASE}] ${MODELPARAM_VALUE.READDEFAULTCASE}
}

