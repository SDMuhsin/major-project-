`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2021 17:27:36
// Design Name: 
// Module Name: AdderWc_3in_pipelined
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


module AdderWc_3in_pipelined(S, X, Y, Z, clk, rst);
parameter W=10;
parameter Wc=32;
//output [Wc-1:0] C_out;
output [(Wc*(W))-1:0] S;
input [(Wc*W)-1:0] X, Y, Z;
input clk, rst;

wire [W-1:0] sum[Wc-1:0]; 
wire [W-1:0] a[Wc-1:0], b[Wc-1:0], c[Wc-1:0];
//wire carryin[Wc-1:0];

genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin: addloop
  //splitter
  assign a[i] = X[((i+1)*W)-1:(i*W)];
  assign b[i] = Y[((i+1)*W)-1:(i*W)];
  assign c[i] = Z[((i+1)*W)-1:(i*W)];

  defparam addDUT3in.W = W;
  //AdderW_3in addDUT3in(, sum[i], a[i], b[i], c[i]);
  AdderW_3in_pipelined addDUT3in(, sum[i], a[i], b[i], c[i], clk, rst);

  //combiner
  assign S[((i+1)*(W))-1:(i*(W))] = sum[i];

end
endgenerate

endmodule
