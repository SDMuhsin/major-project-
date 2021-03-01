# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDRDEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADDRESSWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ECOMPSIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EMEMDEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIFODEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HDDW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HDWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ITRWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Kb" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LAYERS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAXITRS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Nb" -parent ${Page_0}
  ipgui::add_param $IPINST -name "P" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIPECOUNTWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIPESTAGES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "P_LAST" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RCU_PIPESTAGES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ROWDEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ROWWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UNLOADCOUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Wabs" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Wc" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Wcbits" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Wt" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Z" -parent ${Page_0}
  ipgui::add_param $IPINST -name "maxVal" -parent ${Page_0}
  ipgui::add_param $IPINST -name "r" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDRDEPTH { PARAM_VALUE.ADDRDEPTH } {
	# Procedure called to update ADDRDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRDEPTH { PARAM_VALUE.ADDRDEPTH } {
	# Procedure called to validate ADDRDEPTH
	return true
}

proc update_PARAM_VALUE.ADDRESSWIDTH { PARAM_VALUE.ADDRESSWIDTH } {
	# Procedure called to update ADDRESSWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESSWIDTH { PARAM_VALUE.ADDRESSWIDTH } {
	# Procedure called to validate ADDRESSWIDTH
	return true
}

proc update_PARAM_VALUE.DW { PARAM_VALUE.DW } {
	# Procedure called to update DW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DW { PARAM_VALUE.DW } {
	# Procedure called to validate DW
	return true
}

proc update_PARAM_VALUE.ECOMPSIZE { PARAM_VALUE.ECOMPSIZE } {
	# Procedure called to update ECOMPSIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ECOMPSIZE { PARAM_VALUE.ECOMPSIZE } {
	# Procedure called to validate ECOMPSIZE
	return true
}

proc update_PARAM_VALUE.EMEMDEPTH { PARAM_VALUE.EMEMDEPTH } {
	# Procedure called to update EMEMDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EMEMDEPTH { PARAM_VALUE.EMEMDEPTH } {
	# Procedure called to validate EMEMDEPTH
	return true
}

proc update_PARAM_VALUE.FIFODEPTH { PARAM_VALUE.FIFODEPTH } {
	# Procedure called to update FIFODEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFODEPTH { PARAM_VALUE.FIFODEPTH } {
	# Procedure called to validate FIFODEPTH
	return true
}

proc update_PARAM_VALUE.HDDW { PARAM_VALUE.HDDW } {
	# Procedure called to update HDDW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HDDW { PARAM_VALUE.HDDW } {
	# Procedure called to validate HDDW
	return true
}

proc update_PARAM_VALUE.HDWIDTH { PARAM_VALUE.HDWIDTH } {
	# Procedure called to update HDWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HDWIDTH { PARAM_VALUE.HDWIDTH } {
	# Procedure called to validate HDWIDTH
	return true
}

proc update_PARAM_VALUE.ITRWIDTH { PARAM_VALUE.ITRWIDTH } {
	# Procedure called to update ITRWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ITRWIDTH { PARAM_VALUE.ITRWIDTH } {
	# Procedure called to validate ITRWIDTH
	return true
}

proc update_PARAM_VALUE.Kb { PARAM_VALUE.Kb } {
	# Procedure called to update Kb when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Kb { PARAM_VALUE.Kb } {
	# Procedure called to validate Kb
	return true
}

proc update_PARAM_VALUE.LAYERS { PARAM_VALUE.LAYERS } {
	# Procedure called to update LAYERS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LAYERS { PARAM_VALUE.LAYERS } {
	# Procedure called to validate LAYERS
	return true
}

proc update_PARAM_VALUE.MAXITRS { PARAM_VALUE.MAXITRS } {
	# Procedure called to update MAXITRS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAXITRS { PARAM_VALUE.MAXITRS } {
	# Procedure called to validate MAXITRS
	return true
}

proc update_PARAM_VALUE.Nb { PARAM_VALUE.Nb } {
	# Procedure called to update Nb when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Nb { PARAM_VALUE.Nb } {
	# Procedure called to validate Nb
	return true
}

proc update_PARAM_VALUE.P { PARAM_VALUE.P } {
	# Procedure called to update P when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.P { PARAM_VALUE.P } {
	# Procedure called to validate P
	return true
}

proc update_PARAM_VALUE.PIPECOUNTWIDTH { PARAM_VALUE.PIPECOUNTWIDTH } {
	# Procedure called to update PIPECOUNTWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIPECOUNTWIDTH { PARAM_VALUE.PIPECOUNTWIDTH } {
	# Procedure called to validate PIPECOUNTWIDTH
	return true
}

proc update_PARAM_VALUE.PIPESTAGES { PARAM_VALUE.PIPESTAGES } {
	# Procedure called to update PIPESTAGES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIPESTAGES { PARAM_VALUE.PIPESTAGES } {
	# Procedure called to validate PIPESTAGES
	return true
}

