`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 12:45:55
// Design Name: 
// Module Name: lmem_01_combined
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


module lmem_01_combined(feedback_en_regin,rd_data_regout,rd_en_regin,rd_address_regin, wr_data_regin,wr_en_regin, clk,rst    
);
    
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
    
    output reg [(P*Nb*Wt*W)-1:0] rd_data_regout;
    input rd_en_regin;
    input feedback_en_regin;
    input [ADDRESSWIDTH-1:0] rd_address_regin;
    //input rd_layer_regin;
    input [(P*Nb*Wt*W)-1:0] wr_data_regin;
    input wr_en_regin;
    //input wr_layer_regin;
    //input firstiter_regin; //from controller send after fsm start, iff (itr==0), first iter=1.
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
    reg wr_en0to1, rd_en0to1;
    reg feedback_en;
    reg [ADDRESSWIDTH-1:0] rd_address_0;
    
    
    always@(posedge clk)
    begin
      if(rst)
      begin
        rd_data_regout <=0;
        rd_en0to1 <=0;
        rd_address_0 <=0;
        //rd_layer <=0;
        wr_data <=0;
        wr_en0to1 <=0;
        //wr_layer <=0;
        //firstiter <=0;
        feedback_en<=0;    
      end
      else
      begin
        rd_data_regout<=rd_data;
        rd_en0to1<=rd_en_regin;
        rd_address_0<=rd_address_regin;
        //rd_layer<=rd_layer_regin;;
        wr_data<=wr_data_regin;
        wr_en0to1<=wr_en_regin;
        //wr_layer<=wr_layer_regin;
        //firstiter<=firstiter_regin;  
        feedback_en<=feedback_en_regin;
      end
    end

    wire [r*w-1:0]lmem_data_in[Nb-1:0];
    wire [r*w-1:0]lmem_data_out_0[Nb-1:0],lmem_data_out_init[Nb-1:0];
   /* wire wr_en0to1, rd_en0to1;
    wire [ADDRESSWIDTH-1:0] rd_address_0;*/
    
    wire [(Nb*Wt*W)-1:0] wr_data_arr[P-1:0];
    wire [(Nb*Wt*W)-1:0] rd_data_arr_0[P-1:0];
    
    /*assign wr_en0to1=wr_en;
    assign rd_en0to1=rd_en;
    assign rd_address_0=rd_address;*/
    
    genvar j_p, i_nb;
    generate 
      for(j_p=0;j_p<=P-1;j_p=j_p+1) begin: p26_loop
        assign wr_data_arr[j_p] = wr_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))];
        
        for(i_nb=0;i_nb<=Nb-1;i_nb=i_nb+1) begin: Nb16_loop
          assign lmem_data_in[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] = wr_data_arr[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)];
          assign rd_data_arr_0[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)] = lmem_data_out_0[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] ;
        end
        
        assign rd_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))] = rd_data_arr_0[j_p];
    
      end
    endgenerate


//write result of Layer0 to fifoq and read via mux in Layer1 pattern:
defparam lmemcirc_0_0.w=W; //lmemcirc_0_0.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ0_ys_scripted lmemcirc_0_0(lmem_data_out_0[0], lmem_data_in[0], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_1.w=W; //lmemcirc_0_1.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ1_ys_scripted lmemcirc_0_1(lmem_data_out_0[1], lmem_data_in[1], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_2.w=W; //lmemcirc_0_2.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ2_ys_scripted lmemcirc_0_2(lmem_data_out_0[2], lmem_data_in[2], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_3.w=W; //lmemcirc_0_3.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ3_ys_scripted lmemcirc_0_3(lmem_data_out_0[3], lmem_data_in[3], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_4.w=W; //lmemcirc_0_4.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ4_ys_scripted lmemcirc_0_4(lmem_data_out_0[4], lmem_data_in[4], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_5.w=W; //lmemcirc_0_5.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ5_ys_scripted lmemcirc_0_5(lmem_data_out_0[5], lmem_data_in[5], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_6.w=W; //lmemcirc_0_6.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ6_ys_scripted lmemcirc_0_6(lmem_data_out_0[6], lmem_data_in[6], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_7.w=W; //lmemcirc_0_7.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ7_ys_scripted lmemcirc_0_7(lmem_data_out_0[7], lmem_data_in[7], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_8.w=W; //lmemcirc_0_8.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ8_ys_scripted lmemcirc_0_8(lmem_data_out_0[8], lmem_data_in[8], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_9.w=W; //lmemcirc_0_9.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ9_ys_scripted lmemcirc_0_9(lmem_data_out_0[9], lmem_data_in[9], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_10.w=W; //lmemcirc_0_10.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ10_ys_scripted lmemcirc_0_10(lmem_data_out_0[10], lmem_data_in[10], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_11.w=W; //lmemcirc_0_11.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ11_ys_scripted lmemcirc_0_11(lmem_data_out_0[11], lmem_data_in[11], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_12.w=W; //lmemcirc_0_12.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ12_ys_scripted lmemcirc_0_12(lmem_data_out_0[12], lmem_data_in[12], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_13.w=W; //lmemcirc_0_13.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ13_ys_scripted lmemcirc_0_13(lmem_data_out_0[13], lmem_data_in[13], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_14.w=W; //lmemcirc_0_14.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ14_ys_scripted lmemcirc_0_14(lmem_data_out_0[14], lmem_data_in[14], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_15.w=W; //lmemcirc_0_15.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ15_ys_scripted lmemcirc_0_15(lmem_data_out_0[15], lmem_data_in[15], wr_en0to1,feedback_en, rd_address_0, rd_en0to1, clk,rst);

endmodule