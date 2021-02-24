`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2021 22:38:47
// Design Name: 
// Module Name: ne_decoder_top_pipeV3
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
// Configurable parameters: W, MAXITRS, ITRWIDTH, maxVal
//////////////////////////////////////////////////////////////////////////////////


module ne_decoder_top_pipeV3(datavalid, HD_out, Codeword_in, code_valid, in_clk, clk, out_clk, rst);
//Decoder core
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
parameter RCU_PIPESTAGES=13;//11;
//configurable
parameter MAXITRS = 2;
parameter ITRWIDTH = 4;//2**4 = 16 > 9
//non-configurable
parameter Z=511;
parameter P=26;
parameter PIPESTAGES = RCU_PIPESTAGES+2;//memrd+RCU_PIPESTAGES+memwr
parameter PIPECOUNTWIDTH = 4;//2**4= 16 > 14
parameter ROWDEPTH=ADDRDEPTH;//20;//Z/P; //Z/P = 73
parameter ROWWIDTH = ADDRESSWIDTH;//5;//7;//2**7 = 128 > 72, 2**5 = 32 > 20.
//last_p rowdepth and pipestages.
parameter P_LAST = Z-(P*(ROWDEPTH-1));//511-(26*19)=511-494=17
//Configurable
parameter maxVal = 6'b011111;
//Non configurable
parameter Kb=14;//first 14 circulant columns correspond to systematic part
parameter HDWIDTH=32;//taking 32 bits at a time
parameter Wt=2; //circulant weight
parameter r=P*Wt;//r is predefined to be 52. non configurable.
parameter w=W;

//input interface 
//Configurable parameters:
//parameter W=6;//10;
//parameter ADDRESSWIDTH = 5;//2**5=32>17 loc in one submem. 
parameter FIFODEPTH=32;//17
//Non configurable parameters:
//parameter LOADCOUNT=17;//size(rxregtablemod)=[16,17]. LOADCOUNT=columns=17.
parameter DW=32*W;
parameter NB=Nb;//

//Output interface
//Configurable parameters:
//parameter ADDRESSWIDTH=5;//5bits to address 32 locations > 17, but is made same as that of decodercore ADDRESSWIDTH.
//parameter FIFODEPTH=32;//17; //same as input intf FIFODEPTH
//Non-configurable parameters:
parameter KB=Kb;// message blocks
parameter HDDW=HDWIDTH;
parameter UNLOADCOUNT=17;//size(unloadrequestmap2(:,:,2)=[17,32], UNLOADCOUNT=rows=17.

output datavalid;//output
output[(HDDW)-1:0] HD_out;//output//dout is 1 bit
input[DW-1:0] Codeword_in;
input code_valid;
input in_clk;
input clk;
input out_clk;
input rst;

//input interface
wire decodestart;//output
wire load_en_out;// output //1 cycle delayed rd_en
//output reg[(FIFOADDRESSWIDTH)-1:0] LOADADDRESS_VEC;//output(unused)//[((NB)*SUB_COLADDR_BITS)-1:0] LOADADDRESS_VEC;// 1 cycle delayed fifo rd address (addr_count)
wire[((NB)*DW)-1:0] DOUT_LOAD_VEC;//output
//wire[(DW)-1:0] Codeword_in;
//wire code_valid;
//wire in_clk, clk, rst;

//Decoder core
wire decoder_ready;//output
wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;//output
//wire unload_en;
wire [ADDRESSWIDTH-1:0] unloadAddress;
wire [(Nb*DW)-1:0] load_data;
wire loaden;
wire start;
//wire clk,rst;

//Output interface
//wire datavalid;//output
//wire[(HDDW)-1:0] HD_out;//output//dout is 1 bit
wire unload_en;//output frm loadunloadFSM (rd_en)
wire[(ADDRESSWIDTH)-1:0] UNLOADADDRESS_VEC;//output//frm loadunloadFSM (addr_count)
wire[(KB*HDDW)-1:0] WRDIN_VEC;//delayed by 2cycles frm LLR mem
wire unload_start;//connect with decoderready
//wire clk;
//wire out_clk, rst;

//decode core connects with input intf
assign start=decodestart;
assign loaden=load_en_out;
assign load_data = DOUT_LOAD_VEC;

//decode core connects with output intf
assign unloadAddress = UNLOADADDRESS_VEC;
assign WRDIN_VEC=unload_HDout_vec_regout;
assign unload_start = decoder_ready;

//input interface

defparam inputintf.W=W, inputintf.ADDRESSWIDTH=ADDRESSWIDTH, inputintf.FIFODEPTH=FIFODEPTH;
InputInterface_ne inputintf(decodestart,load_en_out, ,DOUT_LOAD_VEC,Codeword_in,code_valid,in_clk,clk,rst);

//decoder core RCU stages=13
defparam decodecore.W=W, decodecore.maxVal=maxVal, decodecore.MAXITRS=MAXITRS, decodecore.ITRWIDTH=ITRWIDTH;
ne_rowcomputer_pipeV3_SRQ_p26 decodecore(decoder_ready,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);


//output interface
defparam outintf.ADDRESSWIDTH=ADDRESSWIDTH, outintf.FIFODEPTH=FIFODEPTH;
OutputInterface_ne outintf(datavalid,HD_out, unload_en, UNLOADADDRESS_VEC, WRDIN_VEC, unload_start, clk, out_clk,rst);




endmodule
