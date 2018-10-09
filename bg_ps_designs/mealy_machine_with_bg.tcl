
################################################################
# This is a generated script based on design: mealy_detector
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
# source mealy_detector_script.tcl

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
set design_name mealy_detector

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
xilinx.com:ip:bg_digital_ps:1.1\
xilinx.com:ip:xup_inv:1.1\
xilinx.com:ip:xup_dff_en_reset:1.1\
xilinx.com:ip:xup_and2:1.1\
xilinx.com:ip:xup_or3:1.1\
xilinx.com:ip:xup_and3:1.1\
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


# Hierarchical cell: d3
proc create_hier_cell_d3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_d3() - Empty argument(s)!"}
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
  create_bd_pin -dir O D3
  create_bd_pin -dir I Q1
  create_bd_pin -dir I Q1_n
  create_bd_pin -dir I Q2
  create_bd_pin -dir I Q3
  create_bd_pin -dir I ain
  create_bd_pin -dir I ain_n

  # Create instance: and2_5, and set properties
  set and2_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 and2_5 ]

  # Create instance: and2_6, and set properties
  set and2_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 and2_6 ]

  # Create instance: or3_2, and set properties
  set or3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or3:1.1 or3_2 ]

  # Create instance: xup_and3_0, and set properties
  set xup_and3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_0 ]

  # Create port connections
  connect_bd_net -net DFF_Q1_q [get_bd_pins Q1] [get_bd_pins xup_and3_0/c]
  connect_bd_net -net DFF_Q3_q [get_bd_pins Q3] [get_bd_pins and2_5/b] [get_bd_pins and2_6/a]
  connect_bd_net -net Q2_1 [get_bd_pins Q2] [get_bd_pins xup_and3_0/b]
  connect_bd_net -net Q3_n_1 [get_bd_pins Q1_n] [get_bd_pins and2_6/b]
  connect_bd_net -net ain_n_y [get_bd_pins ain_n] [get_bd_pins and2_5/a]
  connect_bd_net -net and2_5_y [get_bd_pins and2_5/y] [get_bd_pins or3_2/b]
  connect_bd_net -net and2_6_y [get_bd_pins and2_6/y] [get_bd_pins or3_2/c]
  connect_bd_net -net bg_digital_ps_0_Dout_03 [get_bd_pins ain] [get_bd_pins xup_and3_0/a]
  connect_bd_net -net or3_2_y [get_bd_pins D3] [get_bd_pins or3_2/y]
  connect_bd_net -net xup_and3_0_y [get_bd_pins or3_2/a] [get_bd_pins xup_and3_0/y]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: d2
proc create_hier_cell_d2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_d2() - Empty argument(s)!"}
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
  create_bd_pin -dir O D2
  create_bd_pin -dir I Q1
  create_bd_pin -dir I Q1_n
  create_bd_pin -dir I Q2
  create_bd_pin -dir I Q2_n
  create_bd_pin -dir I ain
  create_bd_pin -dir I ain_n

  # Create instance: and2_2, and set properties
  set and2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 and2_2 ]

  # Create instance: and2_3, and set properties
  set and2_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 and2_3 ]

  # Create instance: and3_1, and set properties
  set and3_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 and3_1 ]

  # Create instance: or3_1, and set properties
  set or3_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or3:1.1 or3_1 ]

  # Create port connections
  connect_bd_net -net DFF_Q2_q [get_bd_pins Q2] [get_bd_pins and2_2/a] [get_bd_pins and2_3/a]
  connect_bd_net -net DFF_Q3_q [get_bd_pins Q1] [get_bd_pins and3_1/c]
  connect_bd_net -net Q2_n_y [get_bd_pins Q2_n] [get_bd_pins and3_1/b]
  connect_bd_net -net Q3_n_y [get_bd_pins Q1_n] [get_bd_pins and2_2/b]
  connect_bd_net -net ain_n_y [get_bd_pins ain_n] [get_bd_pins and2_3/b]
  connect_bd_net -net and2_2_y [get_bd_pins and2_2/y] [get_bd_pins or3_1/a]
  connect_bd_net -net and2_3_y [get_bd_pins and2_3/y] [get_bd_pins or3_1/b]
  connect_bd_net -net and3_1_y [get_bd_pins and3_1/y] [get_bd_pins or3_1/c]
  connect_bd_net -net bg_digital_ps_0_Dout_03 [get_bd_pins ain] [get_bd_pins and3_1/a]
  connect_bd_net -net or3_1_y [get_bd_pins D2] [get_bd_pins or3_1/y]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: d1
