Tool and version:  Vivado 2018.2 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This IP is a member of 74LSxx_LIB created by XUP. The 74LSxx_LIB provides the basic IPs having same number and types of gates/functionality that one can find in 74LS IC series. Some of the IP have testbench which can be used to simulated the IP in XSIM. In order to perform the simulation, instantiate the IP in HDL flow and then add the testbech. 

Setting up the library path:
Create a Vivado project. Click on the Project Settings, then click on the IP block in the left panel, click on the Add Repository... button, browse to the directory where the 74LSxx_LIB directory is located, and click Select. The IP entry should be visible in the IP in the Selected Repository. 

How to use the IP:
Step 1: Create a Vivado project
Step 2: Set the Project Settings to point to the 74LSxx_LIB path
Step 3: Create a block design
Step 4: Add the ps block and make FIXED_IO and DDR interfaces external
Step 5: Double-click the added ps block and eneable the desired inpit and output pins/buses
Step 6: Add the desired IP on the canvas, connect them
Step 7: Connect the input/output of the design logic to the exposed bits/buses of the ps block
Step 7a: Expose any internal signals to external input/output ports if desired
Step 8: Create a HDL wrapper
Step 8a: Add constraints file (.xdc) only if you exposed any internal signals to input/output pins
Step 9: Synthesize, implement, and generate the bitstream
Step 10: Connect the board, power-it ON
Step 11: Using Samba, copy the generated bitstream in the pynq/overlays/digitallogic folder replacing the exisitng digitallogic.bit file (it means you will have to rename the generated bitstream to digitallogic.bit)
Step 12: Using Jupyter Notebook and provided APIs develop your application and vreify the design


Change log

