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

import pynq
from pynq import GPIO
from .constants import *

__author__ = "Parimal Patel"
__copyright__ = "Copyright 2018, Xilinx"
__email__ = "pynq_support@xilinx.com"


class DigitalLogicOverlay(pynq.Overlay):
    """ The Digital Logic overlay for the digital design circuits

    This overlay is implemented to provide stimulus to combinatorial and  
    sequential circuits.

    Attributes
    ----------
    gpio_x : GPIO
         GPIO connected to PS GPIO pin/bit x configured as EMIO.

    """
    def __init__(self, bitfile, **kwargs):
        super().__init__(bitfile, **kwargs)

    def bit_write(self,index,value): 
        """Write a value to the specified bit position.

        Parameters
        ----------
        index : integer value indicating bit position
            The bit position ranges from 0 to 31 corresponding to 
            Dout_00 to Dout_31.
        value : integer
            The value to be written, valid value being 0 or 1.

        """
        if index not in range (0, 32):
            raise ValueError("bit number must be between 0 and 31.")
        else:
            bitwrite = GPIO(GPIO.get_gpio_pin(index), 'out')
            bitwrite.write(value)

    def bit_read(self,index):
        """Read a value from the specified bit position.

        Parameters
        ----------
        index : integer value indicating bit position
            The bit position ranges from 0 to 31 corresponding to 
            Dout_00 to Dout_31.

        Returns
        -------
        integer
            Read value.

        """
        if index not in range (0, 32):
            raise ValueError("bit number must be between 0 and 31.")
        else:
            bitread = GPIO(GPIO.get_gpio_pin(index+32), 'in')
            result=bitread.read()
            return result

    def clk(self,index):
        """Generate one rising edge clock cycle at the specified bit position.

        Parameters
        ----------
        index : integer value indicating bit position
            The bit position ranges from 0 to 31 corresponding to 
            Dout_00 to Dout_31.

        """
        if index not in range (0, 32):
            raise ValueError("bit number must be between 0 and 31.")
        else:
            clkpin = GPIO(GPIO.get_gpio_pin(index), 'out')
            clkpin.write(1)
            clkpin.write(0)

    def bus_write(self, end_index, start_index, value):
        """Write a value to the specified muliple bits.

        Parameters
        ----------
        start_index : integer value indicating vector starting bit position
            The bit position ranges from 0 to 31 corresponding to 
            Dout_00 to Dout_31. It should be smaller then end_index
        end_index : integer value indicating vector ending bit position
            The bit position ranges from 0 to 31 corresponding to 
            Dout_00 to Dout_31. It should be greater then start_index
        value : integer
            The value to be written,gets converted to binary vector.

        """
        if start_index not in range (0, 32):
            raise ValueError("Start index must be between 0 and 31.")
        elif end_index not in range (0, 32):
            raise ValueError("End index must be between 0 and 31.")
        elif start_index > end_index:
            raise ValueError("Start index must be smaller then end index.")
        operand="{0:b}".format(value)
        
        operand=operand.zfill(end_index-start_index+1)
        for i in range(start_index,end_index+1):
             self.bit_write(i,int(operand[end_index-i]))
			 
    def bus_read(self, end_index, start_index):
        """Read a value from the specified multiple bits.

        Parameters
        ----------
        start_index : integer value indicating vector starting bit position
            The bit position ranges from 0 to 31 corresponding to 
            Dout_00 to Dout_31. It should be smaller then end_index
        end_index : integer value indicating vector ending bit position
            The bit position ranges from 0 to 31 corresponding to 
            Dout_00 to Dout_31. It should be greater then start_index

		Returns
        -------
        integer
            Read value.

        """
        if start_index not in range (0, 32):
            raise ValueError("Start index must be between 0 and 31.")
        elif end_index not in range (0, 32):
            raise ValueError("End index must be between 0 and 31.")
        elif start_index > end_index:
            raise ValueError("Start index must be smaller then end index.")
        result=0
        result=self.bit_read(start_index)
        for i in range (start_index+1, end_index+1):
            result=self.bit_read(i) << (i-start_index) | result
        return result

