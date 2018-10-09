# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Digital_Logic [ipgui::add_page $IPINST -name "Digital Logic"]
  ipgui::add_param $IPINST -name "Num_Input" -parent ${Digital_Logic}
  ipgui::add_param $IPINST -name "Num_Output" -parent ${Digital_Logic}

  #Adding Page
  set Free_Running_Clock [ipgui::add_page $IPINST -name "Free Running Clock"]
  ipgui::add_param $IPINST -name "CLK_Present" -parent ${Free_Running_Clock}
  ipgui::add_param $IPINST -name "Reset_n_Present" -parent ${Free_Running_Clock}


}

proc update_PARAM_VALUE.CLK_Present { PARAM_VALUE.CLK_Present } {
	# Procedure called to update CLK_Present when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_Present { PARAM_VALUE.CLK_Present } {
	# Procedure called to validate CLK_Present
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

proc update_PARAM_VALUE.Num_Input { PARAM_VALUE.Num_Input } {
	# Procedure called to update Num_Input when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Num_Input { PARAM_VALUE.Num_Input } {
	# Procedure called to validate Num_Input
	return true
}

proc update_PARAM_VALUE.Num_Output { PARAM_VALUE.Num_Output } {
	# Procedure called to update Num_Output when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Num_Output { PARAM_VALUE.Num_Output } {
	# Procedure called to validate Num_Output
	return true
}

proc update_PARAM_VALUE.Reset_n_Present { PARAM_VALUE.Reset_n_Present } {
	# Procedure called to update Reset_n_Present when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Reset_n_Present { PARAM_VALUE.Reset_n_Present } {
	# Procedure called to validate Reset_n_Present
	return true
}


