`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2020 13:30:18
// Design Name: 
// Module Name: D_flip_flop
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


module D_flip_flop(q,d,ce,rst,clk);
output reg q;
input d;
input ce,rst,clk;

always@(posedge clk)
  if(rst)
    q<=1'b0;
  else if(ce==1)
    q<=d;
  else
    q<=q;
 
endmodule
