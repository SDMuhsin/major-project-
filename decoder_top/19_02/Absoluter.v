`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2020 15:36:04
// Design Name: 
// Module Name: Absoluter
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
// Finds Wc values for absolute of L and sign of L
//////////////////////////////////////////////////////////////////////////////////


module Absoluter(signL, absL, L);
parameter W = 10;
parameter Wc = 32;
//output reg [(Wc*(W-1))-1:0] absLout;
//output reg [Wc-1:0] signLout;
//input [(Wc*W)-1:0] L_in;
output [Wc-1:0] signL;
output [(Wc*(W-1))-1:0] absL;
input [(Wc*W)-1:0] L;

//input clk, rst;    
//////////
//reg input and output
//wire [(Wc*(W-1))-1:0] absL;
//wire [Wc-1:0] signL;
//reg [(Wc*W)-1:0] L;
//always@(posedge clk)
//begin
//  if(!rst)
//    L<=0;
//  else
//    L<=L_in;
//end

//always@(posedge clk)
//begin
//  if(!rst)
//    absLout<=0;
//  else
//    absLout<=absL;
//end

//always@(posedge clk)
//begin
//  if(!rst)
//    signLout<=0;
//  else
//    signLout<=signL;
//end
////////

//wire [W-1:0] posL[Wc-1:0], negL[Wc-1:0];
wire [W-1:0] Larray[Wc-1:0];
wire [W-2:0] magL[Wc-1:0];
genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin : absloop
  assign Larray[i] = L[((i+1)*W)-1:(i*W)]; //split bitvec into array
  
//  defparam posnegLdut.W = W;
//  posnegX posnegLdut(posL[i], negL[i], Larray[i]);

//  assign magL[i] = posL[i][W-1] ? negL[i][W-2:0] : posL[i][W-2:0];
//  assign signL[i] = posL[i][W-1];
  
  defparam absoluterdut.W = W;
  absW absoluterdut(signL[i],magL[i], Larray[i]);
  
 assign absL[((i+1)*(W-1))-1:(i*(W-1))] = magL[i]; //combine bitvec into array
end
endgenerate


endmodule
