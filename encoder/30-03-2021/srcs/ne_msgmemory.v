`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2021 13:26:37
// Design Name: 
// Module Name: ne_msgmemory
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


module ne_msgmemory(msgLmtoencode, address, msg_vec, wren, rden, clk, rst);
parameter KB=14;
parameter K=7136;
parameter Kunshort = 7154;
parameter Kunshortwithzeros = Kunshort + KB; //7154 + 14 = 7168
parameter Lm=16;
parameter READDEPTH = Kunshortwithzeros/Lm;//K/Lm = 7168/16 = 448
parameter ADDRESSWIDTH = 9;//ceil(log2(K/DW)) = ceil(log2(7136/16)) = 9
parameter READDEFAULTCASE = 2**ADDRESSWIDTH -1; //511

output reg[Lm-1:0] msgLmtoencode;
input [ADDRESSWIDTH-1:0] address;
input[Kunshortwithzeros-1:0] msg_vec;
input wren; //parallel write no write address required.
input rden;
input clk;
input rst;

wire[ADDRESSWIDTH-1:0] address_case;
reg[Kunshortwithzeros-1:0] msgvecmem;
//Write operation 
always@(posedge clk)
begin
  if(rst)
    msgvecmem <=0;
  else
    if(wren)
      msgvecmem<=msg_vec;
    else
      msgvecmem<=msgvecmem;
end

//Split Lm sections
wire[Lm-1:0] msgmem[READDEPTH-1:0];
genvar i;
generate 
  for(i=0;i<=READDEPTH-1;i=i+1) begin: Lm_loop
    assign msgmem[i] = msgvecmem[(i+1)*Lm-1:(i*Lm)];
  end
endgenerate

//ASYNC READ operation
assign address_case = rden ? address : READDEFAULTCASE;

always@(*)
begin
  if(address_case<=READDEPTH-1)
    msgLmtoencode =  msgmem[address_case];
  else
    msgLmtoencode = 0;
end

endmodule
