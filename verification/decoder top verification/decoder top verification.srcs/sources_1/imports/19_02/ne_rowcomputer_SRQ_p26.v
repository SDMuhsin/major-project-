`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2021 14:03:55
// Design Name: 
// Module Name: ne_rowcomputer_SRQ_p26
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
// User Configurable parameters: W, MAXITRS, ITRWIDTH, maxVal
// Based on RCU pipestage modifications: configure RCU_PIPESTAGES, PIPESTAGES, PIPECOUNTWIDTH
//////////////////////////////////////////////////////////////////////////////////


module ne_rowcomputer_SRQ_p26(decoder_ready,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);
//RCU
//Configurable
parameter W=6;
//non-configurable parameters
parameter Nb=16;
parameter Wc=32;
parameter Wcbits = 5;                           //2**5 =32
parameter LAYERS=2;
parameter ADDRESSWIDTH = 5;                     //2^5 = 32 > 20
parameter ADDRDEPTH = 20;                       //ceil(Z/P) = ceil(511/26)
parameter EMEMDEPTH=ADDRDEPTH*LAYERS;           //for LUT RAM //512;//for BRAM ineffcient//
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
parameter RCU_PIPESTAGES=13;

//Agen controller
//configurable
parameter MAXITRS = 10;
parameter ITRWIDTH = 4;//2**4 = 16 > 9
//non-configurable
parameter Z=511;
parameter P=26;
parameter PIPESTAGES = RCU_PIPESTAGES+1;    //memrd+RCU_PIPESTAGES//+memwr
parameter PIPECOUNTWIDTH = 4;               //2**4= 16 > 13
parameter ROWDEPTH=ADDRDEPTH;               //20=Z/P; //Z/P = 73
parameter ROWWIDTH = ADDRESSWIDTH;          // 2**5 = 32 > 20; //2**7 = 128 > 72
//last_p rowdepth and pipestages.
parameter P_LAST = Z-(P*(ROWDEPTH-1));       //511-(26*19)=511-494=17=valid lines in address 20

//bitnodemem (Lmem)
//Configurable
parameter maxVal = 6'b011111;
//non-configurable parameters
parameter Kb=14;                            //first 14 circulant columns correspond to systematic part
parameter HDWIDTH=32;                       //taking 32 hard decision bits at a time
parameter Wt=2;                             //circulant weight
parameter r=P*Wt;                           //r is predefined to be 52. non configurable.(26x2)
parameter w=W;

//Dmem
//all parameters already defined


//inout declarations
output decoder_ready;                                       //from controller
output [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;          //output from lmem
input unload_en;                                            //from output if
input [ADDRESSWIDTH-1:0] unloadAddress;                     //from output if
input [(32*Nb*W)-1:0] load_data;                            //from input if
input loaden;                                               //from ip if
input start;                                                //from ip if
input clk,rst;

//Lmem connections declarations
wire [(P*Nb*Wt*W)-1:0] rd_data_regout;                      //output to go to rcu
wire rd_en;                                                 //input from controller
wire [ADDRESSWIDTH-1:0] rd_address;                         //input from controller                         //
wire rd_layer;                                              //input from controller
wire [(P*Nb*Wt*W)-1:0] wr_data;                             //input from rcu
wire wr_en;                                                 //input from rcu
wire wr_layer;                                              //input from rcu

//Dmem
wire[(P*Nb*Wt*W)-1:0] dmem_rd_data_regout;                  //output to rcu
wire dmem_rd_en;                                            //input from rcu
wire [ADDRESSWIDTH-1:0] dmem_rd_address;                    //input from rcu
wire dmem_rd_layer;                                         //input from rcu
wire [(P*Nb*Wt*W)-1:0] dmem_wr_data;                        //input from rcu
wire dmem_wr_en;                                            //input from rcu

//RCU
wire[(Wc*(W))-1:0] updLLR_regout[P-1:0];                    //output reg out updated LLR to Lmem
wire[(Wc*(W))-1:0] Dout_regout[P-1:0];                      //output reg out updated D to Dmem
wire [(ADDRESSWIDTH+1+1)-1:0] Dmem_rden_layer_address[P-1:0];//pipereg output {rden,layer,address} for Reaccess to Dmem
wire wrlayer[P-1:0];                                         //pipereg output to Lmem
wire[P-1:0] wren;                                            //pipereg output to Lmem
wire rdlayer;                                                //from controller
wire [ADDRESSWIDTH-1:0]rdaddress;                            //from controller 
wire[P-1:0] rcu_en;                                          //rden_LLR; //RCU enable from controller
wire[P-1:0] rden_E;                                           //from controller
wire [(Wc*(W))-1:0] Lmemout[P-1:0];                           //from Lmem (assumes register at output of Lmem)
wire [(Wc*(W))-1:0] D_reaccess_in[P-1:0];                     //from Dmem (assumes register at output of Dmem)
//wire wrlayer_d[P-1:0];                                         
wire[P-1:0] wren_d; 
//wire [ADDRESSWIDTH-1:0] wraddress_d[P-1:0];

//Agen Controller
wire SISOready;                                                 //output//after whole processing  is complete
wire firstprocessing_indicate;                                  //output//to select proper Lmem (load to lyr0) unit.
wire LYRindex;                                                  //output
wire [ROWWIDTH-1:0] rowaddress;                                 //output
wire rd_L;                                                      //output->to rcu
reg loaden_reg;
// Interconnect ---
assign decoder_ready=SISOready;                                                //output from rowcomputer
assign {wr_en,wr_layer} = {wren[0],wrlayer[0]};                                //RCU write signals connect with Lmem 
assign dmem_wr_en = wren_d[0];                                                 //RCU write signals connects with Dmem write signals
assign {dmem_rd_en,dmem_rd_layer,dmem_rd_address} = Dmem_rden_layer_address[0];//RCU reaccess read signals connect with Dmem
assign {rd_en, rd_layer, rd_address} = {rd_L,LYRindex,rowaddress};             //controller connects with Lmem
assign {rdlayer, rdaddress} = {LYRindex,rowaddress};                           //controller connects with RCU
//---Interconnect

//instances---
//Controller instance
/*always@(posedge clk) begin
if(!rst) begin
loaden_reg<=0;
end
else begin
loaden_reg<=loaden;
end
end*/

defparam controller_.MAXITRS=MAXITRS, controller.ROWDEPTH=ROWDEPTH, controller.PIPESTAGES=PIPESTAGES, controller.P=P, controller.Z=Z;
defparam controller.ROWWIDTH=ROWWIDTH, controller.PIPECOUNTWIDTH=PIPECOUNTWIDTH, controller.ITRWIDTH=ITRWIDTH;
ne_AddrGenFSM_pipe controller(SISOready,firstprocessing_indicate,LYRindex,rowaddress,rden_E,rd_L,rcu_en,loaden,start,clk,rst);

//Bit Node Memory or LLR memory (Lmem) instance
defparam bitnodemem.W=W, bitnodemem.maxVal=maxVal;
//Lmem_SRQtype_combined_ns_reginout2pipe
Lmem_SRQtype_combined_ns_reginout_pipeV1  bitnodemem(unload_HDout_vec_regout,rd_data_regout,unload_en,unloadAddress,rd_en,rd_address,rd_layer, load_data,loaden, wr_data,wr_en,wr_layer, firstprocessing_indicate, clk,rst);

//Intermediate value(D) memory instance 
defparam dmem.W=W;
Dmem_SRQtype_regout dmem(dmem_rd_data_regout,dmem_rd_en,dmem_rd_address,dmem_rd_layer,dmem_wr_data,dmem_wr_en,clk,rst);

genvar p_j;
generate
  for(p_j=0;p_j<=P-1;p_j=p_j+1) begin : p26_loop
  
    assign wr_data[((p_j+1)*(Nb*Wt*W))-1:(p_j*(Nb*Wt*W))]= updLLR_regout[p_j]; 
    assign Lmemout[p_j]= rd_data_regout[((p_j+1)*(Nb*Wt*W))-1:(p_j*(Nb*Wt*W))];
    assign dmem_wr_data[((p_j+1)*(Nb*Wt*W))-1:(p_j*(Nb*Wt*W))]=Dout_regout[p_j];
    assign D_reaccess_in[p_j]= dmem_rd_data_regout[((p_j+1)*(Nb*Wt*W))-1:(p_j*(Nb*Wt*W))];
    
    //SISO (Row Calculation unit (RCU) instances
    defparam rcu.W=W;
    SISO_rowunit_pipe rcu(updLLR_regout[p_j],Dout_regout[p_j], wrlayer[p_j],wraddress ,wren[p_j],wren_d[p_j], Dmem_rden_layer_address[p_j], rdlayer,rdaddress,rcu_en[p_j],rden_E[p_j], Lmemout[p_j],D_reaccess_in[p_j],clk,rst);
  end //p_j_26_loop
  
endgenerate

//--instances
endmodule
