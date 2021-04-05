`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2020 17:28:34
// Design Name: 
// Module Name: SPI_final_size
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
/////////////////////////////////////////////////////////////////////////////////

module SPI_final_size(msg_to_tx,msg_to_encode,en,sm,f_sel,in,datavalid,rst,clk_in,clk);
parameter K=1024;
parameter Lm=16;
parameter La=8;
parameter M=32;
parameter MSEL_BITSIZE = 3;
output msg_to_tx; //serial out
output [M*La-1:0]msg_to_encode;
//wire [K:1]q; // insteaded of K-1,K for generating sequence
input in;
input en,sm;
input [1:0]f_sel;
input datavalid,rst,clk,clk_in;
wire [K:0]q1;//wire for sipo converter
wire [K:0]q2;//wire for siso for mesg output
wire [K:0]q3;// sipo for generating parity bit
wire en;
//wire msg_tx1;
//wire [MSEL_BITSIZE-1:0]m_en; 
 assign q1[0]=in;
 assign q2[0]=0;
 assign q3[0]=0; 
//D_flip_flop DUT0(in1,in,rst,clk);
genvar i;
generate for(i=0;i<K;i=i+1) begin :sipoloop1
D_flip_flop sipo(q1[i+1],q1[i],datavalid,rst,clk_in);//CE is datavalid
end
endgenerate
genvar j;
generate for(j=1;j<=K;j=j+1) begin : pisoloop
d_with_mux piso(q2[j],q1[j-1],q2[j-1],en,rst,clk);
end
endgenerate
genvar k;
generate for(k=1;k<=K;k=k+1) begin : pipoloop
//d_with_mux pipo(q3[k],q1[k-1],q3[k],en,rst,clk_in);//(out, en==1, en==0, en, rst, clk)
D_flip_flop pipo(q3[k],q1[k-1],en,rst,clk_in);//D_flip_flop(q,d,ce,rst,clk);
end
endgenerate
//defparam DUT_e_ld.K=K;
//counter_load DUT_e_ld(en,m_en,rst,clk); 
defparam datamux.K=K,datamux.Lm=Lm, datamux.La=La, datamux.M=M, datamux.MSEL_BITSIZE=MSEL_BITSIZE;
//Data_MUX datamux(msg_to_encode,sm,q3[K:1],m_en,rst);
Data_MUX datamux(msg_to_encode,sm,q3[K:1],f_sel);

//assign q=en?q3[K:1]:q;
assign msg_to_tx=q2[K];
//assign q21=en?q2[K:0]:q21;
endmodule