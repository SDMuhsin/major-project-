`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2020 22:05:12
// Design Name: 
// Module Name: d_with_mux
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


module d_with_mux(q,in1,in2,s,rst,clk);
output reg q;
input in1,in2,s;
input rst,clk;
wire in;
assign in=s?in1:in2;
always@(posedge clk)
if(rst)
 q<=1'b0;
 else
 q<=in;
endmodule
