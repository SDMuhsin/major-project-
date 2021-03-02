`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2020 11:52:13
// Design Name: 
// Module Name: outFIFO
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
// Configurable parameters: 
// FIFODEPTH: memory depth, should be Greater than or equal to UNLOADCOUNT= 17
// ADDRESSWIDTH: memory Address width to address 17 locations in RAM.
// Fixed Parameters:
// CYCLECOUNTWIDTH: 8 to represent value 0 to MAXOUTCYCLES-1.
// HDDW=32 (number of bits send out), 
// MAXOUTCYCLES=223 (Number of cycles to complete sending of 7136 bits = 7136/32 = 223) 
//wrclk = decodeclk: loadunloadfsm uses this, rdfifofsm works using rdclk = out_clk
//////////////////////////////////////////////////////////////////////////////////


module outFIFO_ne(datavalid,unload_fsm_start_fedback,HD_out,WRDIN_kb,WA,wr_en,rd_en,wrclk,rdclk,rst);
parameter KB=14;//32;// message blocks
parameter HDDW=32;
parameter ADDRESSWIDTH=5;//5bits to address 17 locations
parameter FIFODEPTH = 32;//511;
parameter MAXOUTCYCLES=223;//maxcycles=floor(7154/32)=223
parameter CYCLECOUNTWIDTH = 8;//width=ceil(log2(223))=8
output reg datavalid;
output unload_fsm_start_fedback;//feedback control signal to loadunloadfsm to fill the fifo with next set of results (unused)
output[(HDDW)-1:0] HD_out;//dout is 1 bit
//input[(COLADDR_BITS)-1:0] RA; //
input[(KB*HDDW)-1:0] WRDIN_kb;
input[(ADDRESSWIDTH)-1:0] WA;//frm unloadFSM
input wr_en;
input rd_en;//frm unloadFSM done signal, also starts read FSM here.
input wrclk;
input rdclk, rst;
//regd output HD_out, datavalid : @negedge
//reg datavalid;
//wire [W-1:0] HD_out;
//always@(negedge rdclk)
//begin
//  if(!rst)
//  begin
//    datavalid_regd<=0;
//    HD_out_regd<=0;
//  end
//  else
//  begin
//    datavalid_regd<= datavalid;
//    HD_out_regd<= HD_out;
//  end
//end


//------------Memories------------//
wire[(HDDW)-1:0] DOUT[KB-1:0];
wire[(KB*HDDW)-1:0] DOUT_vec;
wire[(KB*ADDRESSWIDTH)-1:0] readaddress_vec;
wire[(ADDRESSWIDTH)-1:0] readaddress[KB-1:0];
wire[KB-1:0] rd_in;
wire[(HDDW)-1:0] DIN[KB-1:0];


//-----------FSM to count wr_index and WA-------//
reg[CYCLECOUNTWIDTH-1:0] cyclecount,nextindex;
reg outfifo_empty, nextempty;
//reg[ADDRESSWIDTH-1:0] addr,nextaddr;
reg rd_enable,nextrd_enable;
reg nextdatavalid;
reg[1:0] ps,ns;
parameter INIT=0, READING=1;
always@(posedge rdclk)
begin
  if(!rst)
  begin
    ps<=0;
  //  addr<=0;//STARTADDR;
    cyclecount<=0;
    rd_enable<=0;
    datavalid<=0;
    outfifo_empty<=1;//initially empty
  end
  else
  begin
    ps<=ns;
  //  addr<=nextaddr;
    cyclecount<=nextindex;
    rd_enable<=nextrd_enable;//rd_en;
    datavalid<=nextrd_enable;//rd_en;
    outfifo_empty<=nextempty;
  end
end

//In case the SISO ready comes early while transmitting is going on,
// outFIFO loading should be paused.
//unload_fsm_start_fedback: this signal indicates FIOF empty and enables SISO ready to start Unloadfsm
assign unload_fsm_start_fedback = outfifo_empty; 
always@(*)//(ps,cyclecount,rd_en)
begin
  case(ps)
    INIT: begin
            ns= rd_en ? READING : INIT;
            nextrd_enable= rd_en;
            nextindex = 0;
            //unload_fsm_start_fedback=0;
            nextempty=rd_en ? 0 : outfifo_empty;
          end
    READING: begin
               ns =(cyclecount==MAXOUTCYCLES-1) ? (rd_en ? ps : INIT) : READING;
               nextrd_enable= (cyclecount==MAXOUTCYCLES-1) ? (rd_en ? 1 : 0) : 1;//rd_enable; //fix2: error: remained 1 for 1 cycle, when data tx is over. so made it to change on condition.
               nextindex =(cyclecount==MAXOUTCYCLES-1) ? 0 : cyclecount+1; 
               //unload_fsm_start_fedback = (cyclecount==MAXOUTCYCLES-3) ? 1 : 0;//issue LOad start signal during 3rd last 32 databits read happening.
               nextempty= (cyclecount==MAXOUTCYCLES-3) ? 1 : outfifo_empty;
             end
    default: begin
               ns=0;
               nextindex=0;
               nextrd_enable= 0;
               //unload_fsm_start_fedback=0;
               nextempty=0;
             end
  endcase
end

//Instances:

genvar kb; //kb= block columns of H matrix= 14.
generate for(kb=0;kb<=KB-1;kb=kb+1) begin: kb_loop
  defparam submem.MEMDEPTH=FIFODEPTH, submem.ADDRESSWIDTH=ADDRESSWIDTH, submem.W=HDDW;
  //simpledualportram submem(DOUT[nb], RA, rd_en, WRDIN, WA, wr_in[nb], clk, rst);
  //simpledualportram2 submem(DOUT[nb], RA, rd_in[nb], DIN[nb], WA, wr_en, rdclk, wrclk, rst);
  simpledualportram_asyncread_ne submem(DOUT[kb], readaddress[kb], rd_in[kb], DIN[kb], WA, wr_en, wrclk, rst);
  assign readaddress[kb] = readaddress_vec[((kb+1)*ADDRESSWIDTH)-1:(kb*ADDRESSWIDTH)];
  assign DIN[kb] = WRDIN_kb[((kb+1)*HDDW)-1:(kb*HDDW)];
  assign DOUT_vec[((kb+1)*HDDW)-1:(kb*HDDW)]=DOUT[kb];
end//nb_loop 
endgenerate

//-----rd_en distributer IndexDecoder-------//
 defparam rdsel.ADDRESSWIDTH=ADDRESSWIDTH;
 readselector_outputintf rdsel(HD_out,rd_in,readaddress_vec,DOUT_vec,cyclecount,rd_enable);
 
 
endmodule