proc create_hier_cell_d1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_d1() - Empty argument(s)!"}
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
  create_bd_pin -dir O D1
  create_bd_pin -dir I Q1
  create_bd_pin -dir I Q1_n
  create_bd_pin -dir I Q3
  create_bd_pin -dir I ain
  create_bd_pin -dir I ain_n

  # Create instance: and2_0, and set properties
  set and2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 and2_0 ]

  # Create instance: and2_1, and set properties
  set and2_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 and2_1 ]

  # Create instance: and2_2, and set properties
  set and2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 and2_2 ]

  # Create instance: or3_0, and set properties
  set or3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or3:1.1 or3_0 ]

  # Create port connections
  connect_bd_net -net DFF_Q1_q [get_bd_pins Q1] [get_bd_pins and2_0/b]
  connect_bd_net -net DFF_Q3_q [get_bd_pins Q3] [get_bd_pins and2_2/b]
  connect_bd_net -net Q3_n_y [get_bd_pins Q1_n] [get_bd_pins and2_1/b]
  connect_bd_net -net ain_n_y [get_bd_pins ain_n] [get_bd_pins and2_0/a]
  connect_bd_net -net and2_0_y [get_bd_pins and2_0/y] [get_bd_pins or3_0/a]
  connect_bd_net -net and2_1_y [get_bd_pins and2_1/y] [get_bd_pins or3_0/b]
  connect_bd_net -net and2_2_y [get_bd_pins and2_2/y] [get_bd_pins or3_0/c]
  connect_bd_net -net bg_digital_ps_0_Dout_03 [get_bd_pins ain] [get_bd_pins and2_1/a] [get_bd_pins and2_2/a]
  connect_bd_net -net or3_0_y [get_bd_pins D1] [get_bd_pins or3_0/y]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: PS
proc create_hier_cell_PS { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_PS() - Empty argument(s)!"}
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
  create_bd_pin -dir I D1
  create_bd_pin -dir I D2
  create_bd_pin -dir I D3
  create_bd_pin -dir O Q1
  create_bd_pin -dir O Q2
  create_bd_pin -dir O Q3
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I en
  create_bd_pin -dir I -type rst reset

  # Create instance: DFF_Q1, and set properties
  set DFF_Q1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_dff_en_reset:1.1 DFF_Q1 ]

  # Create instance: DFF_Q2, and set properties
  set DFF_Q2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_dff_en_reset:1.1 DFF_Q2 ]

  # Create instance: DFF_Q3, and set properties
  set DFF_Q3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_dff_en_reset:1.1 DFF_Q3 ]

  # Create port connections
  connect_bd_net -net DFF_Q1_q [get_bd_pins Q1] [get_bd_pins DFF_Q1/q]
  connect_bd_net -net DFF_Q2_q [get_bd_pins Q2] [get_bd_pins DFF_Q2/q]
  connect_bd_net -net DFF_Q3_q [get_bd_pins Q3] [get_bd_pins DFF_Q3/q]
  connect_bd_net -net bg_digital_ps_0_Dout_00 [get_bd_pins clk] [get_bd_pins DFF_Q1/clk] [get_bd_pins DFF_Q2/clk] [get_bd_pins DFF_Q3/clk]
  connect_bd_net -net bg_digital_ps_0_Dout_01 [get_bd_pins en] [get_bd_pins DFF_Q1/en] [get_bd_pins DFF_Q2/en] [get_bd_pins DFF_Q3/en]
  connect_bd_net -net bg_digital_ps_0_Dout_02 [get_bd_pins reset] [get_bd_pins DFF_Q1/reset] [get_bd_pins DFF_Q2/reset] [get_bd_pins DFF_Q3/reset]
  connect_bd_net -net d1_D1 [get_bd_pins D1] [get_bd_pins DFF_Q1/d]
  connect_bd_net -net d2_D2 [get_bd_pins D2] [get_bd_pins DFF_Q2/d]
  connect_bd_net -net d3_D3 [get_bd_pins D3] [get_bd_pins DFF_Q3/d]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NS
