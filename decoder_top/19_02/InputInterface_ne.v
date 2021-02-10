`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2020 23:49:04
// Design Name: 
// Module Name: InputInterface
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
/// inclk: wrfifofsm uses this clk.
// clk: it is the decoder clk, loadunloadfsm uses this clk.
//since fifo ram is async read, same cycle data can be loaded,
//so loadaddress is same as fifo rd address(addrcount)
//so load_en is same as fifo rd_en
// Change: made inFIFO RAM sync read at decodeclk and sync write at inclk
//////////////////////////////////////////////////////////////////////////////////


module InputInterface_ne(decodestart,load_en_out,LOADADDRESS_VEC,DOUT_LOAD_VEC,Codeword_in,code_valid,in_clk,clk,rst);
//Configurable parameters:
parameter W=12;//10;
parameter ADDRESSWIDTH = 5;//2**5=32>17 loc in one submem. 
parameter FIFODEPTH=32;//17
//Non configurable parameters:
parameter LOADCOUNT=17;//size(rxregtablemod)=[16,17]. LOADCOUNT=columns=17.
parameter DW=32*W;
parameter NB=16;//
output decodestart;
//output load_en_out;// 1 cycle delayed rd_en
//output[(SUB_COLADDR_BITS)-1:0] LOADADDRESS_VEC;//[((NB)*SUB_COLADDR_BITS)-1:0] LOADADDRESS_VEC;// 1 cycle delayed fifo rd address (addr_count)
output reg load_en_out;// 1 cycle delayed rd_en
output reg[(ADDRESSWIDTH)-1:0] LOADADDRESS_VEC;//[((NB)*SUB_COLADDR_BITS)-1:0] LOADADDRESS_VEC;// 1 cycle delayed fifo rd address (addr_count)
output[((NB)*DW)-1:0] DOUT_LOAD_VEC;
input[(DW)-1:0] Codeword_in;
input code_valid;
input in_clk, clk, rst;


//infifo
wire load_fsm_start;
wire[((NB)*DW)-1:0] DOUT_nb_fifo;

//loadunloadfsm
wire rd_en;//to inFIFO
wire[ADDRESSWIDTH-1:0] addr_count;//to ReadAddr inFIFO
wire [(ADDRESSWIDTH)-1:0] addr_count_delayed;
wire rd_en_delayed;


defparam inputfifo.W=W, inputfifo.ADDRESSWIDTH=ADDRESSWIDTH;
defparam inputfifo.FIFODEPTH=FIFODEPTH;
inFIFO_ne_asmmod inputfifo(load_fsm_start,DOUT_nb_fifo,addr_count,rd_en,Codeword_in,code_valid,in_clk,clk,rst);
//inFIFO_dp inputfifo(load_fsm_start,DOUT_nb_fifo,addr_count,rd_en,Codeword_in,code_valid,in_clk,clk,rst);
//inFIFO_dp inputfifo(load_fsm_start,DOUT_nb_fifo,addr_count,rd_en,Codeword_in,code_valid,in_clk,rst);

defparam loader.ADDRESSWIDTH=ADDRESSWIDTH, loader.LOADCOUNT=LOADCOUNT;
loadunloadfsm_ne loader(decodestart,rd_en_delayed,addr_count_delayed,rd_en, addr_count, load_fsm_start, clk, rst);

assign DOUT_LOAD_VEC = DOUT_nb_fifo;//[(NB*DW)-1:0] = DOUT_nb_fifo;


//assign load_en_out = rd_en; //since fifo ram is async read
//assign LOADADDRESS_VEC = addr_count;//since fiforam is async read //LOADADDRESS; 

//Reverted to Sync read RAM
always@(posedge clk)
begin
  if(!rst)
  begin
    load_en_out<=0;
    LOADADDRESS_VEC<=0;
  end
  else
  begin
    load_en_out<=rd_en;
    LOADADDRESS_VEC<=addr_count;
  end
end

endmodule