proc update_PARAM_VALUE.P_LAST { PARAM_VALUE.P_LAST } {
	# Procedure called to update P_LAST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.P_LAST { PARAM_VALUE.P_LAST } {
	# Procedure called to validate P_LAST
	return true
}

proc update_PARAM_VALUE.RCU_PIPESTAGES { PARAM_VALUE.RCU_PIPESTAGES } {
	# Procedure called to update RCU_PIPESTAGES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RCU_PIPESTAGES { PARAM_VALUE.RCU_PIPESTAGES } {
	# Procedure called to validate RCU_PIPESTAGES
	return true
}

proc update_PARAM_VALUE.ROWDEPTH { PARAM_VALUE.ROWDEPTH } {
	# Procedure called to update ROWDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ROWDEPTH { PARAM_VALUE.ROWDEPTH } {
	# Procedure called to validate ROWDEPTH
	return true
}

proc update_PARAM_VALUE.ROWWIDTH { PARAM_VALUE.ROWWIDTH } {
	# Procedure called to update ROWWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ROWWIDTH { PARAM_VALUE.ROWWIDTH } {
	# Procedure called to validate ROWWIDTH
	return true
}

proc update_PARAM_VALUE.UNLOADCOUNT { PARAM_VALUE.UNLOADCOUNT } {
	# Procedure called to update UNLOADCOUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UNLOADCOUNT { PARAM_VALUE.UNLOADCOUNT } {
	# Procedure called to validate UNLOADCOUNT
	return true
}

proc update_PARAM_VALUE.W { PARAM_VALUE.W } {
	# Procedure called to update W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W { PARAM_VALUE.W } {
	# Procedure called to validate W
	return true
}

proc update_PARAM_VALUE.Wabs { PARAM_VALUE.Wabs } {
	# Procedure called to update Wabs when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Wabs { PARAM_VALUE.Wabs } {
	# Procedure called to validate Wabs
	return true
}

proc update_PARAM_VALUE.Wc { PARAM_VALUE.Wc } {
	# Procedure called to update Wc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Wc { PARAM_VALUE.Wc } {
	# Procedure called to validate Wc
	return true
}

proc update_PARAM_VALUE.Wcbits { PARAM_VALUE.Wcbits } {
	# Procedure called to update Wcbits when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Wcbits { PARAM_VALUE.Wcbits } {
	# Procedure called to validate Wcbits
	return true
}

proc update_PARAM_VALUE.Wt { PARAM_VALUE.Wt } {
	# Procedure called to update Wt when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Wt { PARAM_VALUE.Wt } {
	# Procedure called to validate Wt
	return true
}

proc update_PARAM_VALUE.Z { PARAM_VALUE.Z } {
	# Procedure called to update Z when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Z { PARAM_VALUE.Z } {
	# Procedure called to validate Z
	return true
}

proc update_PARAM_VALUE.maxVal { PARAM_VALUE.maxVal } {
	# Procedure called to update maxVal when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.maxVal { PARAM_VALUE.maxVal } {
	# Procedure called to validate maxVal
	return true
}

proc update_PARAM_VALUE.r { PARAM_VALUE.r } {
	# Procedure called to update r when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.r { PARAM_VALUE.r } {
	# Procedure called to validate r
	return true
}


proc update_MODELPARAM_VALUE.W { MODELPARAM_VALUE.W PARAM_VALUE.W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W}] ${MODELPARAM_VALUE.W}
}

proc update_MODELPARAM_VALUE.Nb { MODELPARAM_VALUE.Nb PARAM_VALUE.Nb } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Nb}] ${MODELPARAM_VALUE.Nb}
}

proc update_MODELPARAM_VALUE.Wc { MODELPARAM_VALUE.Wc PARAM_VALUE.Wc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Wc}] ${MODELPARAM_VALUE.Wc}
}

proc update_MODELPARAM_VALUE.Wcbits { MODELPARAM_VALUE.Wcbits PARAM_VALUE.Wcbits } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Wcbits}] ${MODELPARAM_VALUE.Wcbits}
}

proc update_MODELPARAM_VALUE.LAYERS { MODELPARAM_VALUE.LAYERS PARAM_VALUE.LAYERS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LAYERS}] ${MODELPARAM_VALUE.LAYERS}
}

proc update_MODELPARAM_VALUE.ADDRESSWIDTH { MODELPARAM_VALUE.ADDRESSWIDTH PARAM_VALUE.ADDRESSWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESSWIDTH}] ${MODELPARAM_VALUE.ADDRESSWIDTH}
}

proc update_MODELPARAM_VALUE.ADDRDEPTH { MODELPARAM_VALUE.ADDRDEPTH PARAM_VALUE.ADDRDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRDEPTH}] ${MODELPARAM_VALUE.ADDRDEPTH}
}

proc update_MODELPARAM_VALUE.EMEMDEPTH { MODELPARAM_VALUE.EMEMDEPTH PARAM_VALUE.EMEMDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EMEMDEPTH}] ${MODELPARAM_VALUE.EMEMDEPTH}
}

