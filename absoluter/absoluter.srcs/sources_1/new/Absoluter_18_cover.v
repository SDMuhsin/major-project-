`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2020 22:04:16
// Design Name: 
// Module Name: Absoluter_18_cover
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


module Absoluter_18_cover(
        sign_reg,
        mag_reg,
        in,
        clk,
        rst
    );
    parameter w = 6;
    parameter wc = 18;   
    
    output reg sign_reg;
    output reg [w-2:0]mag_reg;
    input [wc*w - 1:0]in;
    
    
    input clk,rst;
    
    reg [wc*w - 1:0]in_reg;
    always @(posedge clk)begin
        if(rst)begin
            mag_reg <= 0;
            sign_reg <= 0;
            in_reg <= 0;
        end
        else begin
            mag_reg <= mag_wire;
            sign_reg <= sign_wire;
            in_reg <= in;
        end
    end
    
    //defparam a.w = w;
    //defparam a.wc = wc;
    //Absoluter_18 a( sign_wire, mag_wire, in_reg);
    
    defparam a.W = w;
    defparam a.Wc = wc;
    Absoluter a( sign_wire, mag_wire, in_reg);
endmodule
