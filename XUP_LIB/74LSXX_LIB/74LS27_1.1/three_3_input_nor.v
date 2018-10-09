`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: three_3_input_nor
// Description: Three 3-input NOR gate with DELAY configuration parameter
// Parameters: DELAY
/////////////////////////////////////////////////////////////////

module three_3_input_nor #(parameter DELAY = 10)(
    input wire a1,b1,c1,a2,b2,c2,a3,b3,c3,
    output wire y1,y2,y3
    );
    
    nor #DELAY (y1,a1,b1,c1);
    nor #DELAY (y2,a2,b2,c2);
    nor #DELAY (y3,a3,b3,c3);
    
endmodule
