`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_inv_vector
/////////////////////////////////////////////////////////////////
module xup_inv_vector #(parameter SIZE = 8 , DELAY = 3)(
    input wire [SIZE-1:0] a,
    output wire [SIZE-1:0] y
    );
    
   genvar i;
    generate
       for (i=0; i < SIZE; i=i+1) 
       begin: not_i
          not #DELAY(y[i], a[i]);
       end
    endgenerate
   
endmodule
