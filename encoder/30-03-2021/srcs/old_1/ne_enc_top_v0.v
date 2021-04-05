`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2021 15:37:31
// Design Name: 
// Module Name: ne_enc_top_v0
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// Func gen ROM (generated from script: ne_funcgenROM.m)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Based on matlab script(encodervalidation.m) reference model
// prepending 18 zeros and feeding to MAC netowork
// instead of removing them. 
//////////////////////////////////////////////////////////////////////////////////


module ne_enc_top_v0(codevalid,codeTx, msg_data_regin, datavalid_regin, outclk, inclk, clk, rst);
//input interface
parameter Z=511;
parameter K=7136;
parameter Kunshort = 7154; //sys bits with reference to G-matrix
//parameter Kunshortwithzeros = Kunshort + (Kunshort/Z); //7154 + 14
parameter DW=16;
parameter COUNTDEPTH = K/DW;//K/DW = 7136/16 = 446
parameter COUNTWIDTH = 9;//ceil(log2(K/DW)) = ceil(log2(7136/16)) = 9
//Sys memory
parameter KB=14;
//parameter K=7136;
//parameter Kunshort = 7154;
parameter Kunshortwithzeros = Kunshort + KB; //7154 + 14 = 7168
parameter Lm=16;
parameter READDEPTH = Kunshortwithzeros/Lm;//K/Lm = 7168/16 = 448
parameter ADDRESSWIDTH = 9;//ceil(log2(K/DW)) = ceil(log2(7136/16)) = 9
//parameter READDEFAULTCASE = 2**ADDRESSWIDTH -1; //511 a constant since allowed depth for reading is less than max depth. 
//Controller
//parameter ROMDEPTH= 14;//same as KB
parameter Z_LM_MSG_DEPTH=(Z+1)/Lm;//(Z+1)/Lm = (511+1)/16) = 32
parameter ROMADDRESSWIDTH = 4; //ceil(log2(KB)) = ceil(log2(14))= 4
parameter Z_LM_MSG_WIDTH = 5;// ceil(log2(Z_LM_MSG_DEPTH)) = ceil(log2(32))=5;
//parameter MSGMEM_ADDRESSWIDTH = ROMADDRESSWIDTH + Z_LM_MSG_WIDTH;// same as ADDRESSWIDTH

//Func gen ROM (generated from script: ne_funcgenROM.m)
//parameter Z=511;//circulant size
parameter MB=2;//num of blk columns of G parity part
//parameter ADDRESSWIDTH=4;
//parameter ROM_READDEFAULTCASE = (2**ROMADDRESSWIDTH)-1; //modify in script for ROM

//MAC network 0,1 parityshifter 0,1
//parameter Lm=2;// number of message bit
//parameter Z=5; // size of circulant sub matrix of generator matrix//change thhis to 2 or 3 to visualize in elaborated design

//Output interface
//parameter K=7136;
parameter M = 1022;
parameter Zeroappend =2;
parameter M_z = M + Zeroappend;
parameter DW_opintf=16;
parameter SYSCOUNT = K/DW_opintf;//K/DW = 7136/16 = 446
parameter SYSCOUNTWIDTH = 9;//ceil(log2(SYSCOUNT)) = 9
parameter PARITYCOUNT = M_z/DW; // M_z/DW= 1024 /16 = 64
parameter PARITYCOUNTWIDTH = 6;//ceil(log2(PARITYCOUNT)) = 6

output codevalid;
output[DW-1:0] codeTx;
input[DW-1:0] msg_data_regin;
input datavalid_regin;
input outclk;
input inclk;
input clk;
input rst;

//input interface
wire[K-1:0] msg_k; //to putput buffer.
wire[(Kunshortwithzeros)-1:0] msg_vec;
wire wren; //to msg mem and output buffer

//sys memory
wire[Lm-1:0] msgLmtoencode;
wire [ADDRESSWIDTH-1:0] address;
//wire[Kunshortwithzeros-1:0] msg_vec;
//wire wren; //parallel write no write address required.
wire rden;

//Controller
wire parityregclear;
wire parity_parloaden;
wire parityshiften;
//wire rden;
//wire[MSGMEM_ADDRESSWIDTH-1:0] msgmem_rdaddress; //same as address
wire encstart;//connect wren of load fsm to start

//Func Gen ROM
wire[(MB*Z)-1:0] f;
wire[(ROMADDRESSWIDTH)-1:0] romaddress;
//wire rden;// same as controller rden and msg mem rden.
assign romaddress = address[ADDRESSWIDTH-1:ADDRESSWIDTH-ROMADDRESSWIDTH];

//MAC network 0//non registered in and out
wire[Z-1:0]u_reg_0;
//wire[Lm-1:0]msg_inp;// same as msgLmtoencode
wire[Z-1:0]f_inp_0;//
//MAC network 0//non registered in and out
wire[Z-1:0]u_reg_1;
//wire[Lm-1:0]msg_inp;// same as msgLmtoencode
wire[Z-1:0]f_inp_1;//

assign {f_inp_1,f_inp_0} = f;
assign encstart = wren;
//parity shifter 0
//input [Z-1:0]u; //same as u_reg_0
//input clk,rst,clr; //clr same as parityregclear
wire[Z-1:0] parityout_0, parityout_1 ;

//Output interface
wire[M-1:0] parityout_regin; //from parity shift network
//wire parity_parloaden_regin; //same as parity_parloaden from controller
//wire[K-1:0] msg_k_regin; //same as inp intf msgk
//wire wren_regin; //same as wren form inp intf, parallel write no write address required.
wire txstart_regin;// same as controller rden
//input rst;
assign parityout_regin = {parityout_1, parityout_0};
assign txstart_regin = rden;

//input interface
defparam inpintf.Z=Z, inpintf.K=K, inpintf.Kunshort=Kunshort, inpintf.Kunshortwithzeros=Kunshortwithzeros;
defparam inpintf.DW=DW, inpintf.COUNTDEPTH=COUNTDEPTH, inpintf.COUNTWIDTH=COUNTWIDTH;
ne_inputinterface inpintf(msg_k, msg_vec, wren, msg_data_regin,datavalid_regin,inclk,clk,rst);

//sys memory
defparam sysmem.KB=KB, sysmem.K=K, sysmem.Kunshort=Kunshort, sysmem.Kunshortwithzeros=Kunshortwithzeros;
defparam sysmem.Lm=Lm, sysmem.READDEPTH=READDEPTH, sysmem.ADDRESSWIDTH=ADDRESSWIDTH;
//defparam sysmem.READDEFAULTCASE=READDEFAULTCASE;
ne_msgmemory sysmem(msgLmtoencode, address, msg_vec, wren, rden, clk, rst);



//Controller
defparam controller.ROMDEPTH=KB, controller.Z_LM_MSG_DEPTH=Z_LM_MSG_DEPTH, controller.ROMADDRESSWIDTH=ROMADDRESSWIDTH;
defparam controller.Z_LM_MSG_WIDTH=Z_LM_MSG_WIDTH, controller.MSGMEM_ADDRESSWIDTH=ADDRESSWIDTH;
ne_enc_addrgen controller(parityregclear, parity_parloaden,parityshiften, rden, address, encstart, clk, rst);

//Func gen ROM
defparam fROM.Z=Z, fROM.MB=MB, fROM.ADDRESSWIDTH=ROMADDRESSWIDTH;
//defparam fROM.READDEFAULTCASE = ROM_READDEFAULTCASE; //modify using script for the ROM
ne_funcgenROM fROM(f, romaddress, rden);


//MAC network 0
defparam mac0.Lm=Lm, mac0.Z=Z;
Parity_generation_unit_chaintree mac0(u_reg_0,msgLmtoencode,f_inp_0,rst,clk);//processing unit


//MAC network 1
defparam mac1.Lm=Lm, mac1.Z=Z;
Parity_generation_unit_chaintree mac1(u_reg_1,msgLmtoencode,f_inp_1,rst,clk);//processing unit


//parity shofter 0
defparam parityconvolve0.Z=Z, parityconvolve0.Lm=Lm;
ne_parityshifter parityconvolve0(parityout_0,u_reg_0,clk,parityregclear,parityshiften,rst);

//parity shifter 1
defparam parityconvolve1.Z=Z, parityconvolve1.Lm=Lm;
ne_parityshifter parityconvolve1(parityout_1,u_reg_1,clk,parityregclear,parityshiften,rst);

//output interface
defparam opintf.K=K, opintf.M=M, opintf.Zeroappend=Zeroappend;
defparam opintf.M_z = M_z, opintf.DW = DW_opintf;
defparam opintf.SYSCOUNT=SYSCOUNT, opintf.SYSCOUNTWIDTH=SYSCOUNTWIDTH;
defparam opintf.PARITYCOUNT=PARITYCOUNT, opintf.PARITYCOUNTWIDTH=PARITYCOUNTWIDTH; 
ne_outputinterface opintf(codevalid, codeTx, parityout_regin, parity_parloaden, msg_k, wren, txstart_regin, outclk, rst);


endmodule
