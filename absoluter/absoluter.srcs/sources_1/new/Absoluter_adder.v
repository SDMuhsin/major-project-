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
        output sign,
        output reg [4:0]mag,
        input [5:0]in
    );
    
    assign sign = in[5];
    always @(*)begin
        if(in[5])begin
            if( in[4:0] == 5'b10000) begin
                mag = 5'b01111;
            end
            else begin
                mag = ~in[4:0] + 1'b1;
            end
        end
        else begin
            mag = in[4:0];
        end
    end
endmodule
