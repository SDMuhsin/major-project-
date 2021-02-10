`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.01.2021 06:45:46
// Design Name: 
// Module Name: Lmem_SRQtype_combined_ns_reginout_pipeV1
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
// LMem1To0_511_circ0_combined_ns_yu_scripted: Lmem load to lyr 0 inputQueue+ Lmem lyr1 to lyr 0 with unload align for first 14 blocks, without unload align for remaining blocks
// LMem1To0_511_wunload_circ#_scripted: Unload align circuit sends 1 to 7136 (19 to 7154) shortened systematic part in 32 bits at a time.
//firstprocessing_indicate = firstiter=((itr==0)&&(lyr==0)); 
//use negated reset from top module.
// Pipelined Version1: this design.
// cycle0->1->2->3
// (addressRdReq,FirstIterRdReq,LayerRdReq)->AddressRd happens,(FirstIterRdReq,LayerRdReq)->FirstiterRdhappens,(LayerRdReq)->Readhappens at regout
// Pipelined Version2: unused.
// cycle0->1->2
// (addressRdReq,FirstIterRdReq,LayerRdReq)->AddressRd happens, (FirstIterRdReq,LayerRdReq)->Readhappens at regout
//////////////////////////////////////////////////////////////////////////////////


//module Lmem_SRQtype_combined_ns_reginout_pipeV1(unload_HDout_vec_regout,rd_data_regout,unload_en_regin,unloadAddress_regin,rd_en_regin,rd_address_regin,rd_layer_regin, load_data_regin,loaden_regin, wr_data_regin,wr_en_regin,wr_layer_regin, firstiter_regin, clk,rst);
module Lmem_SRQtype_combined_ns_regout_pipeV1(unload_HDout_vec_regout,rd_data_regout, unload_en,unloadAddress,rd_en,rd_address,rd_layer_reg0, load_data,loaden, wr_data,wr_en,wr_layer, firstiter_reg0, clk,rst);
parameter W=6;//6;//configurable by user
parameter maxVal = 6'b011111;

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
input unload_en;
input [ADDRESSWIDTH-1:0] unloadAddress;
input rd_en;
input [ADDRESSWIDTH-1:0] rd_address;
   //input rd_layer;
input rd_layer_reg0;
input [(32*Nb*W)-1:0] load_data;
input loaden;
input [(P*Nb*Wt*W)-1:0] wr_data;
input wr_en;
input wr_layer;
  //input firstiter; //from controller send after fsm start, iff (itr==0), first iter=1.
input firstiter_reg0; //from controller send after fsm start, iff (itr==0), first iter=1.  
input clk,rst;

//registered input and output
output reg [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;
output reg [(P*Nb*Wt*W)-1:0] rd_data_regout;
//input unload_en_regin;
//input [ADDRESSWIDTH-1:0] unloadAddress_regin;
//input rd_en_regin;
//input [ADDRESSWIDTH-1:0] rd_address_regin;
//input rd_layer_regin;
//input [(32*Nb*W)-1:0] load_data_regin;
//input loaden_regin;
//input [(P*Nb*Wt*W)-1:0] wr_data_regin;
//input wr_en_regin;
//input wr_layer_regin;
//input firstiter_regin; //from controller send after fsm start, iff (itr==0), first iter=1.
//input clk,rst;

wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec;
wire [(P*Nb*Wt*W)-1:0] rd_data;
//reg unload_en;
//reg [ADDRESSWIDTH-1:0] unloadAddress;
//reg rd_en;
//reg [ADDRESSWIDTH-1:0] rd_address;
//reg rd_layer_reg0;
reg rd_layer, rd_layer_reg1;
//reg [(32*Nb*W)-1:0] load_data;
//reg loaden;
//reg [(P*Nb*Wt*W)-1:0] wr_data;
//reg wr_en;
//reg wr_layer;
//reg  firstiter_reg0;
reg firstiter;

always@(posedge clk)
begin
  if(rst)
  begin
    unload_HDout_vec_regout <= 0;
    rd_data_regout <=0;
//    unload_en <=0;
//    unloadAddress <=0;
//    rd_en <=0;
//    rd_address <=0;
//    rd_layer_reg0<=0;
//    load_data <=0;
//    loaden <=0;
//    wr_data <=0;
//    wr_en <=0;
//    wr_layer <=0;
//    firstiter_reg0<=0;   
    //pipe_registers version 1
    firstiter <=0; 
    rd_layer <=0;
    rd_layer_reg1<=0;    
  end
  else
  begin
    unload_HDout_vec_regout <= unload_HDout_vec;
    rd_data_regout<=rd_data;
//    unload_en<= unload_en_regin;
//    unloadAddress<=unloadAddress_regin;
//    rd_en<=rd_en_regin;
//    rd_address<=rd_address_regin;
    //rd_layer<=rd_layer_regin;
//    rd_layer_reg0<=rd_layer_regin;
//    load_data<=load_data_regin;
//    loaden<=loaden_regin;
//    wr_data<=wr_data_regin;
//    wr_en<=wr_en_regin;
//    wr_layer<=wr_layer_regin;
    //firstiter<=firstiter_regin;
//    firstiter_reg0<=firstiter_regin;  
    //pipe_registers 
    firstiter<=firstiter_reg0;

    //pipereg version 1 
    rd_layer_reg1<=rd_layer_reg0;       
    rd_layer<=rd_layer_reg1;
    //pipereg version 2
//    rd_layer_reg1<=rd_layer;
  end
end
//registered input and output

//wire [W-1:0] wr_data_arr[P-1:0][Nb-1:0][Wt-1:0];
//wire [W-1:0] rd_data_arr[P-1:0][Nb-1:0][Wt-1:0];

//
wire [HDWIDTH-1:0] unload_HDout[Kb-1:0];
wire [(32*W)-1:0] lmem_loaddata_in[Nb-1:0];
wire [r*w-1:0]lmem_data_in[Nb-1:0];//,lmem_data_in_1[Nb-1:0];
wire [r*w-1:0]lmem_data_out_0to1[Nb-1:0],lmem_data_out_1to0[Nb-1:0], lmem_data_out_init[Nb-1:0];// r numbers of w bits
wire wr_en0to1, rd_en0to1;
wire wr_en1to0, rd_en1to0;
wire rd_enloadto0;
wire [ADDRESSWIDTH-1:0] rd_address_0to1, rd_address_1to0, rd_address_loadto0;

//aligning according to row calculation unit
//LLR to Row Calculation Unit = {LLR_25, LLR_24, ...., LLR_2, LLR_1, LLR_0}.
// LLR_# is of width= NbxWtxW = 16x2xW=32xW.
wire [(Nb*Wt*W)-1:0] wr_data_arr[P-1:0];
wire [(Nb*Wt*W)-1:0] rd_data_arr_0to1[P-1:0];
wire [(Nb*Wt*W)-1:0] rd_data_arr_1to0[P-1:0];
//Pipe regs: 
reg [(Nb*Wt*W)-1:0] rd_data_arr_0to1_reg0[P-1:0],rd_data_arr_0to1_reg1[P-1:0]; //use only reg1 if pipeversion 2, for pipeversion1 use both
reg [(Nb*Wt*W)-1:0] rd_data_arr_1to0_reg0[P-1:0];

//Splitting bit vector data to individual data to be fed to each circulant
genvar j_p, i_nb;
generate 
  for(j_p=0;j_p<=P-1;j_p=j_p+1) begin: p26_loop
    assign wr_data_arr[j_p] = wr_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))];
    
    //aligning according to Mem circuits
    //LLR to/fro memciruits = MLLR_15, MLLR_14, ..., MLLR_2, MLLR_1, MLLR_0
    // MLLR_# is of width = PxWtxW = 26x2xW=52xW.
    //--------------------Bug in interconnection pattern--------------------//
    // Correct pattern in detail:
    // lmem_data_in[i_nb]: {m51, m50, m49, ..., m28, m27, m26,| m25, m24, m23, ..., m2, m1, m0}
    // wr_data_arr[j_p]: {rcu_jp_31, rcu_jp_30, rcu_jp_29, rcu_jp_28, ..., rcu_jp_4, rcu_jp_3, rcu_jp_2, rcu_jp_1, rcu_jp_0}
    // connection: m0 <-> rcu_0_0 ; m1<-> rcu_1_0 ; ... ; m25<-> rcu_25_0 ; 
    // m26<-> rcu_0_1 ; m27<-> rcu_1_1 ; ... ; m51<-> rcu_25_1.
    for(i_nb=0;i_nb<=Nb-1;i_nb=i_nb+1) begin: Nb16_loop
      assign lmem_data_in[i_nb][((j_p+1)*W)-1:((j_p)*W)] = wr_data_arr[j_p][(((i_nb*2)+1)*W)-1:((i_nb*2)*W)];
      assign lmem_data_in[i_nb][((j_p+P+1)*W)-1:((j_p+P)*W)] = wr_data_arr[j_p][(((i_nb*2)+2)*W)-1:(((i_nb*2)+1)*W)];
      
      //assign lmem_data_in[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] = wr_data_arr[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)];
      
      assign rd_data_arr_1to0[j_p][(((i_nb*2)+1)*W)-1:((i_nb*2)*W)] = lmem_data_out_1to0[i_nb][((j_p+1)*W)-1:((j_p)*W)]; 
      assign rd_data_arr_1to0[j_p][(((i_nb*2)+2)*W)-1:(((i_nb*2)+1)*W)]= lmem_data_out_1to0[i_nb][((j_p+P+1)*W)-1:((j_p+P)*W)]; 
      
      //assign rd_data_arr_1to0[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)] = lmem_data_out_1to0[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] ; 
      
      assign rd_data_arr_0to1[j_p][(((i_nb*2)+1)*W)-1:((i_nb*2)*W)] = lmem_data_out_0to1[i_nb][((j_p+1)*W)-1:((j_p)*W)];
      assign rd_data_arr_0to1[j_p][(((i_nb*2)+2)*W)-1:(((i_nb*2)+1)*W)] = lmem_data_out_0to1[i_nb][((j_p+P+1)*W)-1:((j_p+P)*W)];
      
      //assign rd_data_arr_0to1[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)] = lmem_data_out_0to1[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)];
    end
    
    //Same as assigning rd_data_arr_1to0 with lmem_data_out_1to0_reg
    //Same as assigning rd_data_arr_0to1 with lmem_data_out_0to1_reg
    always@(posedge clk)
    begin
      if(!rst)
      begin
        rd_data_arr_1to0_reg0[j_p]<=0;
        rd_data_arr_0to1_reg0[j_p]<=0;//for pipeversion1 only, comment for pipeversion2//before firstiter mux reg
        rd_data_arr_0to1_reg1[j_p]<=0;//for pipeversion1, for pipeversion2//after first iter mux  reg
      end
      else
      begin
        rd_data_arr_1to0_reg0[j_p]<=rd_data_arr_1to0[j_p];
        rd_data_arr_0to1_reg0[j_p]<=rd_data_arr_0to1[j_p];//for pipeversion1 only, comment for pipeversion2
        rd_data_arr_0to1_reg1[j_p]<=rd_data_arr_0to1_reg0[j_p];//for pipeversion1 //rd_data_arr_0to1[j_p];//for pipeverison2
      end
    end
    
    assign rd_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))] = rd_layer ? rd_data_arr_0to1_reg1[j_p] : rd_data_arr_1to0_reg0[j_p];//lyr1:lyr0
    //assign rd_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))] = rd_layer ? rd_data_arr_0to1[j_p] : rd_data_arr_1to0[j_p];//lyr1:lyr0

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

//wr_en and rd_en is based on layer
assign wr_en0to1 = wr_layer ? 0 : wr_en;//lyr=1 : lyr=0
assign wr_en1to0= wr_layer ? wr_en : 0;//lyr=1 : lyr=0

//For Shift Disabled Combined LMEM: Layer mux is kepth at output selection only. Mux at input is redundant.
assign rd_en1to0 = rd_en;//
assign rd_address_1to0 =  rd_address;

assign rd_en0to1 =  rd_en ;//
assign rd_address_0to1 =rd_address;

//instances

//write result of Layer0 to fifoq and read via mux in Layer1 pattern:
defparam lmemcirc_01_0.w=W, lmemcirc_01_0.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ0_scripted lmemcirc_01_0(lmem_data_out_0to1[0], lmem_data_in[0], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_1.w=W, lmemcirc_01_1.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ1_scripted lmemcirc_01_1(lmem_data_out_0to1[1], lmem_data_in[1], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_2.w=W, lmemcirc_01_2.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ2_scripted lmemcirc_01_2(lmem_data_out_0to1[2], lmem_data_in[2], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_3.w=W, lmemcirc_01_3.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ3_scripted lmemcirc_01_3(lmem_data_out_0to1[3], lmem_data_in[3], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_4.w=W, lmemcirc_01_4.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ4_scripted lmemcirc_01_4(lmem_data_out_0to1[4], lmem_data_in[4], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_5.w=W, lmemcirc_01_5.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ5_scripted lmemcirc_01_5(lmem_data_out_0to1[5], lmem_data_in[5], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_6.w=W, lmemcirc_01_6.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ6_scripted lmemcirc_01_6(lmem_data_out_0to1[6], lmem_data_in[6], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_7.w=W, lmemcirc_01_7.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ7_scripted lmemcirc_01_7(lmem_data_out_0to1[7], lmem_data_in[7], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_8.w=W, lmemcirc_01_8.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ8_scripted lmemcirc_01_8(lmem_data_out_0to1[8], lmem_data_in[8], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_9.w=W, lmemcirc_01_9.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ9_scripted lmemcirc_01_9(lmem_data_out_0to1[9], lmem_data_in[9], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_10.w=W, lmemcirc_01_10.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ10_scripted lmemcirc_01_10(lmem_data_out_0to1[10], lmem_data_in[10], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_11.w=W, lmemcirc_01_11.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ11_scripted lmemcirc_01_11(lmem_data_out_0to1[11], lmem_data_in[11], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_12.w=W, lmemcirc_01_12.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ12_scripted lmemcirc_01_12(lmem_data_out_0to1[12], lmem_data_in[12], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_13.w=W, lmemcirc_01_13.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ13_scripted lmemcirc_01_13(lmem_data_out_0to1[13], lmem_data_in[13], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_14.w=W, lmemcirc_01_14.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ14_scripted lmemcirc_01_14(lmem_data_out_0to1[14], lmem_data_in[14], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_15.w=W, lmemcirc_01_15.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ15_scripted lmemcirc_01_15(lmem_data_out_0to1[15], lmem_data_in[15], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);


//load new codesymbols in load pattern to fifoq OR write result of Layer1 to fifoq and read via mux in Layer0 pattern, if unload enabled, read HD data via mux in Unload pattern:
defparam lmemcirc_10_0.w=W, lmemcirc_10_0.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ0_combined_ns_yu_pipelined_scripted lmemcirc_10_0(unload_HDout[0],unload_en,unloadAddress, lmem_data_out_1to0[0], lmem_data_in[0], lmem_loaddata_in[0], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_1.w=W, lmemcirc_10_1.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ1_combined_ns_yu_pipelined_scripted lmemcirc_10_1(unload_HDout[1],unload_en,unloadAddress, lmem_data_out_1to0[1], lmem_data_in[1], lmem_loaddata_in[1], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_2.w=W, lmemcirc_10_2.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ2_combined_ns_yu_pipelined_scripted lmemcirc_10_2(unload_HDout[2],unload_en,unloadAddress, lmem_data_out_1to0[2], lmem_data_in[2], lmem_loaddata_in[2], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_3.w=W, lmemcirc_10_3.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ3_combined_ns_yu_pipelined_scripted lmemcirc_10_3(unload_HDout[3],unload_en,unloadAddress, lmem_data_out_1to0[3], lmem_data_in[3], lmem_loaddata_in[3], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_4.w=W, lmemcirc_10_4.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ4_combined_ns_yu_pipelined_scripted lmemcirc_10_4(unload_HDout[4],unload_en,unloadAddress, lmem_data_out_1to0[4], lmem_data_in[4], lmem_loaddata_in[4], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_5.w=W, lmemcirc_10_5.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ5_combined_ns_yu_pipelined_scripted lmemcirc_10_5(unload_HDout[5],unload_en,unloadAddress, lmem_data_out_1to0[5], lmem_data_in[5], lmem_loaddata_in[5], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_6.w=W, lmemcirc_10_6.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ6_combined_ns_yu_pipelined_scripted lmemcirc_10_6(unload_HDout[6],unload_en,unloadAddress, lmem_data_out_1to0[6], lmem_data_in[6], lmem_loaddata_in[6], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_7.w=W, lmemcirc_10_7.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ7_combined_ns_yu_pipelined_scripted lmemcirc_10_7(unload_HDout[7],unload_en,unloadAddress, lmem_data_out_1to0[7], lmem_data_in[7], lmem_loaddata_in[7], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_8.w=W, lmemcirc_10_8.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ8_combined_ns_yu_pipelined_scripted lmemcirc_10_8(unload_HDout[8],unload_en,unloadAddress, lmem_data_out_1to0[8], lmem_data_in[8], lmem_loaddata_in[8], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_9.w=W, lmemcirc_10_9.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ9_combined_ns_yu_pipelined_scripted lmemcirc_10_9(unload_HDout[9],unload_en,unloadAddress, lmem_data_out_1to0[9], lmem_data_in[9], lmem_loaddata_in[9], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_10.w=W, lmemcirc_10_10.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ10_combined_ns_yu_pipelined_scripted lmemcirc_10_10(unload_HDout[10],unload_en,unloadAddress, lmem_data_out_1to0[10], lmem_data_in[10], lmem_loaddata_in[10], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_11.w=W, lmemcirc_10_11.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ11_combined_ns_yu_pipelined_scripted lmemcirc_10_11(unload_HDout[11],unload_en,unloadAddress, lmem_data_out_1to0[11], lmem_data_in[11], lmem_loaddata_in[11], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_12.w=W, lmemcirc_10_12.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ12_combined_ns_yu_pipelined_scripted lmemcirc_10_12(unload_HDout[12],unload_en,unloadAddress, lmem_data_out_1to0[12], lmem_data_in[12], lmem_loaddata_in[12], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_13.w=W, lmemcirc_10_13.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ13_combined_ns_yu_pipelined_scripted lmemcirc_10_13(unload_HDout[13],unload_en,unloadAddress, lmem_data_out_1to0[13], lmem_data_in[13], lmem_loaddata_in[13], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
//load new codesymbols in load pattern to fifoq OR write result of Layer1 to fifoq and read via mux in Layer0 pattern, without unload mux:
defparam lmemcirc_10_14.w=W, lmemcirc_10_14.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ14_combined_ns_yu_pipelined_scripted lmemcirc_10_14( lmem_data_out_1to0[14], lmem_data_in[14], lmem_loaddata_in[14], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_15.w=W, lmemcirc_10_15.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ15_combined_ns_yu_pipelined_scripted lmemcirc_10_15( lmem_data_out_1to0[15], lmem_data_in[15], lmem_loaddata_in[15], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);

//instances

endmodule
