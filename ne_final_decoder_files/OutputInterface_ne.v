`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2020 11:52:13
// Design Name: 
// Module Name: OutputInterface
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


module OutputInterface_ne(datavalid,HD_out, unload_en, UNLOADADDRESS_VEC, WRDIN_VEC, unload_start, clk, out_clk,rst);
//Configurable parameters:
// OUTCLKSYNC_WAITCYCLES=Toutclk/Tclk = for 20 itr, expected clk period=4ns, outclk=26.1166, ratio 6.5.
// for 50 iterations, expected Tclk=2ns, Toutclk-31.8924 so ratio is 15.9. so setting values 10 to 16.
// should configure this parameter from top module at th time of block design according to clock periods in use.
parameter OUTCLKSYNC_WAITCYCLES=20;
parameter ADDRESSWIDTH=5;//5bits to address 32 locations > 17
parameter FIFODEPTH=32;//17;
//Non-configurable parameters:
parameter KB=14;// message blocks
parameter HDDW=32*1;
parameter UNLOADCOUNT=17;//size(unloadrequestmap2(:,:,2)=[17,32], UNLOADCOUNT=rows=17.
output datavalid;
output[(HDDW)-1:0] HD_out;//dout is 1 bit
output unload_en;// frm loadunloadFSM (rd_en)
output[(ADDRESSWIDTH)-1:0] UNLOADADDRESS_VEC;//frm loadunloadFSM (addr_count)
input[(KB*HDDW)-1:0] WRDIN_VEC;//delayed by 2cycles frm LLR mem
input unload_start; //SISO ready signal from decoder core is the start signal for unloadfsm
input clk;
input out_clk, rst;

//outfifo
wire unload_fsm_start_fedback;//feedback control signal to loadfsm to fill the fifo with next set of results (unused)
//input[(COLADDR_BITS)-1:0] RA; //
wire[(ADDRESSWIDTH)-1:0] WA;//frm unloadFSM (LOADADDRESS) //1cycle dealyed addr
reg[(ADDRESSWIDTH)-1:0] WA_regout_temp, WA_regout;
//input wr_en;//frm unloadFSM (load_en) signal //1cycle dealyed enable signal
reg fifo_rd_start;//rd_en(internal read fsm start) signal is same as loaddone signal frm unloadFSM done signal.


//loadunloadfsm
wire wr_en;//to outFIFO
reg wr_en_regout_temp, wr_en_regout;
wire loader_fsm_start;//start signal of loadunloadfsm
wire rd_start;
wire [(ADDRESSWIDTH)-1:0] UNLOADADDRESS;
//wire[(KB*W)-1:0] WRDIN_kb;//same as WRDIN_VEC

// FF1(unload_en) -> FF2(wr_en) -> FF3(wr_en_regout)
// rd request -> rd happens ->  Write request
// fifo_rd_start is 1 more cycle delayed rd_start, 
// to account 1 cycle delay for last write to happen in FIFO
always@(posedge clk)
begin
  if(!rst)
  begin
    //wr_en_regout_temp<=0;
    //wr_en_regout<=0;
    //WA_regout_temp<=0;
    //WA_regout<=0;
    fifo_rd_start<=0;
  end
  else
  begin
    //wr_en_regout_temp<=wr_en;
   // wr_en_regout<=wr_en;//wr_en_regout_temp;
    //WA_regout_temp<=WA;
   // WA_regout<=WA;//WA_regout_temp;
    fifo_rd_start<=rd_start;
  end
end


////ClkSync smaller T clk to larger T out_clk.
//reg[3:0] rd_start_strobe;
//always@(posedge clk)
//begin
//  rd_start_strobe[3:0]<= rst ? 4'd0 : {rd_start_strobe[2:0],rd_start}; 
//end
//assign fifo_rd_start = |(rd_start_strobe);
//assign fifo_rd_start = rd_start;

//unload_fsm_start_fedback: feedback control signal to loadunloadfsm to fill the fifo with next set of results (unused)
assign loader_fsm_start = unload_fsm_start_fedback & unload_start;//unload_start;//unload_fsm_start_fedback | unload_start;
assign UNLOADADDRESS_VEC = UNLOADADDRESS;

//genvar unloadi;
//generate for(unloadi=0;unloadi<=KB-1;unloadi=unloadi+1) begin: unloadmul_loop
//  assign UNLOADADDRESS_VEC[((unloadi+1)*COLADDR_BITS)-1:(unloadi*COLADDR_BITS)] = {{(COLADDR_BITS-SUB_COLADDR_BITS){1'b0}},UNLOADADDRESS}+(unloadi*COLDEPTH);
//end
//endgenerate

defparam outputfifo.KB=KB, outputfifo.HDDW=HDDW;
defparam outputfifo.ADDRESSWIDTH=ADDRESSWIDTH,outputfifo.FIFODEPTH=FIFODEPTH; 
//outFIFO_ne outputfifo(datavalid,unload_fsm_start_fedback,HD_out,WRDIN_VEC,WA_regout,wr_en_regout,fifo_rd_start,clk,out_clk,rst);
outFIFO_ne outputfifo(datavalid,unload_fsm_start_fedback,HD_out,WRDIN_VEC,WA,wr_en,fifo_rd_start,clk,out_clk,rst);

//clk domain crossing signal: rd_start(output of loadunloadfsm clocked by "clk") --> rd_start(FSM start signal input clocked by "out_clk").
defparam loader.ADDRESSWIDTH=ADDRESSWIDTH, loader.LOADCOUNT=UNLOADCOUNT, loader.CLKSYNC_WAITCYCLES=OUTCLKSYNC_WAITCYCLES;
loadunloadfsm_ne loader(rd_start,wr_en,WA,unload_en, UNLOADADDRESS, loader_fsm_start, clk, rst);
//loadunloadfsm(loaddone,load_en,LOADADDRESS,rd_en, addr_count, start, clk, rst);

endmodule
