`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_tri_buf0_vector
/////////////////////////////////////////////////////////////////
module xup_tri_buf0_vector #(parameter SIZE = 8 , DELAY = 3)(
    input wire [SIZE-1:0] a,
    input wire enable,
    output wire [SIZE-1:0] y
    );

   genvar i;
    generate
       for (i=0; i < SIZE; i=i+1) 
       begin: buf0_i
    		assign #DELAY y[i] = (~enable) ? a[i] : 'bz;
       end
    endgenerate
        
endmodule
