`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 15:00:11
// Design Name: 
// Module Name: Parity_tx
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


module Parity_tx(qtx,parity_in,load_en,t_en,rst,clk);
parameter K_N=256;
output wire qtx;
input [K_N-1:0]parity_in;
 input load_en,t_en;
input rst,clk;

wire [K_N-1:0]paritymem_out;
wire [K_N:0]q;

assign q[0]=1'b0;

genvar i;
generate for(i=0;i<K_N;i=i+1) begin :psio
  D_flip_flop Parity_Mem(paritymem_out[i],parity_in[i],load_en,rst,clk);
//  d_with_mux DUT0(paritymem_out[i],parity_in[i],paritymem_out[i],load_en,rst,clk);
  d_with_mux DUTtx(q[i+1],q[i],paritymem_out[i],t_en,rst,clk);
end
endgenerate
   assign qtx=q[K_N];
endmodule
