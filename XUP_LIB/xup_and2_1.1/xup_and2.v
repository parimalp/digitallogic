`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_and2
/////////////////////////////////////////////////////////////////
module xup_and2 #(parameter DELAY=3)(
    input wire a,
    input wire b,
    output wire y
    );

    and #DELAY (y, a, b);

endmodule