proc update_MODELPARAM_VALUE.Wabs { MODELPARAM_VALUE.Wabs PARAM_VALUE.Wabs } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Wabs}] ${MODELPARAM_VALUE.Wabs}
}

proc update_MODELPARAM_VALUE.ECOMPSIZE { MODELPARAM_VALUE.ECOMPSIZE PARAM_VALUE.ECOMPSIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ECOMPSIZE}] ${MODELPARAM_VALUE.ECOMPSIZE}
}

proc update_MODELPARAM_VALUE.RCU_PIPESTAGES { MODELPARAM_VALUE.RCU_PIPESTAGES PARAM_VALUE.RCU_PIPESTAGES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RCU_PIPESTAGES}] ${MODELPARAM_VALUE.RCU_PIPESTAGES}
}

proc update_MODELPARAM_VALUE.MAXITRS { MODELPARAM_VALUE.MAXITRS PARAM_VALUE.MAXITRS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAXITRS}] ${MODELPARAM_VALUE.MAXITRS}
}

proc update_MODELPARAM_VALUE.ITRWIDTH { MODELPARAM_VALUE.ITRWIDTH PARAM_VALUE.ITRWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ITRWIDTH}] ${MODELPARAM_VALUE.ITRWIDTH}
}

proc update_MODELPARAM_VALUE.Z { MODELPARAM_VALUE.Z PARAM_VALUE.Z } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Z}] ${MODELPARAM_VALUE.Z}
}

proc update_MODELPARAM_VALUE.P { MODELPARAM_VALUE.P PARAM_VALUE.P } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.P}] ${MODELPARAM_VALUE.P}
}

proc update_MODELPARAM_VALUE.PIPESTAGES { MODELPARAM_VALUE.PIPESTAGES PARAM_VALUE.PIPESTAGES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIPESTAGES}] ${MODELPARAM_VALUE.PIPESTAGES}
}

proc update_MODELPARAM_VALUE.PIPECOUNTWIDTH { MODELPARAM_VALUE.PIPECOUNTWIDTH PARAM_VALUE.PIPECOUNTWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIPECOUNTWIDTH}] ${MODELPARAM_VALUE.PIPECOUNTWIDTH}
}

proc update_MODELPARAM_VALUE.ROWDEPTH { MODELPARAM_VALUE.ROWDEPTH PARAM_VALUE.ROWDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ROWDEPTH}] ${MODELPARAM_VALUE.ROWDEPTH}
}

proc update_MODELPARAM_VALUE.ROWWIDTH { MODELPARAM_VALUE.ROWWIDTH PARAM_VALUE.ROWWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ROWWIDTH}] ${MODELPARAM_VALUE.ROWWIDTH}
}

proc update_MODELPARAM_VALUE.P_LAST { MODELPARAM_VALUE.P_LAST PARAM_VALUE.P_LAST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.P_LAST}] ${MODELPARAM_VALUE.P_LAST}
}

proc update_MODELPARAM_VALUE.maxVal { MODELPARAM_VALUE.maxVal PARAM_VALUE.maxVal } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.maxVal}] ${MODELPARAM_VALUE.maxVal}
}

proc update_MODELPARAM_VALUE.Kb { MODELPARAM_VALUE.Kb PARAM_VALUE.Kb } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Kb}] ${MODELPARAM_VALUE.Kb}
}

proc update_MODELPARAM_VALUE.HDWIDTH { MODELPARAM_VALUE.HDWIDTH PARAM_VALUE.HDWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HDWIDTH}] ${MODELPARAM_VALUE.HDWIDTH}
}

proc update_MODELPARAM_VALUE.Wt { MODELPARAM_VALUE.Wt PARAM_VALUE.Wt } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Wt}] ${MODELPARAM_VALUE.Wt}
}

proc update_MODELPARAM_VALUE.r { MODELPARAM_VALUE.r PARAM_VALUE.r } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.r}] ${MODELPARAM_VALUE.r}
}

proc update_MODELPARAM_VALUE.FIFODEPTH { MODELPARAM_VALUE.FIFODEPTH PARAM_VALUE.FIFODEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFODEPTH}] ${MODELPARAM_VALUE.FIFODEPTH}
}

proc update_MODELPARAM_VALUE.DW { MODELPARAM_VALUE.DW PARAM_VALUE.DW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DW}] ${MODELPARAM_VALUE.DW}
}

proc update_MODELPARAM_VALUE.HDDW { MODELPARAM_VALUE.HDDW PARAM_VALUE.HDDW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HDDW}] ${MODELPARAM_VALUE.HDDW}
}

proc update_MODELPARAM_VALUE.UNLOADCOUNT { MODELPARAM_VALUE.UNLOADCOUNT PARAM_VALUE.UNLOADCOUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UNLOADCOUNT}] ${MODELPARAM_VALUE.UNLOADCOUNT}
}

