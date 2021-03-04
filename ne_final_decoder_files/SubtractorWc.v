`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2020 17:07:25
// Design Name: 
// Module Name: SubtractorWc
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
// the results overflowing range are truncated to limits.
//////////////////////////////////////////////////////////////////////////////////


module SubtractorWc(D, X, Y);
parameter W=10;
parameter Wc=32;
//output [Wc-1:0] B_out;
output [(Wc*(W))-1:0] D;
input [(Wc*W)-1:0] X, Y;

//input clk, rst;
/////////////////////
////Reg input and output
//wire [(Wc*(W))-1:0] D;
//reg [(Wc*W)-1:0] X, Y;

//always@(posedge clk)
//begin
//  if(!rst)
//    X<=0;
//  else
//    X<=Xin;
//end

//always@(posedge clk)
//begin
//  if(!rst)
//    Y<=0;
//  else
//    Y<=Yin;
//end

//always@(posedge clk)
//begin
//  if(!rst)
//    Dout<=0;
//  else
//    Dout<=D;
//end
////////////////////

//wire borrowout[Wc-1:0];
wire [W-1:0] diff[Wc-1:0]; 
wire [W-1:0] a[Wc-1:0], b[Wc-1:0];
//wire borrowin[Wc-1:0];

genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin: subloop
  //splitter
  assign a[i] = X[((i+1)*W)-1:(i*W)];
  assign b[i] = Y[((i+1)*W)-1:(i*W)];

  defparam subDUT.W = W;
  //adderW subDUT(, diff[i], a[i], ~b[i], 1'b1);
  subtractorW subDUT(, diff[i], a[i], b[i]);// ports: ( output borrowout, inputs diff, a,b)

  //combiner
  assign D[((i+1)*(W))-1:(i*(W))] = diff[i];
  //assign B_out[i] = borrowout[i]; 

end
endgenerate

endmodule
