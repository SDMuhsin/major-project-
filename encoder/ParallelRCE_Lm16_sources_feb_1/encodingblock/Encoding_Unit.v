`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2020 11:15:40 AM
// Design Name: 
// Module Name: Encoding_Unit
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


module Encoding_Unit(p_M, msg_M, f_M, m_en0, rst, clk_in);
parameter Lm=16;// number of message bit
parameter M=32; // size of circulant sub matrix of generator matrix
output [M-1:0] p_M;
input [M-1:0] f_M;
input [M-1:0] msg_M;
input m_en0, rst, clk_in;

wire [Lm-1:0] w[(M/Lm)-1:0];//f used for encoding
wire [Lm-1:0] p_w[(M/Lm)-1:0];

wire [M-1:0] f_rightshift;
wire [M-1:0] f_to_split;

wire [Lm-1:0] msg_Lm;
wire [Lm-1:0] msg_to_encode;
wire [M-1:0] msg_to_divide;

//0. rightshift f by Lm-1 units.
assign f_rightshift = {f_M[Lm-2:0], f_M[M-1:Lm-1]};

//assign f_to_split = f_M;
assign f_to_split = f_rightshift;

genvar i;
generate for(i=0;i<=(M/Lm)-1;i=i+1) begin : splitf_loop
     assign w[(M/Lm)-1-i] = f_to_split[(M-i*Lm-1):(M-(i+1)*Lm)];
     assign p_M[(M-i*Lm-1):(M-(i+1)*Lm)] = p_w[(M/Lm)-1-i]; 
  end
endgenerate

//1. Reverse msg :
//assign msg_to_divide = msg_M;
genvar z;
generate for(z=0;z<M;z=z+1) begin :bit_revesal
       assign msg_to_divide[z]=msg_M[M-1-z];
end 
endgenerate

//2. Divide msg to Lm sections obtained at each cycles
msg_sel_Lm msgselector(msg_Lm, msg_to_divide, m_en0);

//3. Encoding process:
assign msg_to_encode = msg_Lm;
//assign p_M[7:4] = p_w[1];
//assign p_M[3:0] = p_w[0];

//MSB column j=M/Lm-1
defparam processunitmsb.M=M, processunitmsb.Lm=Lm;
Parity_generation_unit processunitmsb(p_w[(M/Lm)-1],p_w[0],msg_to_encode,w[(M/Lm)-1],w[(M/Lm)-2],rst,clk_in);//processing unit

genvar j;
generate  for(j=1;j<=(M/Lm)-2;j=j+1) begin : paritygen_loop
   defparam processunit.M=M, processunit.Lm=Lm;
   Parity_generation_unit processunit(p_w[j],p_w[j+1],msg_to_encode,w[j],w[j-1],rst,clk_in);//processing unit
  end
endgenerate

//LSB column j=0
defparam processunitlsb.M=M, processunitlsb.Lm=Lm;
Parity_generation_unit processunitlsb(p_w[0],p_w[1],msg_to_encode,w[0],w[(M/Lm)-1],rst,clk_in);//processing unit    

endmodule
