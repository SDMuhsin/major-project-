`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2020 12:49:22
// Design Name: 
// Module Name: right_shifted_parity_generation
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


module Parity_generation_unit(p,p_prev_in,msg,f,fnext,rst,clk);//processing unit
parameter Lm=16;// number of message bit
parameter M=32; // size of circulant sub matrix of generator matrix
output [Lm-1:0]p;
input [Lm-1:0]p_prev_in;
input [Lm-1:0]msg;
input [Lm-1:0]f;//
input [Lm-1:0]fnext;//
input rst,clk;
genvar  i,j,k;
wire [M-1:0]f2;

wire w0[Lm-1:0];
wire [Lm-1:0]frev, fnextrev;
wire [Lm-1:0]msgrev;
wire [Lm-1:0]p_rev;
wire [Lm-1:0]p_prev_in_rev;

wire w[Lm-1:0][Lm-1:0];// row and colume corresponding mesg and circulant bit f[i]
//wire z1;

genvar z;
generate for(z=0;z<Lm;z=z+1) begin :bit_revesal
       assign msgrev[z]=msg[Lm-z-1];
       assign frev[z]=f[Lm-z-1];
       assign fnextrev[z]=fnext[Lm-z-1];
       assign p[z]=p_rev[Lm-z-1];
       assign p_prev_in_rev[z]=p_prev_in[Lm-z-1];
end 
endgenerate
       
assign f2={fnextrev,frev};

//FIrst stage and gates only
generate for(i=0;i<Lm;i=i+1) begin :andstageloop
    Multi_0_stage and_stage(w0[i],msgrev[0],f2[i]);
  end
endgenerate


generate for(k=0;k<=Lm-1;k=k+1) begin :k_col_loop // for generate colume
    assign w[0][k]=w0[k];
    for(j=0;j<=Lm-2;j=j+1) begin :j_row_loop// for generatr row
       stage_i_add_multi and_xor_stage(w[j+1][k],w[j][k],msgrev[j+1],f2[(j+1)+k]);
       //assign f[M+k]=f[k];
    end
    out_Parity p_recursive(p_rev[k],w[Lm-1][k],p_prev_in_rev[k],rst,clk);// prity module
//change this module for Lm accumulation
  end
endgenerate


endmodule