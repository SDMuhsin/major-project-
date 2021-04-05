`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2021 12:21:16
// Design Name: 
// Module Name: case_test
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


module case_test(
        output reg y,
        input [1:0]sel,
        input a,
        input b,
        input c,
        input d
    );
    
    always@(*)begin
        case(sel)
            2'b00:y=a;
            2'b01:y=b;
            default:y=c;
        endcase
    end
endmodule
