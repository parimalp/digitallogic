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


import re
from copy import deepcopy
from collections import OrderedDict
from pyeda.inter import exprvar
from pyeda.inter import expr2truthtable
from pynq import Register
from pynq import MMIO
from .constants import *

__author__ = "Parimal Patel"
__copyright__ = "Copyright 2018, Xilinx"
__email__ = "pynq_support@xilinx.com"


class BooleanGenerator:
    """Class for the Boolean generator.

    This class can implement any combinational function. Since
    each LUT5 takes 5 inputs, the basic function that users can implement is
    5-input, 1-output boolean function. However, by concatenating multiple
    LUT5 together, users can implement complex boolean functions.

    There are 16 5-LUTs, so users can implement at most 16 basic boolean 
    functions at a specific time.

    Attributes
    ----------
    expressions : list/dict
        The boolean expressions, each expression being a string.
    input_pins : list
        A list of input pins used by the generator.
    output_pins : list
        A list of output pins used by the generator.

    """

    def __init__(self, intf_spec_name='BG_SPECIFICATION'):
        """Return a new Boolean generator object.
        
        The available input pins are data pins DIN0 - DIN15,

        The available output pins can be DOUT0-DOUT15.

        The input boolean expression can be of the following format:
        `DOUT4 = DIN0 & DIN1 | DIN2`.

        If no input boolean expression is specified, the default function
        implemented is `DIN0 & DIN1 & DIN2 & DIN3`.

        Parameters
        ----------
        No parameters are required

        """
        if type(intf_spec_name) is str:
            self.intf_spec = eval(intf_spec_name)
        elif type(intf_spec_name) is dict:
            self.intf_spec = intf_spec_name
        else:
            raise ValueError("Interface specification has to be str or dict.")

        self.bg_mmio = MMIO(0x43c00000,(4*64))
        self.bg_sel_mmio = MMIO(0x41200000)
		# Parameters to be cleared at reset
        self.expressions = dict()
        self.output_pins = list()
        self.input_pins = list()

    def setup(self, expressions):
        """Configure CFGLUTs with new boolean expression.

        Parameters
        ----------
        expressions : list/dict
            The boolean expression to be configured.

        """

        if isinstance(expressions, list):
            for i in range(len(expressions)):
                self.expressions['Boolean expression {}'.format(i)] = \
                    deepcopy(expressions[i])
        elif isinstance(expressions, dict):
            self.expressions = deepcopy(expressions)
        else:
            raise ValueError("Expressions must be list or dict.")

        mailbox_addr = self.bg_mmio.base_addr 
        mailbox_regs = [Register(addr) for addr in range(
            mailbox_addr, mailbox_addr + 4 * 64, 4)]
        for offset in range(0, 32, 2):
            mailbox_regs[offset][31:0] = 0x1FFFFFF

        for index in range (0,32):
            self.bg_mmio.write((index*4),mailbox_regs[index][31:0])
        self.bg_mmio.write((62*4),0x0000ffff)
        self.bg_mmio.write((63*4),(0x0000ffff | 0x80000000))
        self.bg_mmio.write((63*4), 0) # was 0x0000ffff)

        for expr_label, expression in self.expressions.items():
            if not isinstance(expression, str):
                raise TypeError("Boolean expression has to be a string.")

            if "=" not in expression:
                raise ValueError(
                    "Boolean expression must have form Output = Function.")

            # Parse boolean expression into output & input string
            expr_out, expr_in = expression.split("=")
            expr_out = expr_out.strip()
            if expr_out in self.output_pins:
                raise ValueError("The same output pin should not be driven by "
                                 "multiple expressions.")
            self.output_pins.append(expr_out)
            if expr_out in self.intf_spec['output_pins']:
                output_pin_num = self.intf_spec[
                    'output_pins'][expr_out]
            else:
                raise ValueError("Invalid output pin {}.".format(expr_out))

            # Parse the used pins preserving the order
            non_unique_inputs = re.sub("\W+", " ", expr_in).strip().split(' ')
            unique_input_pins = list(OrderedDict.fromkeys(non_unique_inputs))
            if not 1 <= len(unique_input_pins) <= 5:
                raise ValueError("Expect 1 - 5 inputs for each LUT.")
            input_pins_with_dontcares = unique_input_pins[:]
            self.input_pins += unique_input_pins
            self.input_pins = list(set(self.input_pins))

            # Need 5 inputs - any unspecified inputs will be don't cares
            for i in range(len(input_pins_with_dontcares), 5):
                expr_in = '(({0}) & X{1})|(({0}) & ~X{1})'.format(
                    expr_in, i)
                input_pins_with_dontcares.append('X{}'.format(i))

            # Map to truth table
            p0, p1, p2, p3, p4 = map(exprvar, input_pins_with_dontcares)
            expr_p = expr_in

            # Use regular expression to match and replace whole word only
            for orig_name, p_name in zip(input_pins_with_dontcares,
                                         ['p{}'.format(i) for i in range(5)]):
                expr_p = re.sub(r"\b{}\b".format(orig_name), p_name, expr_p)

            truth_table = expr2truthtable(eval(expr_p))

            # Parse truth table to send
            truth_list = str(truth_table).split("\n")
            truth_num = 0
            for i in range(32, 0, -1):
                truth_num = (truth_num << 1) + int(truth_list[i][-1])

            # Get current boolean generator bit enables
            bit_enables = self.bg_mmio.read(62*4)
            cfg_enables = self.bg_mmio.read(63*4)

            # Generate the input selects based on truth table and bit enables
            truth_table_inputs = [str(inp) for inp in truth_table.inputs]
            for i in range(5):
                lsb = i * 5
                msb = (i + 1) * 5 - 1
                if truth_table_inputs[i] in unique_input_pins:
                    if truth_table_inputs[i] in self.intf_spec[
                        'input_pins'] and truth_table_inputs[i] \
                            in self.intf_spec['input_pins']:
                        input_pin_ix = self.intf_spec[
                            'input_pins'][truth_table_inputs[i]]
                    else:
                        raise ValueError("Invalid input pin "
                                         "{}.".format(truth_table_inputs[i]))
                else:
                    input_pin_ix = 0x1f
                mailbox_regs[output_pin_num * 2][msb:lsb] = input_pin_ix

            mailbox_regs[output_pin_num * 2 + 1][31:0] = truth_num
            mailbox_regs[62][31:0] = bit_enables
            mailbox_regs[62][output_pin_num] = 0

            mailbox_regs[63][31:0] = cfg_enables
            mailbox_regs[63][output_pin_num] = 1
       
        int_to_write_62=int(mailbox_regs[62][31:0])
        int_to_write_63=int(mailbox_regs[63][31:0])
        for index in range (0,32):
            self.bg_mmio.write((index*4),(mailbox_regs[index][31:0]))
        self.bg_mmio.write((62*4), int_to_write_62)
        self.bg_mmio.write((63*4),(int_to_write_63 | 0x80000000))
        self.bg_mmio.write((63*4), int_to_write_63)

    def read(self, regnum):
        """Read Boolean Generator memory mapped registers.

        Parameters
        ----------
        regnum : integer

        """
        if type(regnum) is int:
            self.reg_num = regnum
        else:
            raise ValueError("Register number must be integer")

        if regnum not in range (0,64):
            raise ValueError("Register number must be in range of 0-63")

        return (self.bg_mmio.read(self.reg_num*4))
		
    def clear(self, expressions):
        """Clear output pins so new function on same pin can be defined.

        Parameters
        ----------
        expressions : list/dict
            Clear output pins so previosly configured output pins can be used.

        """

        if isinstance(expressions, list):
            for i in range(len(expressions)):
                self.expressions['Boolean expression {}'.format(i)] = \
                    deepcopy(expressions[i])
        elif isinstance(expressions, dict):
            self.expressions = deepcopy(expressions)
        else:
            raise ValueError("Expressions must be list or dict.")
            
        self.output_pins = list()
