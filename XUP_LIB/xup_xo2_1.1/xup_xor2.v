`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: xup_xor2
//////////////////////////////////////////////////////////////////////////////////
module xup_xor2 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    output wire y
    );
    
    xor #DELAY (y,a,b);
    
endmodule
