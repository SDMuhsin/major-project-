`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2020 13:33:50
// Design Name: 
// Module Name: out_Parity
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
// For Lm accumulator
//////////////////////////////////////////////////////////////////////////////////


module out_Parity(p,w,p_prev,rst,clk);
output p;
input w;// last stage output of addtion and multiplicaton output
//input p0;//when rate is other than half then this input came in picture other wise it will be zero 
input p_prev,rst,clk;
wire accresultparity;
wire p1;

assign p=p1;
xor D0(accparity,w,p_prev);//exor with previous parity but 256*256 that why previous carray not require
D_flip_flop DUT0(p1,accparity,1'b1,rst,clk);//CE is 1
endmodule
