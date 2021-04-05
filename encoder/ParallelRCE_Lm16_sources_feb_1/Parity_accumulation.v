`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 12:17:25
// Design Name: 
// Module Name: Parity_accumulation
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
// change: renamed in1 to accresult
// change: rst functionality for in2 avoided.
//////////////////////////////////////////////////////////////////////////////////


module Parity_accumulation(q,in,rst,clk);
parameter M=4;
output [M-1:0]q;
input [M-1:0]in;
input rst,clk;
wire [M-1:0]accresult,in2;
wire [M-1:0]q1;
// assign in2=rst?0:in;
 assign in2=in;
 assign q=q1;
genvar i;
 generate for(i=0;i<M;i=i+1) begin :LOOP1
   xor D1(accresult[i],in2[i],q[i]);
   D_flip_flop FF(q1[i],accresult[i],1'b1,rst,clk);//CE is 1
 end
endgenerate
endmodule
