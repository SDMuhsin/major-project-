`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 12:47:23
// Design Name: 
// Module Name: accumulator
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
// cycle 0: rd_en =1 to infifo, rd_en given to input of FF whose output is en.
// cycle 1: infifo output 'x' arrives at acc input, en=1, sum ready in v
// cycle 2: sum registerd to y, valid=1, write to outfifo requested
// cycle 3: sum  y gets written to outfifo
//////////////////////////////////////////////////////////////////////////////////


module accumulator( valid, y, x, en, clk, rst);
parameter W=6;
parameter Wc=4;
output reg valid; //signal write to out fifo
output reg[(Wc*W)-1:0] y;
input [(Wc*W)-1:0] x;
input en, clk, rst;

wire [(Wc*W)-1:0] v;

genvar i;
generate 
for(i=0;i<=Wc-1;i=i+1) begin: Wc_i_loop
  assign v[((i+1)*W)-1:(i*W)] = y[((i+1)*W)-1:(i*W)] + x[((i+1)*W)-1:(i*W)];
end
endgenerate

always@(posedge clk)
begin
  if(!rst)
  begin
    y<=0;
    valid<=0;
  end
  else
  begin
    valid<=en;
    if(en)
      y<=v;
    else
      y<=y;
  end
end


endmodule
