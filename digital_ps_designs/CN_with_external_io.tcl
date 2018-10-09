
################################################################
# This is a generated script based on design: CN_with_external_io
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
# source CN_with_external_io_script.tcl

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
set design_name CN_with_external_io

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
xilinx.com:ip:digital_ps:1.1\
xilinx.com:ip:xup_2_to_1_mux:1.1\
xilinx.com:ip:xup_inv:1.1\
xilinx.com:ip:xup_or2:1.1\
xilinx.com:ip:xup_and2:1.1\
xilinx.com:ip:xup_or3:1.1\
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


# Hierarchical cell: minority_gate
proc create_hier_cell_minority_gate { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_minority_gate() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I a
  create_bd_pin -dir I a0
  create_bd_pin -dir I a1
  create_bd_pin -dir O y

  # Create instance: xup_and2_0, and set properties
  set xup_and2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 xup_and2_0 ]

  # Create instance: xup_and2_1, and set properties
  set xup_and2_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 xup_and2_1 ]

  # Create instance: xup_and2_2, and set properties
  set xup_and2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 xup_and2_2 ]

  # Create instance: xup_inv_0, and set properties
  set xup_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_0 ]

  # Create instance: xup_inv_1, and set properties
  set xup_inv_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_1 ]

  # Create instance: xup_inv_2, and set properties
  set xup_inv_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_2 ]

  # Create instance: xup_or3_0, and set properties
  set xup_or3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or3:1.1 xup_or3_0 ]

  # Create port connections
  connect_bd_net -net a_1 [get_bd_pins a] [get_bd_pins xup_inv_2/a]
  connect_bd_net -net digital_ps_0_Dout_0 [get_bd_pins a0] [get_bd_pins xup_inv_0/a]
  connect_bd_net -net digital_ps_0_Dout_1 [get_bd_pins a1] [get_bd_pins xup_inv_1/a]
  connect_bd_net -net xup_and2_0_y [get_bd_pins xup_and2_0/y] [get_bd_pins xup_or3_0/a]
  connect_bd_net -net xup_and2_1_y [get_bd_pins xup_and2_1/y] [get_bd_pins xup_or3_0/b]
  connect_bd_net -net xup_and2_2_y [get_bd_pins xup_and2_2/y] [get_bd_pins xup_or3_0/c]
  connect_bd_net -net xup_inv_0_y [get_bd_pins xup_and2_0/a] [get_bd_pins xup_and2_1/a] [get_bd_pins xup_inv_0/y]
  connect_bd_net -net xup_inv_1_y [get_bd_pins xup_and2_0/b] [get_bd_pins xup_and2_2/a] [get_bd_pins xup_inv_1/y]
  connect_bd_net -net xup_inv_2_y [get_bd_pins xup_and2_1/b] [get_bd_pins xup_and2_2/b] [get_bd_pins xup_inv_2/y]
  connect_bd_net -net xup_or3_0_y [get_bd_pins y] [get_bd_pins xup_or3_0/y]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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

  # Create ports
  set a_0 [ create_bd_port -dir I a_0 ]
  set b_0 [ create_bd_port -dir I b_0 ]
  set minority_led [ create_bd_port -dir O minority_led ]

  # Create instance: digital_ps_0, and set properties
  set digital_ps_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:digital_ps:1.1 digital_ps_0 ]
  set_property -dict [ list \
   CONFIG.Num_Input {1} \
   CONFIG.Num_Output {4} \
 ] $digital_ps_0

  # Create instance: minority_gate
  create_hier_cell_minority_gate [current_bd_instance .] minority_gate

  # Create instance: xup_2_to_1_mux_0, and set properties
  set xup_2_to_1_mux_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_2_to_1_mux:1.1 xup_2_to_1_mux_0 ]

  # Create instance: xup_inv_0, and set properties
  set xup_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_0 ]

  # Create instance: xup_or2_0, and set properties
  set xup_or2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or2:1.1 xup_or2_0 ]

  # Create port connections
  connect_bd_net -net a_0_1 [get_bd_ports a_0] [get_bd_pins xup_or2_0/a]
  connect_bd_net -net b_0_1 [get_bd_ports b_0] [get_bd_pins xup_or2_0/b]
  connect_bd_net -net digital_ps_0_Dout_0 [get_bd_pins digital_ps_0/Dout_00] [get_bd_pins minority_gate/a0]
  connect_bd_net -net digital_ps_0_Dout_1 [get_bd_pins digital_ps_0/Dout_01] [get_bd_pins minority_gate/a1]
  connect_bd_net -net digital_ps_0_Dout_02 [get_bd_pins digital_ps_0/Dout_02] [get_bd_pins xup_2_to_1_mux_0/a]
  connect_bd_net -net digital_ps_0_Dout_03 [get_bd_pins digital_ps_0/Dout_03] [get_bd_pins xup_2_to_1_mux_0/sel]
  connect_bd_net -net minority_gate_y [get_bd_pins digital_ps_0/Din_00] [get_bd_pins minority_gate/y] [get_bd_pins xup_inv_0/a]
  connect_bd_net -net xup_2_to_1_mux_0_y [get_bd_pins minority_gate/a] [get_bd_pins xup_2_to_1_mux_0/y]
  connect_bd_net -net xup_inv_0_y [get_bd_ports minority_led] [get_bd_pins xup_inv_0/y]
  connect_bd_net -net xup_or2_0_y [get_bd_pins xup_2_to_1_mux_0/b] [get_bd_pins xup_or2_0/y]

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


