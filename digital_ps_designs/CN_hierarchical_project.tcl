
################################################################
# This is a generated script based on design: CN_design
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
# source CN_design_script.tcl

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
set design_name CN_design

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
xilinx.com:ip:xup_and3:1.1\
xilinx.com:ip:xup_inv:1.1\
xilinx.com:ip:xup_and2:1.1\
xilinx.com:ip:xup_or3:1.1\
xilinx.com:ip:xup_and4:1.1\
xilinx.com:ip:xup_and5:1.1\
xilinx.com:ip:xup_and6:1.1\
xilinx.com:ip:xup_or4:1.1\
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


# Hierarchical cell: priority_encoder
proc create_hier_cell_priority_encoder { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_priority_encoder() - Empty argument(s)!"}
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
  create_bd_pin -dir I a0
  create_bd_pin -dir I a1
  create_bd_pin -dir I a2
  create_bd_pin -dir I a3
  create_bd_pin -dir I a4
  create_bd_pin -dir I a5
  create_bd_pin -dir I a6
  create_bd_pin -dir O y0
  create_bd_pin -dir O y1
  create_bd_pin -dir O y2
  create_bd_pin -dir O y3

  # Create instance: xup_and2_0, and set properties
  set xup_and2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 xup_and2_0 ]

  # Create instance: xup_and2_1, and set properties
  set xup_and2_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and2:1.1 xup_and2_1 ]

  # Create instance: xup_and3_0, and set properties
  set xup_and3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_0 ]

  # Create instance: xup_and4_0, and set properties
  set xup_and4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and4:1.1 xup_and4_0 ]

  # Create instance: xup_and5_0, and set properties
  set xup_and5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and5:1.1 xup_and5_0 ]

  # Create instance: xup_and6_0, and set properties
  set xup_and6_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and6:1.1 xup_and6_0 ]

  # Create instance: xup_and6_1, and set properties
  set xup_and6_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and6:1.1 xup_and6_1 ]

  # Create instance: xup_inv_0, and set properties
  set xup_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_0 ]

  # Create instance: xup_inv_1, and set properties
  set xup_inv_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_1 ]

  # Create instance: xup_inv_2, and set properties
  set xup_inv_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_2 ]

  # Create instance: xup_inv_3, and set properties
  set xup_inv_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_3 ]

  # Create instance: xup_inv_4, and set properties
  set xup_inv_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_4 ]

  # Create instance: xup_inv_5, and set properties
  set xup_inv_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_5 ]

  # Create instance: xup_or3_0, and set properties
  set xup_or3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or3:1.1 xup_or3_0 ]

  # Create instance: xup_or4_0, and set properties
  set xup_or4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or4:1.1 xup_or4_0 ]

  # Create instance: xup_or4_1, and set properties
  set xup_or4_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or4:1.1 xup_or4_1 ]

  # Create instance: xup_or4_2, and set properties
  set xup_or4_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_or4:1.1 xup_or4_2 ]

  # Create port connections
  connect_bd_net -net b_1 [get_bd_pins a6] [get_bd_pins xup_and2_1/b]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins a0] [get_bd_pins xup_inv_0/a] [get_bd_pins xup_or4_0/a] [get_bd_pins xup_or4_1/a] [get_bd_pins xup_or4_2/a]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins a1] [get_bd_pins xup_and2_0/a] [get_bd_pins xup_inv_1/a]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins a2] [get_bd_pins xup_and3_0/a] [get_bd_pins xup_inv_2/a]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins a3] [get_bd_pins xup_and4_0/a] [get_bd_pins xup_inv_3/a]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins a4] [get_bd_pins xup_and5_0/a] [get_bd_pins xup_inv_4/a]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins a5] [get_bd_pins xup_and6_0/a] [get_bd_pins xup_inv_5/a]
  connect_bd_net -net xup_and2_0_y [get_bd_pins xup_and2_0/y] [get_bd_pins xup_or4_0/b] [get_bd_pins xup_or4_1/b]
  connect_bd_net -net xup_and2_1_y [get_bd_pins xup_and2_1/y] [get_bd_pins xup_and6_1/f]
  connect_bd_net -net xup_and3_0_y [get_bd_pins xup_and3_0/y] [get_bd_pins xup_or4_0/c] [get_bd_pins xup_or4_2/b]
  connect_bd_net -net xup_and4_0_y [get_bd_pins xup_and4_0/y] [get_bd_pins xup_or4_0/d]
  connect_bd_net -net xup_and5_0_y [get_bd_pins xup_and5_0/y] [get_bd_pins xup_or4_1/c] [get_bd_pins xup_or4_2/c]
  connect_bd_net -net xup_and6_0_y [get_bd_pins xup_and6_0/y] [get_bd_pins xup_or4_1/d]
  connect_bd_net -net xup_and6_1_y [get_bd_pins xup_and6_1/y] [get_bd_pins xup_or4_2/d]
  connect_bd_net -net xup_inv_0_y [get_bd_pins xup_and2_0/b] [get_bd_pins xup_and3_0/c] [get_bd_pins xup_and4_0/d] [get_bd_pins xup_and5_0/e] [get_bd_pins xup_and6_0/f] [get_bd_pins xup_and6_1/a] [get_bd_pins xup_inv_0/y]
  connect_bd_net -net xup_inv_1_y [get_bd_pins xup_and3_0/b] [get_bd_pins xup_and4_0/c] [get_bd_pins xup_and5_0/d] [get_bd_pins xup_and6_0/e] [get_bd_pins xup_and6_1/b] [get_bd_pins xup_inv_1/y]
  connect_bd_net -net xup_inv_2_y [get_bd_pins xup_and4_0/b] [get_bd_pins xup_and5_0/c] [get_bd_pins xup_and6_0/d] [get_bd_pins xup_and6_1/c] [get_bd_pins xup_inv_2/y]
  connect_bd_net -net xup_inv_3_y [get_bd_pins xup_and5_0/b] [get_bd_pins xup_and6_0/c] [get_bd_pins xup_and6_1/d] [get_bd_pins xup_inv_3/y]
  connect_bd_net -net xup_inv_4_y [get_bd_pins xup_and6_0/b] [get_bd_pins xup_and6_1/e] [get_bd_pins xup_inv_4/y]
  connect_bd_net -net xup_inv_5_y [get_bd_pins xup_and2_1/a] [get_bd_pins xup_inv_5/y]
  connect_bd_net -net xup_or3_0_y [get_bd_pins y3] [get_bd_pins xup_or3_0/y]
  connect_bd_net -net xup_or4_0_y [get_bd_pins y0] [get_bd_pins xup_or3_0/a] [get_bd_pins xup_or4_0/y]
  connect_bd_net -net xup_or4_1_y [get_bd_pins y1] [get_bd_pins xup_or3_0/b] [get_bd_pins xup_or4_1/y]
  connect_bd_net -net xup_or4_2_y [get_bd_pins y2] [get_bd_pins xup_or3_0/c] [get_bd_pins xup_or4_2/y]

  # Restore current instance
  current_bd_instance $oldCurInst
}

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
  create_bd_pin -dir I a0
  create_bd_pin -dir I a1
  create_bd_pin -dir I a2
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
  connect_bd_net -net digital_ps_0_Dout_0 [get_bd_pins a0] [get_bd_pins xup_inv_0/a]
  connect_bd_net -net digital_ps_0_Dout_1 [get_bd_pins a1] [get_bd_pins xup_inv_1/a]
  connect_bd_net -net digital_ps_0_Dout_2 [get_bd_pins a2] [get_bd_pins xup_inv_2/a]
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

