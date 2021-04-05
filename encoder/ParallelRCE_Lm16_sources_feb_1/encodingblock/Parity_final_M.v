`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2020 22:06:52
// Design Name: 
// Module Name: Parity_final_M
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


module Parity_final_M(q,in2,s,rst,clk);
parameter M=4;
output[M-1:0]q;
input [M-1:0]in2;
input s,rst,clk;
//assign q[0]=0;
genvar i;
generate for(i=0;i<M;i=i+1) begin :registerloop
d_with_mux parityfinal_dff(q[i],0,in2[i],s,rst,clk);//d_with_mux(q,s==1,s==0,s,rst,clk);
end
endgenerate
endmodule
 
 
