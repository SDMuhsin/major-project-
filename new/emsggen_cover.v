`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2020 09:31:59
// Design Name: 
// Module Name: emsggen_cover
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


module emsggen_cover(ecomp_s,x_s,clk,rst
    );
    parameter w=6;
    parameter wc=18;
    output reg [2*(w-1)+wc+5-1:0]ecomp_s;
    input  [w*wc-1:0]x_s;
    wire [2*(w-1)+wc+5-1:0]ecomp;
    reg [w*wc-1:0]x;
    input clk,rst;
    
    always@(posedge clk)
    begin
    if(rst)
    begin
    ecomp_s<=0;
    x<=0;
    end
    
    else
    begin
    ecomp_s<=ecomp;
    x<=x_s;
    end
    end
    
    emsggen u1(ecomp,x,clk,rst);
    
endmodule