proc create_hier_cell_NS { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_NS() - Empty argument(s)!"}
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
  create_bd_pin -dir O D1
  create_bd_pin -dir O D2
  create_bd_pin -dir O D3
  create_bd_pin -dir I Q1
  create_bd_pin -dir I Q2
  create_bd_pin -dir I Q3
  create_bd_pin -dir O Q3_n
  create_bd_pin -dir I ain
  create_bd_pin -dir I reset
  create_bd_pin -dir O reset_n

  # Create instance: Q1_n, and set properties
  set Q1_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 Q1_n ]

  # Create instance: Q2_n, and set properties
  set Q2_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 Q2_n ]

  # Create instance: Q3_n, and set properties
  set Q3_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 Q3_n ]

  # Create instance: ain_n, and set properties
  set ain_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 ain_n ]

  # Create instance: d1
  create_hier_cell_d1 $hier_obj d1

  # Create instance: d2
  create_hier_cell_d2 $hier_obj d2

  # Create instance: d3
  create_hier_cell_d3 $hier_obj d3

  # Create instance: reset_n, and set properties
  set reset_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 reset_n ]

  # Create port connections
  connect_bd_net -net DFF_Q1_q [get_bd_pins Q1] [get_bd_pins Q1_n/a] [get_bd_pins d1/Q1] [get_bd_pins d2/Q1] [get_bd_pins d3/Q1]
  connect_bd_net -net DFF_Q2_q [get_bd_pins Q2] [get_bd_pins Q2_n/a] [get_bd_pins d2/Q2] [get_bd_pins d3/Q2]
  connect_bd_net -net DFF_Q3_q [get_bd_pins Q3] [get_bd_pins Q3_n/a] [get_bd_pins d1/Q3] [get_bd_pins d3/Q3]
  connect_bd_net -net Q1_n_y [get_bd_pins Q1_n/y] [get_bd_pins d1/Q1_n] [get_bd_pins d2/Q1_n] [get_bd_pins d3/Q1_n]
  connect_bd_net -net Q2_n_y [get_bd_pins Q2_n/y] [get_bd_pins d2/Q2_n]
  connect_bd_net -net Q3_n_y [get_bd_pins Q3_n] [get_bd_pins Q3_n/y]
  connect_bd_net -net ain_n_y [get_bd_pins ain_n/y] [get_bd_pins d1/ain_n] [get_bd_pins d2/ain_n] [get_bd_pins d3/ain_n]
  connect_bd_net -net bg_digital_ps_0_Dout_02 [get_bd_pins reset] [get_bd_pins reset_n/a]
  connect_bd_net -net bg_digital_ps_0_Dout_03 [get_bd_pins ain] [get_bd_pins ain_n/a] [get_bd_pins d1/ain] [get_bd_pins d2/ain] [get_bd_pins d3/ain]
  connect_bd_net -net d1_D1 [get_bd_pins D1] [get_bd_pins d1/D1]
  connect_bd_net -net d2_D2 [get_bd_pins D2] [get_bd_pins d2/D2]
  connect_bd_net -net d3_D3 [get_bd_pins D3] [get_bd_pins d3/D3]
  connect_bd_net -net reset_n_y [get_bd_pins reset_n] [get_bd_pins reset_n/y]

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

  # Create instance: NS
  create_hier_cell_NS [current_bd_instance .] NS

  # Create instance: PS
  create_hier_cell_PS [current_bd_instance .] PS

  # Create instance: bg_digital_ps_0, and set properties
  set bg_digital_ps_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bg_digital_ps:1.1 bg_digital_ps_0 ]
  set_property -dict [ list \
   CONFIG.Num_BG_Output {1} \
   CONFIG.Num_Digital_Input {1} \
   CONFIG.Num_Digital_Output {4} \
 ] $bg_digital_ps_0

  # Create port connections
  connect_bd_net -net DFF_Q1_q [get_bd_pins NS/Q1] [get_bd_pins PS/Q1] [get_bd_pins bg_digital_ps_0/BGin_02]
  connect_bd_net -net DFF_Q2_q [get_bd_pins NS/Q2] [get_bd_pins PS/Q2] [get_bd_pins bg_digital_ps_0/BGin_01]
  connect_bd_net -net DFF_Q3_q [get_bd_pins NS/Q3] [get_bd_pins PS/Q3]
  connect_bd_net -net NS_Q3_n [get_bd_pins NS/Q3_n] [get_bd_pins bg_digital_ps_0/BGin_03]
  connect_bd_net -net NS_reset_n [get_bd_pins NS/reset_n] [get_bd_pins bg_digital_ps_0/BGin_00]
  connect_bd_net -net bg_digital_ps_0_BGout_00 [get_bd_pins bg_digital_ps_0/BGout_00] [get_bd_pins bg_digital_ps_0/Din_00]
  connect_bd_net -net bg_digital_ps_0_Dout_00 [get_bd_pins PS/clk] [get_bd_pins bg_digital_ps_0/Dout_00]
  connect_bd_net -net bg_digital_ps_0_Dout_02 [get_bd_pins NS/reset] [get_bd_pins PS/reset] [get_bd_pins bg_digital_ps_0/Dout_01]
  connect_bd_net -net bg_digital_ps_0_Dout_2 [get_bd_pins PS/en] [get_bd_pins bg_digital_ps_0/Dout_02]
  connect_bd_net -net bg_digital_ps_0_Dout_03 [get_bd_pins NS/ain] [get_bd_pins bg_digital_ps_0/BGin_04] [get_bd_pins bg_digital_ps_0/Dout_03]
  connect_bd_net -net d1_D1 [get_bd_pins NS/D1] [get_bd_pins PS/D1]
  connect_bd_net -net d2_D2 [get_bd_pins NS/D2] [get_bd_pins PS/D2]
  connect_bd_net -net d3_D3 [get_bd_pins NS/D3] [get_bd_pins PS/D3]

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


