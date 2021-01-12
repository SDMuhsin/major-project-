`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 15:46:31
// Design Name: 
// Module Name: lmem_combined_align
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


module lmem_combined_align(unload_HDout_vec_regout,unload_en_regin,unloadAddress_regin,rd_data_regout,rd_en_regin,rd_address_regin, load_data_regin,loaden_regin, wr_data_regin,wr_en_regin, firstiter_regin, clk,rst

    );
    
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
    output reg [(P*Nb*Wt*W)-1:0] rd_data_regout;
    input rd_en_regin;
    input [ADDRESSWIDTH-1:0] rd_address_regin;
    input [(32*Nb*W)-1:0] load_data_regin;
    input loaden_regin;
    input [(P*Nb*Wt*W)-1:0] wr_data_regin;
    input wr_en_regin;
    input firstiter_regin; //from controller send after fsm start, iff (itr==0), first iter=1.
    input clk,rst;
    input unload_en_regin;
    input [ADDRESSWIDTH-1:0] unloadAddress_regin;
    output reg [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;
    
    
    wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec;
    reg unload_en;
    reg [ADDRESSWIDTH-1:0] unloadAddress;
    wire [32*w-1:0]rxIn[Nb-1:0];
    wire [(P*Nb*Wt*W)-1:0] rd_data;
    reg [(32*Nb*W)-1:0] load_data;
    reg load_input_en;
    reg [(P*Nb*Wt*W)-1:0] wr_data;
    reg iteration_0_indicator;
    reg wr_en1to0, rd_en1to0;
    reg [ADDRESSWIDTH-1:0] rd_address_0, rd_address_1;
    
    always@(posedge clk)
    begin
      if(rst)
      begin
          unload_HDout_vec_regout <= 0;
      unload_en <=0;
      unloadAddress <=0;
        rd_data_regout <=0;
        rd_en1to0 <=0;
        rd_address_1 <=0;
        load_data <=0;
        load_input_en <=0;
        wr_data <=0;
        wr_en1to0 <=0;
        iteration_0_indicator<=0;    
      end
      else
      begin
    unload_HDout_vec_regout <= unload_HDout_vec;
      rd_data_regout<=rd_data;
      unload_en<= unload_en_regin;
      unloadAddress<=unloadAddress_regin;
        rd_en1to0<=rd_en_regin;
        rd_address_1<=rd_address_regin;
        load_data<=load_data_regin;
        load_input_en<=loaden_regin;
        wr_data<=wr_data_regin;
        wr_en1to0<=wr_en_regin;
        iteration_0_indicator<=firstiter_regin;  
      end
    end
    //registered input and output
    
    //wire [W-1:0] wr_data_arr[P-1:0][Nb-1:0][Wt-1:0];
    //wire [W-1:0] rd_data_arr[P-1:0][Nb-1:0][Wt-1:0];
    
    //
    wire [HDWIDTH-1:0] unload_HDout[Kb-1:0];
    wire [(32*W)-1:0] lmem_loaddata_in[Nb-1:0];
    wire [r*w-1:0]lmem_data_in[Nb-1:0];//lmem_data_in_1[Nb-1:0];
    wire [r*w-1:0]lmem_data_out_0[Nb-1:0],lmem_data_out_1[Nb-1:0], lmem_data_out_init[Nb-1:0];// r numbers of w bits    wire rd_enloadto0
    
    wire [(Nb*Wt*W)-1:0] wr_data_arr[P-1:0];
    wire [(Nb*Wt*W)-1:0] rd_data_arr_1[P-1:0];
    
    //Splitting bit vector data to individual data to be fed to each circulant
    genvar j_p, i_nb;
    generate 
      for(j_p=0;j_p<=P-1;j_p=j_p+1) begin: p26_loop
        assign wr_data_arr[j_p] = wr_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))];
        
        for(i_nb=0;i_nb<=Nb-1;i_nb=i_nb+1) begin: Nb16_loop
          assign lmem_data_in[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] = wr_data_arr[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)];
          assign rd_data_arr_1[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)] = lmem_data_out_1[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)];
        end
        
        assign rd_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))] = rd_data_arr_1[j_p];
    
      end
    endgenerate
    
    genvar l_nb;
    generate 
     // to Lmem: loadllr15, loadllr14, ..., loadllr0
     // loadllr of width 32xW
      for(l_nb=0;l_nb<=Nb-1;l_nb=l_nb+1) begin: Nb16_loop2
        assign rxIn[l_nb] = load_data[((l_nb+1)*32*W)-1:(l_nb*32*W)];
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
    
    //instances
    
    //write result of Layer1 to fifoq and read via mux in Layer0 pattern, if unload enabled, read HD data via mux in Unload pattern:
    defparam lmemcirc_1_0.w=W; //lmemcirc_1_0.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ0_combined_ys_yu_scripted lmemcirc_1_0(unload_HDout[0],unload_en,unloadAddress,lmem_data_out_1[0], lmem_data_in[0], rxIn[0], load_input_en, iteration_0_indicator, wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_1.w=W; //lmemcirc_1_1.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ1_combined_ys_yu_scripted lmemcirc_1_1(unload_HDout[1],unload_en,unloadAddress,lmem_data_out_1[1], lmem_data_in[1],  rxIn[1], load_input_en, iteration_0_indicator, wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_2.w=W; //lmemcirc_1_2.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ2_combined_ys_yu_scripted lmemcirc_1_2(unload_HDout[2],unload_en,unloadAddress,lmem_data_out_1[2], lmem_data_in[2], rxIn[2], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_3.w=W; //lmemcirc_1_3.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ3_combined_ys_yu_scripted lmemcirc_1_3(unload_HDout[3],unload_en,unloadAddress,lmem_data_out_1[3], lmem_data_in[3], rxIn[3], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_4.w=W; //lmemcirc_1_4.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ4_combined_ys_yu_scripted lmemcirc_1_4(unload_HDout[4],unload_en,unloadAddress,lmem_data_out_1[4], lmem_data_in[4], rxIn[4], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_5.w=W; //lmemcirc_1_5.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ5_combined_ys_yu_scripted lmemcirc_1_5(unload_HDout[5],unload_en,unloadAddress,lmem_data_out_1[5], lmem_data_in[5], rxIn[5], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_6.w=W; //lmemcirc_1_6.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ6_combined_ys_yu_scripted lmemcirc_1_6(unload_HDout[6],unload_en,unloadAddress,lmem_data_out_1[6], lmem_data_in[6], rxIn[6], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_7.w=W; //lmemcirc_1_7.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ7_combined_ys_yu_scripted lmemcirc_1_7(unload_HDout[7],unload_en,unloadAddress,lmem_data_out_1[7], lmem_data_in[7], rxIn[7], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_8.w=W; //lmemcirc_1_8.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ8_combined_ys_yu_scripted lmemcirc_1_8(unload_HDout[8],unload_en,unloadAddress,lmem_data_out_1[8], lmem_data_in[8], rxIn[8], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_9.w=W; //lmemcirc_1_9.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ9_combined_ys_yu_scripted lmemcirc_1_9(unload_HDout[9],unload_en,unloadAddress,lmem_data_out_1[9], lmem_data_in[9], rxIn[9], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_10.w=W; //lmemcirc_1_10.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ10_combined_ys_yu_scripted lmemcirc_1_10(unload_HDout[10],unload_en,unloadAddress,lmem_data_out_1[10], lmem_data_in[10], rxIn[10], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_11.w=W; //lmemcirc_1_11.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ11_combined_ys_yu_scripted lmemcirc_1_11(unload_HDout[11],unload_en,unloadAddress,lmem_data_out_1[11], lmem_data_in[11], rxIn[11], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_12.w=W; //lmemcirc_1_12.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ12_combined_ys_yu_scripted lmemcirc_1_12(unload_HDout[12],unload_en,unloadAddress,lmem_data_out_1[12], lmem_data_in[12], rxIn[12], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_13.w=W; //lmemcirc_1_13.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ13_combined_ys_yu_scripted lmemcirc_1_13(unload_HDout[13],unload_en,unloadAddress,lmem_data_out_1[13], lmem_data_in[13], rxIn[13], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    //write result of Layer1 to fifoq and read via mux in Layer0 pattern, without unload mux:
    defparam lmemcirc_1_14.w=W; //lmemcirc_1_14.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ14_combined_ys_yu_scripted lmemcirc_1_14(lmem_data_out_1[14], lmem_data_in[14], rxIn[14], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    defparam lmemcirc_1_15.w=W; //lmemcirc_1_15.r=P*Wt; //addresswidth is constant at 5.
    LMem1To0_511_circ15_combined_ys_yu_scripted lmemcirc_1_15(lmem_data_out_1[15], lmem_data_in[15], rxIn[15], load_input_en, iteration_0_indicator,  wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
    
endmodule
