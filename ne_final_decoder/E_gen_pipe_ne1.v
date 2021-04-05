`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2020 15:03:07
// Design Name: 
// Module Name: E_gen_pipe
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
// xc7k160tffv676-1, flatten hierarchy:none
// Design with outputs of 3inpminfind regd.
// 5 Stage Minfinder design, after input is regd.
// WNS=7.804ns/Treq=10ns, Critical delay=2.196ns.
// Resource: LUT as logic=365 + LUT as SHiftReg=18 = SliceLUT=383/101400(0.38%)
// 424/202800 Flipflops(0.21%).
//////////////////////////////////////////////////////////////////////////////////


module E_gen_pipe(Ecomp, signLin, x_vecin, clk, rst);
parameter Wc=32;//fixed parameter
parameter Wcbits = 5;//fixed parameter
parameter W=6;//Can be varied parameter
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;

output [ECOMPSIZE-1:0] Ecomp;
input[Wc-1:0] signLin;
input[(Wc*Wabs)-1:0] x_vecin;

input clk, rst;    

wire [Wabs-1:0] min1_regout, min2_regout;
wire [Wcbits-1:0] pos_regout;
wire signparity;
wire [Wc-1:0] UpdatedsignL;
wire[Wc-1:0] signL;

//////////
//reg input and output
//wire[ECOMPSIZE-1:0] Ecomp;
parameter MINFINDERPIPE=5;//4;
reg[Wc-1:0] signLpipe[MINFINDERPIPE-1:0];
reg[(Wc*Wabs)-1:0] x_vec;
reg[Wc-1:0] UpdatedsignL_reg;

always@(posedge clk)
begin
  if(!rst)
    x_vec<=0;
  else
    x_vec<=x_vecin;
end

always@(posedge clk)
begin
  if(!rst)
    signLpipe[0]<=0;
  else
    signLpipe[0]<=signLin;
end

genvar j;
generate for(j=0;j<=MINFINDERPIPE-2;j=j+1) begin: sign_fifo_j_loop
  always@(posedge clk)
  begin
    if(!rst)
      signLpipe[j+1]<=0;
    else
      signLpipe[j+1]<=signLpipe[j];
  end
end//for j
endgenerate

always@(posedge clk)
begin
  if(!rst)
    UpdatedsignL_reg<=0;
  else
    UpdatedsignL_reg<=UpdatedsignL;
end
//////



//defparam minfindunit.W=W, minfindunit.Wc=Wc;
//Minfinder minfindunit(min1, min2, pos, x_vec);

defparam minfindunitclked.W=W, minfindunitclked.Wc=Wc;
//Minfinder minfindunitclked(min1_regout, min2_regout, pos_regout, x_vec, clk, rst);
m32VG_pipelined minfindunitclked(min1_regout,min2_regout,pos_regout,x_vec,clk,~rst);

assign signL = signLpipe[MINFINDERPIPE-1];   
assign signparity = ^signL;

genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin: signloop
assign UpdatedsignL[i] = signparity ?  ~signL[i] : signL[i];
end
endgenerate

//Combine Min1, Min2, Pos, UpdatedSignbits to make Compressed Extrinsic msg.
assign Ecomp={min1_regout,min2_regout,pos_regout,UpdatedsignL_reg};

endmodule
