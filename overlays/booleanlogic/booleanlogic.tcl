
################################################################
# This is a generated script based on design: boolean_system
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
set scripts_vivado_version 2018.2
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
# source boolean_system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART www.digilentinc.com:pynq-z1:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name boolean_system

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

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:boolean_ps:1.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xup_inv:1.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
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
  set DDR_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR_0 ]
  set FIXED_IO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO_0 ]

  # Create ports

  # Create instance: boolean_ps_0, and set properties
  set boolean_ps_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:boolean_ps:1.1 boolean_ps_0 ]
  set_property -dict [ list \
   CONFIG.Din_10_Present {true} \
   CONFIG.Din_11_Present {true} \
   CONFIG.Din_12_Present {true} \
   CONFIG.Din_13_Present {true} \
   CONFIG.Din_14_Present {true} \
   CONFIG.Din_15_Present {true} \
   CONFIG.Din_24_Present {true} \
   CONFIG.Din_25_Present {true} \
   CONFIG.Din_26_Present {true} \
   CONFIG.Din_27_Present {true} \
   CONFIG.Din_28_Present {true} \
   CONFIG.Din_29_Present {true} \
   CONFIG.Din_30_Present {true} \
   CONFIG.Din_31_Present {true} \
   CONFIG.Din_8_Present {true} \
   CONFIG.Din_9_Present {true} \
   CONFIG.Dout_0_Present {false} \
   CONFIG.Dout_1_Present {false} \
   CONFIG.Dout_2_Present {false} \
   CONFIG.Dout_3_Present {false} \
   CONFIG.Dout_7_Present {true} \
   CONFIG.GR_15_8_Present {true} \
   CONFIG.GR_31_24_Present {true} \
   CONFIG.GR_47_40_Present {true} \
   CONFIG.GR_63_56_Present {true} \
   CONFIG.GR_7_0_Present {true} \
 ] $boolean_ps_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_8bit, and set properties
  set xlconstant_8bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_8bit ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_8bit

  # Create instance: xup_inv_0, and set properties
  set xup_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net boolean_ps_0_DDR [get_bd_intf_ports DDR_0] [get_bd_intf_pins boolean_ps_0/DDR]
  connect_bd_intf_net -intf_net boolean_ps_0_FIXED_IO [get_bd_intf_ports FIXED_IO_0] [get_bd_intf_pins boolean_ps_0/FIXED_IO]

  # Create port connections
  connect_bd_net -net boolean_ps_0_Dout_7 [get_bd_pins boolean_ps_0/Dout_7] [get_bd_pins xup_inv_0/a]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins boolean_ps_0/Din_8] [get_bd_pins boolean_ps_0/Din_9] [get_bd_pins boolean_ps_0/Din_10] [get_bd_pins boolean_ps_0/Din_11] [get_bd_pins boolean_ps_0/Din_12] [get_bd_pins boolean_ps_0/Din_13] [get_bd_pins boolean_ps_0/Din_14] [get_bd_pins boolean_ps_0/Din_24] [get_bd_pins boolean_ps_0/Din_25] [get_bd_pins boolean_ps_0/Din_26] [get_bd_pins boolean_ps_0/Din_27] [get_bd_pins boolean_ps_0/Din_28] [get_bd_pins boolean_ps_0/Din_29] [get_bd_pins boolean_ps_0/Din_30] [get_bd_pins boolean_ps_0/Din_31] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_8bit_dout [get_bd_pins boolean_ps_0/Din_47_40] [get_bd_pins boolean_ps_0/Din_63_56] [get_bd_pins xlconstant_8bit/dout]
  connect_bd_net -net xup_inv_0_y [get_bd_pins boolean_ps_0/Din_15] [get_bd_pins xup_inv_0/y]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


