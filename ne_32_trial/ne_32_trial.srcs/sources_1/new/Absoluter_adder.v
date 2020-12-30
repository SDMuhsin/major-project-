`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2020 15:42:06
// Design Name: 
// Module Name: Absoluter_adder
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


module Absoluter_adder(
        sign,
        mag,
        in
    );
    parameter w = 6;
    
    output sign;
    output reg [w-2:0]mag;
    input [w-1:0]in;
    
    assign sign = in[w-1];
    always @(*)begin
        if(in[w-1])begin
            if( in[w-2:0] == {1'b1,(w-2)*{1'b0}}) begin
                mag = {1'b0,(w-2)*{1'b1}};
            end
            else begin
                mag = ~in[w-2:0] + 1'b1;
            end
        end
        else begin
            mag = in[w-2:0];
        end
    end
endmodule
