`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2020 05:34:52 PM
// Design Name: 
// Module Name: Function_generator0
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


module Function_generator0(f,adrs,rst);
parameter K_N=256;
output reg [K_N-1:0]f;
input [1:0]adrs;
input rst;
//input clk;
always@(adrs, rst)
if(rst)
f = 256'd0;
else
case(adrs)
 
  2'b00: f = 256'h8AD371E63AB8417FD242FA5F55E49AAFC896417C30D2074CD46111F2F74C2C01;
  2'b01: f = 256'h9057F1522AC4A2CACE747CC5884178E4A746FB682F81FBC0F0BD1211EACFBA9F;
  2'b10: f = 256'h8F41376741E7F5521C791B28402C13C4FD6B12D1591DC413646AC5168487F917;
  2'b11: f = 256'hB98A17DE5F5FF6F5CE5DB16431486AC5347D18205A62C258A6FB6306051C2470;
  default: f = 256'd0;
 
endcase
endmodule
