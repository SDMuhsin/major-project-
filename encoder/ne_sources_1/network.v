`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2021 11:33:20
// Design Name: 
// Module Name: network
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


module Parity_generation_unit(u_reg,msg_inp,f_inp,rst,clk);//processing unit
parameter Lm=16;// number of message bit
parameter M=511; // size of circulant sub matrix of generator matrix//change thhis to 2 or 3 to visualize in elaborated design
parameter Logsize=30;//16+8+4+2
output reg [M-1:0]u_reg;
//output u0,u1,u2,u3,u4;
input [Lm-1:0]msg_inp;
input [M-1:0]f_inp;//
//input [Lm-1:0]fnext;//
input rst,clk;
genvar  i,j,k;
wire [M-1:0]f2;

wire [M-1:0]frev;
wire [Lm-1:0]msgrev;


//wire w[Lm-1:0][M-1:0];// row and colume corresponding mesg and circulant bit f[i]
wire [M-1:0]w[Logsize-1:0];
//wire z1;
wire [M-1:0]u;
//output u0,u1,u2,u3,u4;
reg [Lm-1:0]msg;
reg [M-1:0]f;//

always@(posedge clk)
begin
    if(rst)
    begin
        f<=0;
        msg<=0;
        u_reg=0;
    end
    else
    begin
        f<=f_inp;
        msg<=msg_inp;
        u_reg<=u;
   end
end

genvar z;
generate for(z=0;z<Lm;z=z+1) begin :bit_revesal
       assign msgrev[z]=msg[Lm-z-1];
  
end
endgenerate
       
//assign f2=frev;
assign f2=f;

//FIrst stage and gates only
generate for(i=0;i<M;i=i+1) begin :andstageloop
    Multi_0_stage and_stage(w[0][i],msg[0],f2[i]);
  end
endgenerate



generate for(j=0;j<=Lm-2;j=j+1) begin :j_row_loop// for generator row
    for(k=0;k<=M-1;k=k+1)  begin :k_col_loop // for generate column
        Multi_0_stage and_stage2(w[j+1][k],msg[j+1],f2[((j+1)+k)%M]);
    end
    end
endgenerate

generate for(k=0;k<Lm-1;k=k+1)  begin :k_col_loop2 // for generate column
        assign w[Lm+k]=w[(2*k)]^w[(2*k+1)];
    end
endgenerate


assign u=w[Logsize-1]^w[Logsize-2];
/*assign u0=w[Lm-1][0];
assign u1=w[Lm-1][1];
assign u2=w[Lm-1][2];
assign u3=w[Lm-1][3];
assign u4=w[Lm-1][4];*/
endmodule