# Hierarchical cell: decoder
proc create_hier_cell_decoder { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_decoder() - Empty argument(s)!"}
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
  create_bd_pin -dir I b
  create_bd_pin -dir I c
  create_bd_pin -dir O y0
  create_bd_pin -dir O y1
  create_bd_pin -dir O y2
  create_bd_pin -dir O y3
  create_bd_pin -dir O y4
  create_bd_pin -dir O y5
  create_bd_pin -dir O y6
  create_bd_pin -dir O y7

  # Create instance: xup_and3_0, and set properties
  set xup_and3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_0 ]

  # Create instance: xup_and3_1, and set properties
  set xup_and3_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_1 ]

  # Create instance: xup_and3_2, and set properties
  set xup_and3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_2 ]

  # Create instance: xup_and3_3, and set properties
  set xup_and3_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_3 ]

  # Create instance: xup_and3_4, and set properties
  set xup_and3_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_4 ]

  # Create instance: xup_and3_5, and set properties
  set xup_and3_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_5 ]

  # Create instance: xup_and3_6, and set properties
  set xup_and3_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_6 ]

  # Create instance: xup_and3_7, and set properties
  set xup_and3_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_and3:1.1 xup_and3_7 ]

  # Create instance: xup_inv_0, and set properties
  set xup_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_0 ]

  # Create instance: xup_inv_1, and set properties
  set xup_inv_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_1 ]

  # Create instance: xup_inv_2, and set properties
  set xup_inv_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xup_inv:1.1 xup_inv_2 ]

  # Create port connections
  connect_bd_net -net xlslice_0_Dout [get_bd_pins a] [get_bd_pins xup_and3_1/a] [get_bd_pins xup_and3_3/a] [get_bd_pins xup_and3_5/a] [get_bd_pins xup_and3_7/a] [get_bd_pins xup_inv_0/a]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins b] [get_bd_pins xup_and3_2/b] [get_bd_pins xup_and3_3/b] [get_bd_pins xup_and3_6/b] [get_bd_pins xup_and3_7/b] [get_bd_pins xup_inv_1/a]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins c] [get_bd_pins xup_and3_4/c] [get_bd_pins xup_and3_5/c] [get_bd_pins xup_and3_6/c] [get_bd_pins xup_and3_7/c] [get_bd_pins xup_inv_2/a]
  connect_bd_net -net xup_and3_0_y [get_bd_pins y0] [get_bd_pins xup_and3_0/y]
  connect_bd_net -net xup_and3_1_y [get_bd_pins y1] [get_bd_pins xup_and3_1/y]
  connect_bd_net -net xup_and3_2_y [get_bd_pins y2] [get_bd_pins xup_and3_2/y]
  connect_bd_net -net xup_and3_3_y [get_bd_pins y3] [get_bd_pins xup_and3_3/y]
  connect_bd_net -net xup_and3_4_y [get_bd_pins y4] [get_bd_pins xup_and3_4/y]
  connect_bd_net -net xup_and3_5_y [get_bd_pins y5] [get_bd_pins xup_and3_5/y]
  connect_bd_net -net xup_and3_6_y [get_bd_pins y6] [get_bd_pins xup_and3_6/y]
  connect_bd_net -net xup_and3_7_y [get_bd_pins y7] [get_bd_pins xup_and3_7/y]
  connect_bd_net -net xup_inv_0_y [get_bd_pins xup_and3_0/a] [get_bd_pins xup_and3_2/a] [get_bd_pins xup_and3_4/a] [get_bd_pins xup_and3_6/a] [get_bd_pins xup_inv_0/y]
  connect_bd_net -net xup_inv_1_y [get_bd_pins xup_and3_0/b] [get_bd_pins xup_and3_1/b] [get_bd_pins xup_and3_4/b] [get_bd_pins xup_and3_5/b] [get_bd_pins xup_inv_1/y]
  connect_bd_net -net xup_inv_2_y [get_bd_pins xup_and3_0/c] [get_bd_pins xup_and3_1/c] [get_bd_pins xup_and3_2/c] [get_bd_pins xup_and3_3/c] [get_bd_pins xup_inv_2/y]

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

  # Create instance: decoder
  create_hier_cell_decoder [current_bd_instance .] decoder

  # Create instance: digital_ps_0, and set properties
  set digital_ps_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:digital_ps:1.1 digital_ps_0 ]
  set_property -dict [ list \
   CONFIG.Num_Input {13} \
   CONFIG.Num_Output {13} \
 ] $digital_ps_0

  # Create instance: minority_gate
  create_hier_cell_minority_gate [current_bd_instance .] minority_gate

  # Create instance: priority_encoder
  create_hier_cell_priority_encoder [current_bd_instance .] priority_encoder

  # Create port connections
  connect_bd_net -net decoder_y [get_bd_pins decoder/y0] [get_bd_pins digital_ps_0/Din_01]
  connect_bd_net -net decoder_y1 [get_bd_pins decoder/y1] [get_bd_pins digital_ps_0/Din_02]
  connect_bd_net -net decoder_y2 [get_bd_pins decoder/y2] [get_bd_pins digital_ps_0/Din_03]
  connect_bd_net -net decoder_y3 [get_bd_pins decoder/y3] [get_bd_pins digital_ps_0/Din_04]
  connect_bd_net -net decoder_y4 [get_bd_pins decoder/y4] [get_bd_pins digital_ps_0/Din_05]
  connect_bd_net -net decoder_y5 [get_bd_pins decoder/y5] [get_bd_pins digital_ps_0/Din_06]
  connect_bd_net -net decoder_y6 [get_bd_pins decoder/y6] [get_bd_pins digital_ps_0/Din_07]
  connect_bd_net -net decoder_y7 [get_bd_pins decoder/y7] [get_bd_pins digital_ps_0/Din_08]
  connect_bd_net -net digital_ps_0_Dout_0 [get_bd_pins digital_ps_0/Dout_00] [get_bd_pins minority_gate/a0]
  connect_bd_net -net digital_ps_0_Dout_1 [get_bd_pins digital_ps_0/Dout_01] [get_bd_pins minority_gate/a1]
  connect_bd_net -net digital_ps_0_Dout_2 [get_bd_pins digital_ps_0/Dout_02] [get_bd_pins minority_gate/a2]
  connect_bd_net -net digital_ps_0_Dout_03 [get_bd_pins decoder/a] [get_bd_pins digital_ps_0/Dout_03]
  connect_bd_net -net digital_ps_0_Dout_04 [get_bd_pins decoder/b] [get_bd_pins digital_ps_0/Dout_04]
  connect_bd_net -net digital_ps_0_Dout_05 [get_bd_pins decoder/c] [get_bd_pins digital_ps_0/Dout_05]
  connect_bd_net -net digital_ps_0_Dout_06 [get_bd_pins digital_ps_0/Dout_06] [get_bd_pins priority_encoder/a0]
  connect_bd_net -net digital_ps_0_Dout_07 [get_bd_pins digital_ps_0/Dout_07] [get_bd_pins priority_encoder/a1]
  connect_bd_net -net digital_ps_0_Dout_08 [get_bd_pins digital_ps_0/Dout_08] [get_bd_pins priority_encoder/a2]
  connect_bd_net -net digital_ps_0_Dout_09 [get_bd_pins digital_ps_0/Dout_09] [get_bd_pins priority_encoder/a3]
  connect_bd_net -net digital_ps_0_Dout_10 [get_bd_pins digital_ps_0/Dout_10] [get_bd_pins priority_encoder/a4]
  connect_bd_net -net digital_ps_0_Dout_11 [get_bd_pins digital_ps_0/Dout_11] [get_bd_pins priority_encoder/a5]
  connect_bd_net -net digital_ps_0_Dout_12 [get_bd_pins digital_ps_0/Dout_12] [get_bd_pins priority_encoder/a6]
  connect_bd_net -net minority_gate_y [get_bd_pins digital_ps_0/Din_00] [get_bd_pins minority_gate/y]
  connect_bd_net -net priority_encoder_y [get_bd_pins digital_ps_0/Din_09] [get_bd_pins priority_encoder/y0]
  connect_bd_net -net priority_encoder_y1 [get_bd_pins digital_ps_0/Din_10] [get_bd_pins priority_encoder/y1]
  connect_bd_net -net priority_encoder_y2 [get_bd_pins digital_ps_0/Din_11] [get_bd_pins priority_encoder/y2]
  connect_bd_net -net priority_encoder_y3 [get_bd_pins digital_ps_0/Din_12] [get_bd_pins priority_encoder/y3]

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


