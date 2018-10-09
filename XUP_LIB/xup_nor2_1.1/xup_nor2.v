`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nor2
/////////////////////////////////////////////////////////////////
module xup_nor2 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    output wire y
    );
    
    nor #DELAY (y,a,b);
    
endmodule
