`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2020 17:34:25
// Design Name: 
// Module Name: function_generator3
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


module Function_generator3(f,adrs,rst);
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
  2'b00: f = 256'h3808686AD4706057D160CE6DD1FBDC49BC2C9D9D15C639207F397CCCB46CD901;
  2'b01: f = 256'h75DCFBBD645F404EEA309F6104F99C058C59D4E975A24DE11CC5A3079B559A92;
  2'b10: f = 256'h6709C0EB57ECCD19C6C16A91FB816854314972D239BC37824D749BFB3A13ABA5;
  2'b11: f = 256'hF657015660A9458EF3551EF7B7AD4AB1669250F9716DCD8669F5E8D2743414DA;
  default: f = 256'd0;
endcase
endmodule
