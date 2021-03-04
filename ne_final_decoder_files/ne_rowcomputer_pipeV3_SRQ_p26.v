`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2021 22:27:00
// Design Name: 
// Module Name: ne_rowcomputer_pipeV3_SRQ_p26
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
// For Address generator FSM: pipeline stage information should be known pre-requisite
// Agen-FF->0 Lmem/Emem Read request->FF->1 Lmem Read/Emem delayed Req->FF-> 2 Lmem firstiter Read/Emem Read happens/recov>FF->
// ->3 Lmem LayerRead happens/Sub occurs->FF->4 Abs/Norm->FF->
// ->5 m2vg->FF->6 m4vg->FF->7 m8vg->FF->8 m16vg->FF->9 m32vg->FF->10 Read Dmem/Recov/Ememwr->FF->11 SubD/Add->FF->
//-->12 writeReq->FF->13 UpdLLR/D WriteHappens/AgenNextLayer->FF->14 (nextlyrreadreq)
//0->(1->2->3->4->5->6->7->8->9->10->11->12)->13->14->
// So address gen FSM Stall cycles for each layer = 12 RCU + 2 (13 write happen,14 next rd) = 14.
// Row calculation unit(SISO) stages=12. (old=11)
//P=26 => ceil(511/26) = 20. 
// PIPEV3: 
// Adding 1 cycle after Emem read.
// Agen-FF->0 Lmem/Emem Read request->FF->1 Lmem Read/Emem Read happens,BRAM wait->FF-> 2 Lmem firstiter Read/recov>FF->
// ->3 Lmem LayerRead happens/Sub occurs->FF->4 Abs/Norm->FF->
// ->5 m2vg->FF->6 m4vg->FF->7 m8vg->FF->8 m16vg->FF->9 m32vg->FF->10 Read Dmem/Recov/Ememwr->FF->11 SubD/Add1->FF->
//-->12 Add2/DwriteReq->FF->13 UpdLLR Wr Req/D WriteHappens/AgenNextLayer->FF->14 UpdLLR WriteHappens/AgenNextLayer->FF->15 (nextlyrreadreq)
//0->(1->2->3->4->5->6->7->8->9->10->11->12->13)->14->15 
// Row calculation unit(SISO) stages=13.
// P=26 => ceil(511/26) = 20.
// Modification: Adding 1 more pipereg in Adder3in to male AdderW_3in_pipelined. and output.
// Bugfix1: to avoid continuous transmitting of same data output
// signal unloadstart as a 1 clk cycle pulse instead of long duration indicator SISOReady.
//////////////////////////////////////////////////////////////////////////////////


module ne_rowcomputer_pipeV3_SRQ_p26(decoder_ready,unload_start,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);
//RCU
//Configurable
parameter W=6;
//non-configurable parameters
parameter Nb=16;
parameter Wc=32;
parameter Wcbits = 5;//2**5 =32
parameter LAYERS=2;
parameter ADDRESSWIDTH = 5;//2^5 = 32 > 20
parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
parameter EMEMDEPTH=ADDRDEPTH*LAYERS; //for LUT RAM //512;//for BRAM ineffcient//
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
parameter PIPESTAGES = RCU_PIPESTAGES+1;//+2;//memrd+RCU_PIPESTAGES+memwr
parameter PIPECOUNTWIDTH = 4;//2**4= 16 > 14
parameter ROWDEPTH=ADDRDEPTH;//20;//Z/P; //Z/P = 73
parameter ROWWIDTH = ADDRESSWIDTH;//5;//7;//2**7 = 128 > 72, 2**5 = 32 > 20.
//last_p rowdepth and pipestages.
parameter P_LAST = Z-(P*(ROWDEPTH-1));//511-(26*19)=511-494=17

//bitnodemem (Lmem)
//Configurable
//parameter W=6;//6;
parameter maxVal = 6'b011111;
//non-configurable parameters
//parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
//parameter Nb=16;//16;//circulant blocks per layer
parameter Kb=14;//first 14 circulant columns correspond to systematic part
parameter HDWIDTH=32;//taking 32 bits at a time
parameter Wt=2; //circulant weight
//parameter ADDRESSWIDTH = 5;//to address 20 locations correspondin to ceil(Z/P)=20 cycles.
parameter r=P*Wt;//r is predefined to be 52. non configurable.
parameter w=W;

//Dmem
//parameter W=6;//6;//configurable by user
//non-configurable parameters
//parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
//parameter Nb=16;//16;//circulant blocks per layer
//parameter Wt=2; //circulant weight
//parameter ADDRESSWIDTH = 5;//to address 20 locations correspondin to ceil(Z/P)=20 cycles.
//parameter r=P*Wt;
//parameter w=W;

output decoder_ready;
output unload_start;
output [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;//output
input unload_en;
input [ADDRESSWIDTH-1:0] unloadAddress;
input [(32*Nb*W)-1:0] load_data;
input loaden;
input start;
input clk,rst;

//Lmem
//wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;//output
wire [(P*Nb*Wt*W)-1:0] rd_data_regout;//output
//wire unload_en;
//wire [ADDRESSWIDTH-1:0] unloadAddress;
wire rd_en;
wire [ADDRESSWIDTH-1:0] rd_address;
wire rd_layer;
//wire [(32*Nb*W)-1:0] load_data;
//wire loaden;
wire [(P*Nb*Wt*W)-1:0] wr_data;
wire wr_en;
wire wr_layer;
//wire firstiter; //from controller send after fsm start, iff (itr==0), first iter=1.
//wire clk,rst;

//Dmem
wire[(P*Nb*Wt*W)-1:0] dmem_rd_data_regout;//output
wire dmem_rd_en;
wire [ADDRESSWIDTH-1:0] dmem_rd_address;
wire dmem_rd_layer;
wire [(P*Nb*Wt*W)-1:0] dmem_wr_data;
wire dmem_wr_en;
//wire clk,rst;

//RCU
wire[(Wc*(W))-1:0] updLLR_regout[P-1:0]; //output reg out updated LLR to Lmem
wire[(Wc*(W))-1:0] Dout_regout[P-1:0]; //output reg out updated D to Dmem
wire [(ADDRESSWIDTH+1+1)-1:0] Dmem_rden_layer_address[P-1:0];//pipereg output {rden,layer,address} for Reaccess to Dmem
wire L_wrlayer[P-1:0]; //pipereg output to Lmem
//wire [ADDRESSWIDTH-1:0]wraddress[P-1:0]; //pipereg output to Lmem (unused for SRQ type mem)
wire[P-1:0] L_wren; //pipereg output to Lmem
wire d_wrlayer[P-1:0]; //pipereg output to Lmem
//wire [ADDRESSWIDTH-1:0]wraddress[P-1:0]; //pipereg output to Lmem (unused for SRQ type mem)
wire[P-1:0] d_wren; //pipereg output to Lmem
wire rdlayer; //from controller
wire [ADDRESSWIDTH-1:0]rdaddress; //from controller 
wire[P-1:0] rcu_en;//rden_LLR; //RCU enable from controller
wire[P-1:0] rden_E; //from controller
wire [(Wc*(W))-1:0] Lmemout[P-1:0]; //from Lmem (assumes register at output of Lmem)
wire [(Wc*(W))-1:0] D_reaccess_in[P-1:0]; //from Dmem (assumes register at output of Dmem)
//wire clk, rst;   

//Agen Controller
wire SISOready;//output
wire firstprocessing_indicate;//output//to select proper Lmem (load to lyr0) unit.
wire LYRindex;//output
wire [ROWWIDTH-1:0] rowaddress;//output
//wire[P-1:0]rd_E;//output//---------------clr_en_E Alternative: first iter rd E =0 
wire rd_L;//output
//wire[P-1:0] rcu_en;//output//26 rcu enable lines
//wire start;
//wire clk, rst;

// Interconnect ---
assign decoder_ready=SISOready;
assign {wr_en,wr_layer} = {L_wren[0],L_wrlayer[0]};//RCU write signals connect with Lmem 
assign dmem_wr_en = d_wren[0];//RCU write signals connects with Dmem write signals
assign {dmem_rd_en,dmem_rd_layer,dmem_rd_address} = Dmem_rden_layer_address[0];//RCU reaccess read signals connect with Dmem
assign {rd_en, rd_layer, rd_address} = {rd_L,LYRindex,rowaddress}; //controller connects with Lmem
assign {rdlayer, rdaddress} = {LYRindex,rowaddress};//controller connects with RCU
//---Interconnect

//instances---
//Controller instance
defparam controller.MAXITRS=MAXITRS, controller.ROWDEPTH=ROWDEPTH, controller.PIPESTAGES=PIPESTAGES, controller.P=P, controller.Z=Z;
defparam controller.ROWWIDTH=ROWWIDTH, controller.PIPECOUNTWIDTH=PIPECOUNTWIDTH, controller.ITRWIDTH=ITRWIDTH;
ne_AddrGenFSM controller(SISOready,unload_start,firstprocessing_indicate,LYRindex,rowaddress,rden_E,rd_L,rcu_en,loaden,start,clk,rst);

//Bit Node Memory or LLR memory (Lmem) instance
defparam bitnodemem.W=W, bitnodemem.maxVal=maxVal;
//Lmem_SRQtype_withfedbackshift_reginout bitnodemem(unload_HDout_vec_regout,rd_data_regout,unload_en,unloadAddress,rd_en,rd_address,rd_layer, load_data,loaden, wr_data,wr_en,wr_layer, firstprocessing_indicate, clk,rst);
Lmem_SRQtype_combined_ns_regout_pipeV1 bitnodemem(unload_HDout_vec_regout,rd_data_regout, unload_en,unloadAddress,rd_en,rd_address,rd_layer, load_data,loaden, wr_data,wr_en,wr_layer, firstprocessing_indicate, clk,rst);

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
    //SISONorm_withD_mod1_ne rcu(updLLR_regout[p_j],Dout_regout[p_j], wrlayer[p_j], ,wren[p_j], Dmem_rden_layer_address[p_j], rdlayer,rdaddress,rcu_en[p_j],rden_E[p_j], Lmemout[p_j],D_reaccess_in[p_j],clk,rst);
    //SISONorm_withD_pipeV1mod_ne rcu(updLLR_regout[p_j],Dout_regout[p_j], wrlayer[p_j], ,wren[p_j], Dmem_rden_layer_address[p_j], rdlayer,rdaddress,rcu_en[p_j],rden_E[p_j], Lmemout[p_j],D_reaccess_in[p_j],clk,rst);
    //SISONorm_withD_pipeV2mod_ne rcu(updLLR_regout[p_j],Dout_regout[p_j], wrlayer[p_j], ,wren[p_j], Dmem_rden_layer_address[p_j], rdlayer,rdaddress,rcu_en[p_j],rden_E[p_j], Lmemout[p_j],D_reaccess_in[p_j],clk,rst);
    SISONorm_withD_pipeV3_ne rcu(updLLR_regout[p_j],Dout_regout[p_j], L_wrlayer[p_j], ,L_wren[p_j], d_wrlayer[p_j], ,d_wren[p_j], Dmem_rden_layer_address[p_j], rdlayer,rdaddress,rcu_en[p_j],rden_E[p_j], Lmemout[p_j],D_reaccess_in[p_j],clk,rst);
    
  end //p_j_26_loop
  
endgenerate

//--instances



endmodule
