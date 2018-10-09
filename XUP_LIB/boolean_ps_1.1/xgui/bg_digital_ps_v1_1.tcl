# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Digital_Input [ipgui::add_page $IPINST -name "Digital Input" -display_name {Digital Logic}]
  set_property tooltip {Digital Logic} ${Digital_Input}
  ipgui::add_param $IPINST -name "Num_Digital_Input" -parent ${Digital_Input}
  ipgui::add_param $IPINST -name "Num_Digital_Output" -parent ${Digital_Input}

  #Adding Page
  set Boolean_Logic [ipgui::add_page $IPINST -name "Boolean Logic"]
  ipgui::add_param $IPINST -name "Num_BG_Output" -parent ${Boolean_Logic}

  #Adding Page
  set Free_Running_Clock [ipgui::add_page $IPINST -name "Free Running Clock"]
  ipgui::add_param $IPINST -name "Clk_Present" -parent ${Free_Running_Clock}
  ipgui::add_param $IPINST -name "Reset_N_Present" -parent ${Free_Running_Clock}

  ipgui::add_static_text $IPINST -name "Digital Logic Section" -text {}

}

proc update_PARAM_VALUE.Clk_Present { PARAM_VALUE.Clk_Present } {
	# Procedure called to update Clk_Present when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Clk_Present { PARAM_VALUE.Clk_Present } {
	# Procedure called to validate Clk_Present
	return true
}

proc update_PARAM_VALUE.DDR_Present { PARAM_VALUE.DDR_Present } {
	# Procedure called to update DDR_Present when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DDR_Present { PARAM_VALUE.DDR_Present } {
	# Procedure called to validate DDR_Present
	return true
}

proc update_PARAM_VALUE.FIXED_IO_Present { PARAM_VALUE.FIXED_IO_Present } {
	# Procedure called to update FIXED_IO_Present when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIXED_IO_Present { PARAM_VALUE.FIXED_IO_Present } {
	# Procedure called to validate FIXED_IO_Present
	return true
}

proc update_PARAM_VALUE.Num_BG_Output { PARAM_VALUE.Num_BG_Output } {
	# Procedure called to update Num_BG_Output when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Num_BG_Output { PARAM_VALUE.Num_BG_Output } {
	# Procedure called to validate Num_BG_Output
	return true
}

proc update_PARAM_VALUE.Num_Digital_Input { PARAM_VALUE.Num_Digital_Input } {
	# Procedure called to update Num_Digital_Input when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Num_Digital_Input { PARAM_VALUE.Num_Digital_Input } {
	# Procedure called to validate Num_Digital_Input
	return true
}

proc update_PARAM_VALUE.Num_Digital_Output { PARAM_VALUE.Num_Digital_Output } {
	# Procedure called to update Num_Digital_Output when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Num_Digital_Output { PARAM_VALUE.Num_Digital_Output } {
	# Procedure called to validate Num_Digital_Output
	return true
}

proc update_PARAM_VALUE.Reset_N_Present { PARAM_VALUE.Reset_N_Present } {
	# Procedure called to update Reset_N_Present when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Reset_N_Present { PARAM_VALUE.Reset_N_Present } {
	# Procedure called to validate Reset_N_Present
	return true
}


