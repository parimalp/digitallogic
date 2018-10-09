#   Copyright (c) 2016, Xilinx, Inc.
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#
#   1.  Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#
#   2.  Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#   3.  Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
#   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#   OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#   ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


__author__ = "Parimal Patel"
__copyright__ = "Copyright 2018, Xilinx"
__email__ = "pynq_support@xilinx.com"

# Digital Logic Pins 
DOUT_GR = [960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 
           973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 
           986, 987, 988, 989, 990, 991]

DIN_GR = [992, 993, 994, 995, 996, 997, 998, 999, 1000, 1001, 1002, 1003, 
          1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 
          1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023]

# Boolean Generator Specifications
BG_SPECIFICATION = {'interface_width': 16,
                    'output_pins': {'DOUT0': 0,
                                    'DOUT1': 1,
                                    'DOUT2': 2,
                                    'DOUT3': 3,
                                    'DOUT4': 4,
                                    'DOUT5': 5,
                                    'DOUT6': 6,
                                    'DOUT7': 7,
                                    'DOUT8': 8,
                                    'DOUT9': 9,
                                    'DOUT10': 10,
                                    'DOUT11': 11,
                                    'DOUT12': 12,
                                    'DOUT13': 13,
                                    'DOUT14': 14,
                                    'DOUT15': 15
                                   },
                    'input_pins':  {'DIN0': 0,
                                    'DIN1': 1,
                                    'DIN2': 2,
                                    'DIN3': 3,
                                    'DIN4': 4,
                                    'DIN5': 5,
                                    'DIN6': 6,
                                    'DIN7': 7,
                                    'DIN8': 8,
                                    'DIN9': 9,
                                    'DIN10': 10,
                                    'DIN11': 11,
                                    'DIN12': 12,
                                    'DIN13': 13,
                                    'DIN14': 14,
                                    'DIN15': 15
                   }
				 }
				   
