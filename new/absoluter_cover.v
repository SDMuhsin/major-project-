`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2020 12:26:55
// Design Name: 
// Module Name: absoluter_cover
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


module absoluter_cover(signL_s,absL_s,L_s,clk,rst
    );
parameter W = 6;
    parameter Wc = 18;
    output reg [Wc-1:0] signL_s;
    output reg [(Wc*(W-1))-1:0] absL_s;
    input [(Wc*W)-1:0] L_s;
    input clk,rst;
 
    wire [Wc-1:0] signL;
    wire [(Wc*(W-1))-1:0] absL;
    reg [(Wc*W)-1:0] L;
    
    always@(posedge clk)
    begin
    if(rst)
    begin
    absL_s<=0;
    signL_s<=0;
    L<=0;
    end
    
    else
    begin
    absL_s<=absL;
    signL_s<=signL;
    L<=L_s;
    end
    
    end
    
    Absoluter a1(signL,absL,L);
    
endmodule
