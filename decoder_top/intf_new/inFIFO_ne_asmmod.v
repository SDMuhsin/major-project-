`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2020 11:20:06
// Design Name: 
// Module Name: inFIFO_dp_asmmod
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
// WRDIN_regd is tha Codeword_in data input signal of Input interface
// wr_en_regd is the codevalid input signal of Input interface
// It should stay high as long as data is given at Codeword_in
//
// Write FIFO FSM: Counts 257 cycles of input 32xWbit blocks: 0 to 256
// Write selector : Skips write of first block (since it is assumed to be 32 ASM symbols)
// From next 32 ASM symbols onwards, writing to RAM is enabled, till last block.
//////////////////////////////////////////////////////////////////////////////////


module inFIFO_ne_asmmod(load_fsm_start,DOUT_nb,RA,rd_en,WRDIN_regd,wr_en_regd,inclk,clk,rst);
parameter W=6;
parameter ADDRESSWIDTH=5;//2**5 = 32> 17.
parameter FIFODEPTH = 32;//17;
//Non configurable:
parameter NB=16;
parameter DW=32*W;
parameter MAXCYCLES = 257;//256;//maxcycles=(8160+32)/32)=256, includng first ASM=257.  | BUG : NEEDS to run upto 256 | FIX : MAXCYCLES changed from 256->257
parameter CYCLECOUNTWIDTH = 9;//8;//width=ceil(log2(256))=8  | BUG : NEEDS to run upto 256 | FIX : width changed from 8->9
parameter ASMBITS = 1;//2;//64 symbols = 2 x 32 symbols, skip first ASM only
output reg load_fsm_start;
output[(NB*DW)-1:0] DOUT_nb;
input[(ADDRESSWIDTH)-1:0] RA; 
input rd_en;
input[(DW)-1:0] WRDIN_regd; //codeword_in32W
input wr_en_regd; //codevalid
input inclk;
input clk;
input rst;
//regd input WRDIN, wr_en : @negedge
reg wr_en;
reg [DW-1:0] WRDIN;
always@(posedge inclk)//(negedge inclk) //-------fix0
begin
  if(!rst)
  begin
    wr_en<=0;
    WRDIN<=0;
  end
  else
  begin
    wr_en<= wr_en_regd;
    WRDIN<= WRDIN_regd;
  end
end
//

//------------Memories------------//
wire[(DW)-1:0] DOUT[NB-1:0];
wire[(NB*ADDRESSWIDTH)-1:0] writeaddress_vec;
wire[(ADDRESSWIDTH)-1:0] writeaddress[NB-1:0];
wire [NB-1:0] wr_in;
 
//-----------FSM to count wr_index and WA-------//
reg selector_en, nextloadfsmstart;//, next_wr_en_fsm;
reg[CYCLECOUNTWIDTH-1:0] cyclecount,nextindex;
reg[1:0] ps,ns;
parameter INIT=0, WRITING=1;//WAIT_ASMARK=2;
always@(posedge inclk)
begin
  if(!rst)
  begin
    ps<=0;
    cyclecount<=0;
    load_fsm_start<=0;//-------fix3
  end
  else
  begin
    ps<=ns;
    cyclecount<=nextindex;
    load_fsm_start<=nextloadfsmstart;//-------fix3
  end
end

always@(ps,cyclecount,wr_en)//also creates load_fsm_start output
begin
  case(ps)
    INIT: begin //first 32 bit ASM skips here
    //for NE, we are considering 2nd 32 bit ASM, so ns is writing.
            ns= wr_en ? WRITING: INIT;//WAIT_ASMMARK : INIT; 
            nextindex = wr_en ? 1 : 0;//0;//-----------fix2
            nextloadfsmstart=0;//------------------fix3
            selector_en = 0;//wr_en;
          end
//    WAIT_ASMMARK: begin //second 32 bit ASM skips here
//                 ns = (cyclecount==ASMBITS-1) ? WRITING : (wr_en ? ps : INIT);
//                 nextindex = cyclecount+1;//(cyclecount==ASMBITS-1) ? 0 : cyclecount+1;  
//                 nextloadfsmstart=0;
//                 wr_en_fsm = 0;
//               end    
    WRITING: begin
               ns = (cyclecount==MAXCYCLES-1) ? INIT : (wr_en ? ps : INIT);  
               nextindex =  (cyclecount==MAXCYCLES-1) ? 0 : cyclecount+1;              
               nextloadfsmstart = (cyclecount==MAXCYCLES-1) ? 1 : 0; 
               selector_en = wr_en;         
             end                        
    default: begin
               ns=0;
               nextindex=0;
               nextloadfsmstart=0;
               selector_en = 0;
             end
  endcase
end

genvar nb; //nb= block columns of H matrix= 16.
generate for(nb=0;nb<=NB-1;nb=nb+1) begin: nb_loop
  defparam submem.MEMDEPTH=FIFODEPTH, submem.ADDRESSWIDTH=ADDRESSWIDTH;
  defparam submem.WIDTH=DW;
  simpledualportram_wrclk_rdclk_ne submem(DOUT[nb], RA, rd_en, WRDIN, writeaddress[nb], wr_in[nb], inclk, clk, rst);
  //defparam submem.WIDTH=DW;
  //simpledualportram_dp submem(DOUT[nb], RA, rd_en, WRDIN, WA, wr_in[nb], inclk, rst);
  //defparam submem.W=DW;
  //simpledualportram_asyncread_dp submem(DOUT[nb], RA, rd_en, WRDIN, WA, wr_in[nb], inclk, rst);
  assign writeaddress[nb]=writeaddress_vec[((nb+1)*ADDRESSWIDTH)-1:(nb*ADDRESSWIDTH)];
  assign DOUT_nb[((nb+1)*DW)-1:(nb*DW)] = DOUT[nb];
end//nb_loop 
endgenerate

//-----wr_en distributer IndexDecoder-------//
defparam wrsel.ADDRESSWIDTH = ADDRESSWIDTH, wrsel.CYCLECOUNTWIDTH=CYCLECOUNTWIDTH;
writeselector_inputintf wrsel(wr_in,writeaddress_vec,cyclecount,selector_en); 

endmodule