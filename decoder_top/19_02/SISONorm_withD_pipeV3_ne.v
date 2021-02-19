`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2021 17:25:43
// Design Name: 
// Module Name: SISONorm_withD_pipeV3_ne
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Row Calculation unit (soft-input-soft-output (SISO) decoder) 
// Row weight, Wc=32 bit node parallelism, 
// So 32 input minfinder (non-configurable).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Modification: 
// 1. Assume no need for bram wait reg
// 2. assume output reg is there in Lmem and Dmem.
// 3. Minfinder using m32VG structure.
// lyrwidth + ADDRWIDTH is 1+5=6, maximum depth of Emem=2^6=64, datawidth=[5+5+5+32]=47 bits.
// So synth tool suggests BRAM inefficient, so implementing as LUT RAM.
// Tc = in adder 3input = 1.455ns (WNS=8.55,T=10)
// Dmem and Lmem use only 1 wren and wraddress scheme,
// so forwarded rcu enable of last address, even if some are zero, data will be written/read.
// so invalid D is read at last address for some RCU and addition occurs.
// to disable write of this invalid addition, clear the output to 0.
// if 'forwarded_rcu_en'==0 adder/subtractor_D output is not registered to output data register.
// Added pipestage adjustment for LLR mem read latency.
// cycle 1= Lmem address read
// cycle 2= Lmem first iter read || Emem Read
// cycle 3= Lmem layer read, output available to RCU || E recover
// cycle 4= L and E sub.
// So pipestages: PIPEV1:
// Agen-FF->0 Lmem/Emem Read request->FF->1 Lmem Read/Emem delayed Req->FF-> 2 Lmem firstiter Read/Emem Read happens/recov>FF->
// ->3 Lmem LayerRead happens/Sub occurs->FF->4 Abs/Norm->FF->
// ->5 m2vg->FF->6 m4vg->FF->7 m8vg->FF->8 m16vg->FF->9 m32vg->FF->10 Read Dmem/Recov/Ememwr->FF->11 SubD/Add->FF->
//-->12 writeReq->FF->13 UpdLLR/D WriteHappens/AgenNextLayer->FF->14 (nextlyrreadreq)
// PIPEV2: 
// Adding 1 cycle after Emem read.
// Agen-FF->0 Lmem/Emem Read request->FF->1 Lmem Read/Emem Read happens,BRAM wait->FF-> 2 Lmem firstiter Read/recov>FF->
// ->3 Lmem LayerRead happens/Sub occurs->FF->4 Abs/Norm->FF->
// ->5 m2vg->FF->6 m4vg->FF->7 m8vg->FF->8 m16vg->FF->9 m32vg->FF->10 Read Dmem/Recov/Ememwr->FF->11 SubD/Add->FF->
//-->12 writeReq->FF->13 UpdLLR/D WriteHappens/AgenNextLayer->FF->14 (nextlyrreadreq)
//0->(1->2->3->4->5->6->7->8->9->10->11->12)->13->14->
// Row calculation unit(SISO) stages=12.
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
//////////////////////////////////////////////////////////////////////////////////



module SISONorm_withD_pipeV3_ne(updLLR_regout,Dout_regout, L_wrlayer,L_wraddress,L_wren, d_wrlayer,d_wraddress,d_wren, Dmem_rden_layer_address, rdlayer,rdaddress,rden_LLR,rden_E, Lmemout,D_reaccess_in,clk,rst);
//module SISONorm_withD_pipeV3_ne_reginout(updLLR_regout,Dout_regout, L_wrlayer,L_wraddress,L_wren, d_wrlayer,d_wraddress,d_wren, Dmem_rden_layer_address, rdlayer_regin,rdaddress_regin,rden_LLR_regin,rden_E_regin, Lmemout_regin,D_reaccess_in_regin,clk,rst);

parameter Nb=16;
parameter Wc=32;
parameter Wcbits = 5;//2**5 =32
parameter W=6;
parameter LAYERS=2;
parameter ADDRESSWIDTH = 5;//2^5 = 32 > 20
parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
parameter EMEMDEPTH= 52;//ADDRDEPTH*LAYERS; //for LUT RAM //512;//for BRAM ineffcient//
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
parameter RCU_PIPESTAGES=13;//12;//adding 1 more stage for Lmem write
output reg[(Wc*(W))-1:0] updLLR_regout; //reg out updated LLR to Lmem
output reg[(Wc*(W))-1:0] Dout_regout; //reg out updated D to Dmem
output [(ADDRESSWIDTH+1+1)-1:0] Dmem_rden_layer_address;//pipereg out {rden,layer,address} for Reaccess to Dmem

output L_wrlayer; //pipereg out to Lmem
output [ADDRESSWIDTH-1:0] L_wraddress; //pipereg out to Lmem (unused for SRQ type mem)
output L_wren; //pipereg out to Lmem

output d_wrlayer; //pipereg out to Lmem
output [ADDRESSWIDTH-1:0] d_wraddress; //pipereg out to Lmem (unused for SRQ type mem)
output d_wren; //pipereg out to Lmem

input rdlayer; //from controller
input [ADDRESSWIDTH-1:0]rdaddress; //from controller 
input rden_LLR; //RCU enable from controller
input rden_E; //from controller
input [(Wc*(W))-1:0] Lmemout; //from Lmem (assumes register at output of Lmem)
input [(Wc*(W))-1:0] D_reaccess_in; //from Dmem (assumes register at output of Dmem)

//regin--
//input rdlayer_regin; //from controller for measuring delay
//input [ADDRESSWIDTH-1:0]rdaddress_regin; //from controller for measuring delay
//input rden_LLR_regin; //rcu enable from controller for measuring delay
//input rden_E_regin; //from controller for measuring delay
//input [(Wc*(W))-1:0] Lmemout_regin; //LLR data from Lmem output for measuring delay
//input [(Wc*(W))-1:0] D_reaccess_in_regin; //D data from Dmem for measuring delay
//--regin
input clk, rst;   

//LLR delay
//reg [(Wc*(W))-1:0] Lmemreg[1:0];
//Emem
wire wr_E, rd_E;
wire[(ADDRESSWIDTH+1)-1:0] E_RA;
wire[(ADDRESSWIDTH+1)-1:0] E_WA;
wire[ECOMPSIZE-1:0] Ecomp_wr_datain;
wire[ECOMPSIZE-1:0] Emem_rd_dataout_regin;
reg[ECOMPSIZE-1:0] Emem_rd_dataout; //added 1 cycle after Emem read to wait for BRAMread latency.
reg[ECOMPSIZE-1:0] Ecomp_in;

reg [(ADDRESSWIDTH+1+1)-1:0]wren_layer_address_reg[RCU_PIPESTAGES-1:0];//Address and enable signal queue
wire forwarded_rcu_en, forwarded_rcu_en2;
//recover
wire[(Wc*W)-1:0] Euncomp_in;
reg[(Wc*W)-1:0] Euncomp_in_reg[RCU_PIPESTAGES-1-2:0];//[8:0]
//subLE
wire[(Wc*W)-1:0] Q;
reg[(Wc*W)-1:0] Qreg[RCU_PIPESTAGES-1-3:0];//[7:0];
//abs
wire[(Wc*Wabs)-1:0] absQ;
wire[Wc-1:0] signQ;
//norm
wire[(Wc*Wabs)-1:0] absnormL;
//Egen
wire[ECOMPSIZE-1:0] Ecomp_out_regout;
//recover Eout
wire[(Wc*W)-1:0] Euncomp_out;
reg[(Wc*W)-1:0] Euncomp_out_reg;
//SubD = Euncomp_out - Euncomp_in
wire[(Wc*W)-1:0] D_out;
//Add 3input
wire[(Wc*W)-1:0] updLLR_out;
//----------Regd Inputs------------------------//

//reg rdlayer;
//reg [ADDRESSWIDTH-1:0]rdaddress;
//reg rden_LLR;
//reg rden_E;
//reg [(Wc*(W))-1:0] Lmemout;
//reg [(Wc*(W))-1:0] D_reaccess_in;
//always@(posedge clk)
//begin
//  if(!rst)
//  begin
//    D_reaccess_in<=0;
//    Lmemout<=0;
//    rdlayer<=0;
//    rdaddress<=0;
//    rden_LLR<=0;
//    rden_E<=0;
//  end
//  else
//  begin
//    D_reaccess_in<=D_reaccess_in_regin;
//    Lmemout<=Lmemout_regin;
//    rdlayer<=rdlayer_regin;
//    rdaddress<=rdaddress_regin;
//    rden_LLR<=rden_LLR_regin;
//    rden_E<=rden_E_regin;
//  end
//end

//---------------------------------//
//sisocycle0; Agen issues read request to LLR mem, Emem


////Address initial queue
//reg rdlayer;
//reg [ADDRESSWIDTH-1:0]rdaddress;
//reg rden_LLR;
//reg rden_E;
//always@(posedge clk)
//begin
//  if(!rst)
//  begin
//    rdlayer<=0;
//    rdaddress<=0;
//    rden_LLR<=0;
//    rden_E<=0;
//  end
//  else
//  begin
//    rdlayer<=rdlayer_reg0;
//    rdaddress<=rdaddress_reg0;
//    rden_LLR<=rden_LLR_reg0;
//    rden_E<=rden_E_reg0;
//  end
//end


//Address Queue: Queue to forward address and memory enable signals--
always@(posedge clk)
begin
  if(!rst)
  begin
    wren_layer_address_reg[0]<=0;
  end
  else
  begin
    wren_layer_address_reg[0]<={rden_LLR,rdlayer,rdaddress};//rcu enable, layeridx, sliceaddress
  end
end

genvar stageidx;
generate 
for(stageidx=0;stageidx<=RCU_PIPESTAGES-2;stageidx=stageidx+1) begin: stageidx_addrQ_loop
  always@(posedge clk)
  begin
    if(!rst)
    begin
      wren_layer_address_reg[stageidx+1]<=0;
    end
    else
    begin
      wren_layer_address_reg[stageidx+1]<=wren_layer_address_reg[stageidx];
    end
  end
end//stageidx_addrQ_loop
endgenerate
//--Queue


//siso cycle10: Emem write request + Recover + Dmem read request
//assign {wr_E,E_WA} = wren_layer_address_reg[8];// for emem write //pipeV1
assign {wr_E,E_WA} = wren_layer_address_reg[9];// for emem write //pipeV2
assign Ecomp_wr_datain = Ecomp_out_regout;// for emem write
//sisocycle0: Emem read request
assign {rd_E,E_RA} = {rden_E,rdlayer,rdaddress}; //for emem read

//sisocycle1: Lmem address based Read happens, First Iter Multiplexer Selection going on, Emem read happens + Wait 
defparam e_memory.DEPTH=EMEMDEPTH, e_memory.ADDRWIDTH=ADDRESSWIDTH+1;
defparam e_memory.ECOMPSIZE=ECOMPSIZE;
E_mem_ne_bram e_memory(Emem_rd_dataout_regin, Ecomp_wr_datain, E_WA, E_RA, wr_E, rd_E, clk, rst);

//sisocycle1: Emem wait 1 cycle to account BRAM read latency 
always@(posedge clk)
begin
  if(!rst)
  begin
    Emem_rd_dataout<=0;
  end
  else
  begin
    Emem_rd_dataout<=Emem_rd_dataout_regin;
  end
end

//sisocycle2: Lmem layer Multiplexer Selection going on + Recover
defparam recov_Ein.Wc=Wc, recov_Ein.Wcbits=Wcbits, recov_Ein.W=W;
recovunit_ne recov_Ein(Euncomp_in, Emem_rd_dataout);

//Queue for Euncompin reg:
//sisocycle2: pipereg Euncomp_in_reg[0]
always@(posedge clk)
begin
  if(!rst)
  begin
    Euncomp_in_reg[0]<=0;
    Euncomp_in_reg[1]<=0;
    Euncomp_in_reg[2]<=0;
    Euncomp_in_reg[3]<=0;
    Euncomp_in_reg[4]<=0;
    Euncomp_in_reg[5]<=0;
    Euncomp_in_reg[6]<=0;
    Euncomp_in_reg[7]<=0;  
    Euncomp_in_reg[8]<=0;
  end
  else
  begin
    Euncomp_in_reg[0]<=Euncomp_in;
    Euncomp_in_reg[1]<=Euncomp_in_reg[0];
    Euncomp_in_reg[2]<=Euncomp_in_reg[1];
    Euncomp_in_reg[3]<=Euncomp_in_reg[2];
    Euncomp_in_reg[4]<=Euncomp_in_reg[3];
    Euncomp_in_reg[5]<=Euncomp_in_reg[4];
    Euncomp_in_reg[6]<=Euncomp_in_reg[5];  
    Euncomp_in_reg[7]<=Euncomp_in_reg[6];  
    Euncomp_in_reg[8]<=Euncomp_in_reg[7];  
  end
end

//sisocycle3: Lmem Read happens (Lmemout) + Registered Recover result to Sub, Subtraction happens Q=L-E
defparam sub_L_E.Wc=Wc, sub_L_E.W=W;
//SubtractorWc sub_L_E(Q, Lmemreg[0], Euncomp_in_reg[0]);
SubtractorWc sub_L_E(Q, Lmemout, Euncomp_in_reg[0]);

//Queue for Qreg:
//Qreg[0]: pipereg for sisocycle3
always@(posedge clk)
begin
  if(!rst)
  begin
    Qreg[0]<=0;
    Qreg[1]<=0;
    Qreg[2]<=0;
    Qreg[3]<=0;
    Qreg[4]<=0;
    Qreg[5]<=0;
    Qreg[6]<=0;
    Qreg[7]<=0;
  end
  else
  begin
    Qreg[0]<=Q;
    Qreg[1]<=Qreg[0];
    Qreg[2]<=Qreg[1];
    Qreg[3]<=Qreg[2];
    Qreg[4]<=Qreg[3];
    Qreg[5]<=Qreg[4];
    Qreg[6]<=Qreg[5];
    Qreg[7]<=Qreg[6];      
  end
end

//sisocycle4: Absolute operation + normaliser operation
defparam absunit.Wc=Wc, absunit.W=W;
Absoluter absunit(signQ, absQ, Qreg[0]);

//Same sisocycle4 Normaliser operation
defparam normunit.Wc=Wc, normunit.W=W;
NormaliserWc normunit(absnormL, absQ, clk,rst);

//sisocycle 4: > pipe reg is in Egen for absQ and signQ.
//sisocycles5,6,7,8,9:  5 sisocycles> Pipe reg for Min1Min2PosUpdSign finding.
defparam Egenunit.Wc=Wc, Egenunit.Wcbits=Wcbits, Egenunit.W=W;
E_gen_pipe Egenunit(Ecomp_out_regout, signQ, absnormL, clk, rst);//has input reg and output reg

//sisocycle10: Dmem read request + Emem write request + Recover 
// Dmem read takes 1 cycle, so at sisocycle10 D_reaccess_in is ready to feed to subD
//assign Dmem_rden_layer_address = wren_layer_address_reg[8]; //pipeV1
assign Dmem_rden_layer_address = wren_layer_address_reg[9]; //pipeV2

//sisocycle10: Recover + Dmem read request + Emem write request
defparam recov_Eout.Wc=Wc, recov_Eout.Wcbits=Wcbits, recov_Eout.W=W;
recovunit_ne recov_Eout(Euncomp_out, Ecomp_out_regout);

//pipe reg of sisocycle10 of Euncomp_out reg:
always@(posedge clk)
begin
  if(!rst)
  begin
    Euncomp_out_reg<=0;
  end
  else
  begin
    Euncomp_out_reg<=Euncomp_out;
  end
end


//sisocycle11: Subtraction + Add 3 input(stage 1)
defparam sub_D.Wc=Wc, sub_D.W=W;
SubtractorWc sub_D(D_out, Euncomp_out_reg, Euncomp_in_reg[8]);//(out,X,Y) out = X-Y

//Same sisocycle11> Add stage1 Q, D and E
defparam add_E_Q_D.Wc=Wc, add_E_Q_D.W=W;
//AdderWc_3in add_E_Q_D(updLLR_out, Qreg[7], Euncomp_out_reg,D_reaccess_in);//(sum,X,Y,Z) sum = X+Y+Z
AdderWc_3in_pipelined add_E_Q_D(updLLR_out, Qreg[7], Euncomp_out_reg,D_reaccess_in, clk, rst);//(sum,X,Y,Z) sum = X+Y+Z

//Same sisocycle11: check rcu enable and enable Dmem write
assign forwarded_rcu_en = wren_layer_address_reg[10][(ADDRESSWIDTH+1+1)-1]; //pipeV2

//Regd outputs
//pipereg for sisocycle11
always@(posedge clk)
begin
  if(!rst)
  begin
    Dout_regout<=0;
  end
  else
  begin
    if(forwarded_rcu_en) //if rcu enable is 1, allow write to mem
    begin
      Dout_regout<=D_out;
    end
    else //else if rcu enable is 0, dont allow write, put zero value.
    begin
      Dout_regout<=0;
    end    
  end
end

//Same sisocycle12> Add stage2 Q, D and E || Dmem write request using {wr_en, wrlayer, wraddress, Dout_regout}
assign {d_wren,d_wrlayer,d_wraddress} = wren_layer_address_reg[11];//for llr mem and dmem write //pipeV2

//sisocycle12: Check rcu en to enable Lmem write
assign forwarded_rcu_en2 = wren_layer_address_reg[11][(ADDRESSWIDTH+1+1)-1]; //pipeV2
//pipereg sisocycle12
always@(posedge clk)
begin
  if(!rst)
  begin
    updLLR_regout<=0;
  end
  else
  begin
    if(forwarded_rcu_en2) //if rcu enable is 1, allow write to mem
    begin
      updLLR_regout<=updLLR_out;
    end
    else //else if rcu enable is 0, dont allow write, put zero value.
    begin
      updLLR_regout<=0;
    end    
  end
end

//Same sisocycle12> Dmem write hapen|| Lmem write request using {wr_en, wrlayer, wraddress, updLLR_regout}
assign {L_wren,L_wrlayer,L_wraddress} = wren_layer_address_reg[12];//for llr mem and dmem write //pipeV2


endmodule
