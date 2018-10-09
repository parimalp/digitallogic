
################################################################
# This is a generated script based on design: design_1
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
# source design_1_script.tcl

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
set design_name design_1

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
xilinx.com:ip:counters_8bit:1.1\
xilinx.com:ip:digital_ps:1.1\
xilinx.com:ip:xlslice:1.0\
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


# Hierarchical cell: BIN_cnt
proc create_hier_cell_BIN_cnt { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_BIN_cnt() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 0 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Dout1
  create_bd_pin -dir O -from 0 -to 0 Dout2
  create_bd_pin -dir O -from 0 -to 0 Dout3
  create_bd_pin -dir O -from 0 -to 0 Dout4
  create_bd_pin -dir O -from 0 -to 0 Dout5
  create_bd_pin -dir O -from 0 -to 0 Dout6
  create_bd_pin -dir O -from 0 -to 0 Dout7

  # Create instance: bin_0, and set properties
  set bin_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
 ] $bin_0

  # Create instance: bin_1, and set properties
  set bin_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_1

  # Create instance: bin_2, and set properties
  set bin_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_2

  # Create instance: bin_3, and set properties
  set bin_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_3

  # Create instance: bin_4, and set properties
  set bin_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_4

  # Create instance: bin_5, and set properties
  set bin_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_5

  # Create instance: bin_6, and set properties
  set bin_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_6

  # Create instance: bin_7, and set properties
  set bin_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_7

  # Create port connections
  connect_bd_net -net bin_0_Dout [get_bd_pins Dout3] [get_bd_pins bin_0/Dout]
  connect_bd_net -net bin_1_Dout [get_bd_pins Dout4] [get_bd_pins bin_1/Dout]
  connect_bd_net -net bin_2_Dout [get_bd_pins Dout5] [get_bd_pins bin_2/Dout]
  connect_bd_net -net bin_3_Dout [get_bd_pins Dout6] [get_bd_pins bin_3/Dout]
  connect_bd_net -net bin_4_Dout [get_bd_pins Dout] [get_bd_pins bin_4/Dout]
  connect_bd_net -net bin_5_Dout [get_bd_pins Dout1] [get_bd_pins bin_5/Dout]
  connect_bd_net -net bin_6_Dout [get_bd_pins Dout2] [get_bd_pins bin_6/Dout]
  connect_bd_net -net bin_7_Dout [get_bd_pins Dout7] [get_bd_pins bin_7/Dout]
  connect_bd_net -net counters_0_bin_count [get_bd_pins Din] [get_bd_pins bin_0/Din] [get_bd_pins bin_1/Din] [get_bd_pins bin_2/Din] [get_bd_pins bin_3/Din] [get_bd_pins bin_4/Din] [get_bd_pins bin_5/Din] [get_bd_pins bin_6/Din] [get_bd_pins bin_7/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: BCD_cnt
proc create_hier_cell_BCD_cnt { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_BCD_cnt() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 0 -to 0 Dout0
  create_bd_pin -dir O -from 0 -to 0 Dout1
  create_bd_pin -dir O -from 0 -to 0 Dout2
  create_bd_pin -dir O -from 0 -to 0 Dout3
  create_bd_pin -dir O -from 0 -to 0 Dout4
  create_bd_pin -dir O -from 0 -to 0 Dout5
  create_bd_pin -dir O -from 0 -to 0 Dout6
  create_bd_pin -dir O -from 0 -to 0 Dout7

  # Create instance: bin_0, and set properties
  set bin_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
 ] $bin_0

  # Create instance: bin_1, and set properties
  set bin_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_1

  # Create instance: bin_2, and set properties
  set bin_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_2

  # Create instance: bin_3, and set properties
  set bin_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_3

  # Create instance: bin_4, and set properties
  set bin_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_4

  # Create instance: bin_5, and set properties
  set bin_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_5

  # Create instance: bin_6, and set properties
  set bin_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_6

  # Create instance: bin_7, and set properties
  set bin_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 bin_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $bin_7

  # Create port connections
  connect_bd_net -net BCD_cnt_Dout0 [get_bd_pins Dout0] [get_bd_pins bin_0/Dout]
  connect_bd_net -net bin_1_Dout1 [get_bd_pins Dout1] [get_bd_pins bin_1/Dout]
  connect_bd_net -net bin_2_Dout [get_bd_pins Dout2] [get_bd_pins bin_2/Dout]
  connect_bd_net -net bin_3_Dout [get_bd_pins Dout3] [get_bd_pins bin_3/Dout]
  connect_bd_net -net bin_4_Dout [get_bd_pins Dout4] [get_bd_pins bin_4/Dout]
  connect_bd_net -net bin_5_Dout [get_bd_pins Dout5] [get_bd_pins bin_5/Dout]
  connect_bd_net -net bin_6_Dout [get_bd_pins Dout6] [get_bd_pins bin_6/Dout]
  connect_bd_net -net bin_7_Dout [get_bd_pins Dout7] [get_bd_pins bin_7/Dout]
  connect_bd_net -net counters_8bit_0_bcd_count [get_bd_pins Din] [get_bd_pins bin_0/Din] [get_bd_pins bin_1/Din] [get_bd_pins bin_2/Din] [get_bd_pins bin_3/Din] [get_bd_pins bin_4/Din] [get_bd_pins bin_5/Din] [get_bd_pins bin_6/Din] [get_bd_pins bin_7/Din]

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

  # Create instance: BCD_cnt
  create_hier_cell_BCD_cnt [current_bd_instance .] BCD_cnt

  # Create instance: BIN_cnt
  create_hier_cell_BIN_cnt [current_bd_instance .] BIN_cnt

  # Create instance: counters_8bit_0, and set properties
  set counters_8bit_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:counters_8bit:1.1 counters_8bit_0 ]

  # Create instance: digital_ps_0, and set properties
  set digital_ps_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:digital_ps:1.1 digital_ps_0 ]
  set_property -dict [ list \
   CONFIG.Num_Input {16} \
   CONFIG.Num_Output {4} \
 ] $digital_ps_0

  # Create port connections
  connect_bd_net -net BCD_cnt_Dout [get_bd_pins BCD_cnt/Dout2] [get_bd_pins digital_ps_0/Din_10]
  connect_bd_net -net BCD_cnt_Dout0 [get_bd_pins BCD_cnt/Dout0] [get_bd_pins digital_ps_0/Din_08]
  connect_bd_net -net BCD_cnt_Dout1 [get_bd_pins BCD_cnt/Dout3] [get_bd_pins digital_ps_0/Din_11]
  connect_bd_net -net BCD_cnt_Dout2 [get_bd_pins BCD_cnt/Dout4] [get_bd_pins digital_ps_0/Din_12]
  connect_bd_net -net BCD_cnt_Dout3 [get_bd_pins BCD_cnt/Dout5] [get_bd_pins digital_ps_0/Din_13]
  connect_bd_net -net BCD_cnt_Dout4 [get_bd_pins BCD_cnt/Dout6] [get_bd_pins digital_ps_0/Din_14]
  connect_bd_net -net BCD_cnt_Dout5 [get_bd_pins BCD_cnt/Dout7] [get_bd_pins digital_ps_0/Din_15]
  connect_bd_net -net bin_0_Dout [get_bd_pins BIN_cnt/Dout3] [get_bd_pins digital_ps_0/Din_00]
  connect_bd_net -net bin_1_Dout [get_bd_pins BIN_cnt/Dout4] [get_bd_pins digital_ps_0/Din_01]
  connect_bd_net -net bin_1_Dout1 [get_bd_pins BCD_cnt/Dout1] [get_bd_pins digital_ps_0/Din_09]
  connect_bd_net -net bin_2_Dout [get_bd_pins BIN_cnt/Dout5] [get_bd_pins digital_ps_0/Din_02]
  connect_bd_net -net bin_3_Dout [get_bd_pins BIN_cnt/Dout6] [get_bd_pins digital_ps_0/Din_03]
  connect_bd_net -net bin_4_Dout [get_bd_pins BIN_cnt/Dout] [get_bd_pins digital_ps_0/Din_04]
  connect_bd_net -net bin_5_Dout [get_bd_pins BIN_cnt/Dout1] [get_bd_pins digital_ps_0/Din_05]
  connect_bd_net -net bin_6_Dout [get_bd_pins BIN_cnt/Dout2] [get_bd_pins digital_ps_0/Din_06]
  connect_bd_net -net bin_7_Dout [get_bd_pins BIN_cnt/Dout7] [get_bd_pins digital_ps_0/Din_07]
  connect_bd_net -net counters_8bit_0_bcd_count [get_bd_pins BCD_cnt/Din] [get_bd_pins counters_8bit_0/bcd_count]
  connect_bd_net -net counters_8bit_0_bin_count [get_bd_pins BIN_cnt/Din] [get_bd_pins counters_8bit_0/bin_count]
  connect_bd_net -net digital_ps_0_Dout_0 [get_bd_pins counters_8bit_0/clk] [get_bd_pins digital_ps_0/Dout_00]
  connect_bd_net -net digital_ps_0_Dout_1 [get_bd_pins counters_8bit_0/up_dn] [get_bd_pins digital_ps_0/Dout_01]
  connect_bd_net -net digital_ps_0_Dout_2 [get_bd_pins counters_8bit_0/clr] [get_bd_pins digital_ps_0/Dout_02]
  connect_bd_net -net digital_ps_0_Dout_3 [get_bd_pins counters_8bit_0/enable] [get_bd_pins digital_ps_0/Dout_03]

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


