`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2020 15:30:58
// Design Name: 
// Module Name: Lmem_SRQtype
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
// symbol indices:
// Row calculation unit set: { 25th{31,30,...0 symbols }, 24th{31,30,...0 symbols }, .. , 0th{31,30,...0 symbols } }
// Lmem: { 15th{51,50,...,0}, 14th{51,50,...,0 symbols }, ..., 0th{51,50,...,0 symbols } } 
// While loading Lmem: { 15th{31,30,...,0 symbols }, 14th{31,30,...,0 symbols }, ..., 0th{31,30,...,0 symbols } }
// Hard Decision data : 7136 bits = {circ0 18 to 510, circ1 0 to 510, ..., circ13 0 to 510} 
// While unloading Lmem: {13th (31-0 bits), 12th(31-0 bits), ..., 0th(31-0 bits) }
// Lmem lyr0 to 1
// Lmem lyr1 to lyr 0 with unload align for first 14 blocks, without unload align for remaining blocks
// Lmem load to lyr 0 inputQueue
//////////////////////////////////////////////////////////////////////////////////


module Lmem_SRQtype_reginout(unload_HDout_vec_regout,rd_data_regout,unload_en_regin,unloadAddress_regin,rd_en_regin,rd_address_regin,rd_layer_regin, load_data_regin,loaden_regin, wr_data_regin,wr_en_regin,wr_layer_regin, firstiter_regin, clk,rst);
//module Lmem_SRQtype(unload_HDout_vec,rd_data,unload_en,unloadAddress,rd_en,rd_address,rd_layer, load_data,loaden, wr_data,wr_en,wr_layer, firstiter, clk,rst);
parameter W=6;//6;//configurable by user

//non-configurable parameters
parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
parameter Nb=16;//16;//circulant blocks per layer
parameter Kb=14;//first 14 circulant columns correspond to systematic part
parameter HDWIDTH=32;//taking 32 bits at a time
parameter Wt=2; //circulant weight
parameter ADDRESSWIDTH = 5;//to address 20 locations correspondin to ceil(Z/P)=20 cycles.

//Non-configurable. (use script analyse and configure accordingly)
parameter r=P*Wt;//r is predefined to be 52. non configurable.
parameter w=W;

//output [(Kb*HDWIDTH)-1:0] unload_HDout_vec;
//output [(P*Nb*Wt*W)-1:0] rd_data;
//input unload_en;
//input [ADDRESSWIDTH-1:0] unloadAddress;
//input rd_en;
//input [ADDRESSWIDTH-1:0] rd_address;
//input rd_layer;
//input [(32*Nb*W)-1:0] load_data;
//input loaden;
//input [(P*Nb*Wt*W)-1:0] wr_data;
//input wr_en;
//input wr_layer;
//input firstiter; //from controller send after fsm start, iff (itr==0), first iter=1.
//input clk,rst;

//registered input and output
output reg [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;
output reg [(P*Nb*Wt*W)-1:0] rd_data_regout;
input unload_en_regin;
input [ADDRESSWIDTH-1:0] unloadAddress_regin;
input rd_en_regin;
input [ADDRESSWIDTH-1:0] rd_address_regin;
input rd_layer_regin;
input [(32*Nb*W)-1:0] load_data_regin;
input loaden_regin;
input [(P*Nb*Wt*W)-1:0] wr_data_regin;
input wr_en_regin;
input wr_layer_regin;
input firstiter_regin; //from controller send after fsm start, iff (itr==0), first iter=1.
input clk,rst;

wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec;
wire [(P*Nb*Wt*W)-1:0] rd_data;
reg unload_en;
reg [ADDRESSWIDTH-1:0] unloadAddress;
reg rd_en;
reg [ADDRESSWIDTH-1:0] rd_address;
reg rd_layer;
reg [(32*Nb*W)-1:0] load_data;
reg loaden;
reg [(P*Nb*Wt*W)-1:0] wr_data;
reg wr_en;
reg wr_layer;
reg firstiter;

always@(posedge clk)
begin
  if(rst)
  begin
    unload_HDout_vec_regout <= 0;
    rd_data_regout <=0;
    unload_en <=0;
    unloadAddress <=0;
    rd_en <=0;
    rd_address <=0;
    rd_layer <=0;
    load_data <=0;
    loaden <=0;
    wr_data <=0;
    wr_en <=0;
    wr_layer <=0;
    firstiter <=0;    
  end
  else
  begin
    unload_HDout_vec_regout <= unload_HDout_vec;
    rd_data_regout<=rd_data;
    unload_en<= unload_en_regin;
    unloadAddress<=unloadAddress_regin;
    rd_en<=rd_en_regin;
    rd_address<=rd_address_regin;
    rd_layer<=rd_layer_regin;
    load_data<=load_data_regin;
    loaden<=loaden_regin;
    wr_data<=wr_data_regin;
    wr_en<=wr_en_regin;
    wr_layer<=wr_layer_regin;
    firstiter<=firstiter_regin;  
  end
end
//registered input and output

//wire [W-1:0] wr_data_arr[P-1:0][Nb-1:0][Wt-1:0];
//wire [W-1:0] rd_data_arr[P-1:0][Nb-1:0][Wt-1:0];

//
wire [HDWIDTH-1:0] unload_HDout[Kb-1:0];
wire [(32*W)-1:0] lmem_loaddata_in[Nb-1:0];
wire [r*w-1:0]lmem_data_in[Nb-1:0];//,lmem_data_in_1[Nb-1:0];
wire [r*w-1:0]lmem_data_out_0[Nb-1:0],lmem_data_out_1[Nb-1:0], lmem_data_out_init[Nb-1:0];// r numbers of w bits
wire wr_en0to1, rd_en0to1;
wire wr_en1to0, rd_en1to0;
wire rd_enloadto0;
wire [ADDRESSWIDTH-1:0] rd_address_0, rd_address_1;

//aligning according to row calculation unit
//LLR to Row Calculation Unit = {LLR_25, LLR_24, ...., LLR_2, LLR_1, LLR_0}.
// LLR_# is of width= NbxWtxW = 16x2xW=32xW.
wire [(Nb*Wt*W)-1:0] wr_data_arr[P-1:0];
wire [(Nb*Wt*W)-1:0] rd_data_arr_0[P-1:0];
wire [(Nb*Wt*W)-1:0] rd_data_arr_1[P-1:0];

//Splitting bit vector data to individual data to be fed to each circulant
genvar j_p, i_nb;
generate 
  for(j_p=0;j_p<=P-1;j_p=j_p+1) begin: p26_loop
    assign wr_data_arr[j_p] = wr_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))];
    
    //aligning according to Mem circuits
    //LLR to/fro memciruits = MLLR_15, MLLR_14, ..., MLLR_2, MLLR_1, MLLR_0
    // MLLR_# is of width = PxWtxW = 26x2xW=52xW.
    for(i_nb=0;i_nb<=Nb-1;i_nb=i_nb+1) begin: Nb16_loop
      assign lmem_data_in[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] = wr_data_arr[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)];
      assign rd_data_arr_0[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)] = (rd_layer & firstiter) ? lmem_data_out_init[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] : lmem_data_out_0[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] ; 
      assign rd_data_arr_1[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)] = lmem_data_out_1[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)];
    end
    
    assign rd_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))] = rd_layer ? rd_data_arr_1[j_p] : rd_data_arr_0[j_p];

  end
endgenerate

genvar l_nb;
generate 
 // to Lmem: loadllr15, loadllr14, ..., loadllr0
 // loadllr of width 32xW
  for(l_nb=0;l_nb<=Nb-1;l_nb=l_nb+1) begin: Nb16_loop2
    assign lmem_loaddata_in[l_nb] = load_data[((l_nb+1)*32*W)-1:(l_nb*32*W)];
  end
endgenerate

genvar l_kb;
generate
  for(l_kb=0;l_kb<=Kb-1;l_kb=l_kb+1) begin: Kb14_loop
    //hard decision data vec = { M13, M12, ..., M1, M0}
    // M# : 32 bit hard decision data from 1 circulant section.
    assign unload_HDout_vec[((l_kb+1)*(HDWIDTH))-1:(l_kb*(HDWIDTH))] = unload_HDout[l_kb];
  end
endgenerate
    

//genvar i,j,k;
//generate 
//for(i=0;i<=Nb-1;i=i+1) begin: Nb_loop
//  for(j=0;j<=P-1;j=j+1) begin: P26_loop
//    for(k=0;k<=Wt-1;k=k+1) begin: Wt_loop
////      assign wr_data_arr[j][i][k] = wr_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)];
////      assign rd_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)] = rd_data_arr[j][i][k];
      
////      assign lmem_data_in[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )] = wr_data_arr[j][i][k]; 
////      assign rd_data_arr[j][i][k] = lmem_data_out[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )]; 
      
//      assign lmem_data_in[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )] = wr_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)];
//      assign rd_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)] = lmem_data_out[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )];

//    end
//  end
//end
//endgenerate  

//wr_en and rd_en is based on layer
assign wr_en0to1 = wr_layer ? 0 : wr_en;//lyr=1 : lyr=0
assign rd_en0to1 = rd_layer ? rd_en : 0;//lyr=1 : lyr=0

assign wr_en1to0= wr_layer ? wr_en : 0;//lyr=1 : lyr=0
assign rd_en1to0 = rd_layer ? 0 : (firstiter ? 0 : rd_en);//lyr=1 : lyr=0
assign rd_enloadto0 = rd_layer ? 0 : (firstiter ? rd_en : 0);

assign rd_address_0 = rd_layer ? 0 : rd_address;
assign rd_address_1 = rd_layer ? rd_address : 0;

//instances

//write result of Layer0 to fifoq and read via mux in Layer1 pattern:
defparam lmemcirc_0_0.w=W; //lmemcirc_0_0.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ0_scripted lmemcirc_0_0(lmem_data_out_0[0], lmem_data_in[0], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_1.w=W; //lmemcirc_0_1.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ1_scripted lmemcirc_0_1(lmem_data_out_0[1], lmem_data_in[1], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_2.w=W; //lmemcirc_0_2.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ2_scripted lmemcirc_0_2(lmem_data_out_0[2], lmem_data_in[2], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_3.w=W; //lmemcirc_0_3.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ3_scripted lmemcirc_0_3(lmem_data_out_0[3], lmem_data_in[3], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_4.w=W; //lmemcirc_0_4.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ4_scripted lmemcirc_0_4(lmem_data_out_0[4], lmem_data_in[4], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_5.w=W; //lmemcirc_0_5.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ5_scripted lmemcirc_0_5(lmem_data_out_0[5], lmem_data_in[5], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_6.w=W; //lmemcirc_0_6.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ6_scripted lmemcirc_0_6(lmem_data_out_0[6], lmem_data_in[6], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_7.w=W; //lmemcirc_0_7.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ7_scripted lmemcirc_0_7(lmem_data_out_0[7], lmem_data_in[7], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_8.w=W; //lmemcirc_0_8.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ8_scripted lmemcirc_0_8(lmem_data_out_0[8], lmem_data_in[8], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_9.w=W; //lmemcirc_0_9.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ9_scripted lmemcirc_0_9(lmem_data_out_0[9], lmem_data_in[9], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_10.w=W; //lmemcirc_0_10.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ10_scripted lmemcirc_0_10(lmem_data_out_0[10], lmem_data_in[10], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_11.w=W; //lmemcirc_0_11.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ11_scripted lmemcirc_0_11(lmem_data_out_0[11], lmem_data_in[11], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_12.w=W; //lmemcirc_0_12.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ12_scripted lmemcirc_0_12(lmem_data_out_0[12], lmem_data_in[12], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_13.w=W; //lmemcirc_0_13.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ13_scripted lmemcirc_0_13(lmem_data_out_0[13], lmem_data_in[13], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_14.w=W; //lmemcirc_0_14.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ14_scripted lmemcirc_0_14(lmem_data_out_0[14], lmem_data_in[14], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_15.w=W; //lmemcirc_0_15.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ15_scripted lmemcirc_0_15(lmem_data_out_0[15], lmem_data_in[15], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);


//write result of Layer1 to fifoq and read via mux in Layer0 pattern, if unload enabled, read HD data via mux in Unload pattern:
defparam lmemcirc_1_0.w=W; //lmemcirc_1_0.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ0_scripted lmemcirc_1_0(unload_HDout[0],unload_en,unloadAddress, lmem_data_out_1[0], lmem_data_in[0], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_1.w=W; //lmemcirc_1_1.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ1_scripted lmemcirc_1_1(unload_HDout[1],unload_en,unloadAddress, lmem_data_out_1[1], lmem_data_in[1], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_2.w=W; //lmemcirc_1_2.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ2_scripted lmemcirc_1_2(unload_HDout[2],unload_en,unloadAddress, lmem_data_out_1[2], lmem_data_in[2], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_3.w=W; //lmemcirc_1_3.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ3_scripted lmemcirc_1_3(unload_HDout[3],unload_en,unloadAddress, lmem_data_out_1[3], lmem_data_in[3], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_4.w=W; //lmemcirc_1_4.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ4_scripted lmemcirc_1_4(unload_HDout[4],unload_en,unloadAddress, lmem_data_out_1[4], lmem_data_in[4], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_5.w=W; //lmemcirc_1_5.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ5_scripted lmemcirc_1_5(unload_HDout[5],unload_en,unloadAddress, lmem_data_out_1[5], lmem_data_in[5], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_6.w=W; //lmemcirc_1_6.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ6_scripted lmemcirc_1_6(unload_HDout[6],unload_en,unloadAddress, lmem_data_out_1[6], lmem_data_in[6], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_7.w=W; //lmemcirc_1_7.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ7_scripted lmemcirc_1_7(unload_HDout[7],unload_en,unloadAddress, lmem_data_out_1[7], lmem_data_in[7], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_8.w=W; //lmemcirc_1_8.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ8_scripted lmemcirc_1_8(unload_HDout[8],unload_en,unloadAddress, lmem_data_out_1[8], lmem_data_in[8], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_9.w=W; //lmemcirc_1_9.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ9_scripted lmemcirc_1_9(unload_HDout[9],unload_en,unloadAddress, lmem_data_out_1[9], lmem_data_in[9], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_10.w=W; //lmemcirc_1_10.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ10_scripted lmemcirc_1_10(unload_HDout[10],unload_en,unloadAddress, lmem_data_out_1[10], lmem_data_in[10], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_11.w=W; //lmemcirc_1_11.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ11_scripted lmemcirc_1_11(unload_HDout[11],unload_en,unloadAddress, lmem_data_out_1[11], lmem_data_in[11], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_12.w=W; //lmemcirc_1_12.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ12_scripted lmemcirc_1_12(unload_HDout[12],unload_en,unloadAddress, lmem_data_out_1[12], lmem_data_in[12], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_13.w=W; //lmemcirc_1_13.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ13_scripted lmemcirc_1_13(unload_HDout[13],unload_en,unloadAddress, lmem_data_out_1[13], lmem_data_in[13], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
//write result of Layer1 to fifoq and read via mux in Layer0 pattern, without unload mux:
defparam lmemcirc_1_14.w=W; //lmemcirc_1_14.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ14_scripted lmemcirc_1_14(lmem_data_out_1[14], lmem_data_in[14], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_15.w=W; //lmemcirc_1_15.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ15_scripted lmemcirc_1_15(lmem_data_out_1[15], lmem_data_in[15], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);


//write fresh data in Load pattern to fifoq and read via mux in Layer0 pattern:
defparam lmemloadtolyr0_0.w=W;// lmemloadtolyr0_0.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_0 lmemloadtolyr0_0(lmem_data_out_init[0], lmem_loaddata_in[0], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_1.w=W;// lmemloadtolyr0_1.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_1 lmemloadtolyr0_1(lmem_data_out_init[1], lmem_loaddata_in[1], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_2.w=W;// lmemloadtolyr0_2.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_2 lmemloadtolyr0_2(lmem_data_out_init[2], lmem_loaddata_in[2], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_3.w=W;// lmemloadtolyr0_3.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_3 lmemloadtolyr0_3(lmem_data_out_init[3], lmem_loaddata_in[3], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_4.w=W;// lmemloadtolyr0_4.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_4 lmemloadtolyr0_4(lmem_data_out_init[4], lmem_loaddata_in[4], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_5.w=W;// lmemloadtolyr0_5.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_5 lmemloadtolyr0_5(lmem_data_out_init[5], lmem_loaddata_in[5], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_6.w=W;// lmemloadtolyr0_6.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_6 lmemloadtolyr0_6(lmem_data_out_init[6], lmem_loaddata_in[6], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_7.w=W;// lmemloadtolyr0_7.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_7 lmemloadtolyr0_7(lmem_data_out_init[7], lmem_loaddata_in[7], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_8.w=W;// lmemloadtolyr0_8.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_8 lmemloadtolyr0_8(lmem_data_out_init[8], lmem_loaddata_in[8], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_9.w=W;// lmemloadtolyr0_9.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_9 lmemloadtolyr0_9(lmem_data_out_init[9], lmem_loaddata_in[9], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_10.w=W;// lmemloadtolyr0_10.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_10 lmemloadtolyr0_10(lmem_data_out_init[10], lmem_loaddata_in[10], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_11.w=W;// lmemloadtolyr0_11.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_11 lmemloadtolyr0_11(lmem_data_out_init[11], lmem_loaddata_in[11], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_12.w=W;// lmemloadtolyr0_12.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_12 lmemloadtolyr0_12(lmem_data_out_init[12], lmem_loaddata_in[12], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_13.w=W;// lmemloadtolyr0_13.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_13 lmemloadtolyr0_13(lmem_data_out_init[13], lmem_loaddata_in[13], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_14.w=W;// lmemloadtolyr0_14.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_14 lmemloadtolyr0_14(lmem_data_out_init[14], lmem_loaddata_in[14], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_15.w=W;// lmemloadtolyr0_15.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_15 lmemloadtolyr0_15(lmem_data_out_init[15], lmem_loaddata_in[15], rd_address_0, loaden, rd_enloadto0, clk,rst);
//instances

endmodule
