`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_tri_buf0
/////////////////////////////////////////////////////////////////


module xup_tri_buf0 #(parameter DELAY = 3)(
    input wire a,
    input wire enable,
    output wire y
    );
    
    bufif0 #DELAY (y,a,enable);
    
endmodule
