`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2020 14:31:45
// Design Name: 
// Module Name: DEFAULT_ADDER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DEFAULT_ADDER(
        output carry_out,
        output [6:0]sum_out,
        input [6:0]a,
        input [6:0]b,
        input cin
    );
    
    assign {carry_out,sum_out} = a + b + cin;
endmodule
