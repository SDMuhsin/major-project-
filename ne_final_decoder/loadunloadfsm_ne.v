`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2020 23:18:07
// Design Name: 
// Module Name: loadunloadfsm
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
// Counter that counts 0 to 510
// Bug: For input interface, start is 1 for 1 cycle of inclk larger than clk period.
// Error: if start stays 1, FSM counts again. during Loading, loadunloadfsm triggers decode start multiple times.
// Error: internally when load is enabled after start, all counters and control signal resets to zero.
// Fix1: adding states "DONE_DECODESTART" , "DONE_WAITFORSTARTRESET",
// if start stays 1, go to DONE_DECODESTART to signal decodestart and wait in DONE_WAITFORSTARTRESET.
// This case should not affect output interface: 
// For output interface, start is 1 for 1 cycle of clk same as the clk used for loadunloadfsm.
//////////////////////////////////////////////////////////////////////////////////


module loadunloadfsm_ne(done,load_en,LOADADDRESS,rd_en, addr_count, start, clk, rst);
parameter ADDRESSWIDTH=9;//9 bits to address 512 locations.
//parameter FIFODEPTH = 32;//CODECOUNT is 32//16;//511;
parameter LOADCOUNT=17;//size(rxregtablemod)=[16,17]. LOADCOUNT=columns=17.
output done; //delayed start
output reg load_en;// 1 cycle delayed rd_en
output reg[ADDRESSWIDTH-1:0] LOADADDRESS;// 1 cycle delayed fifo rd address (addr_count)
output reg rd_en;
output reg[ADDRESSWIDTH-1:0] addr_count;
input start;
input clk; //decode clk.
input rst;

parameter INIT=0, COUNTING=1, DONE_DECODESTART=2, DONE_WAITFORSTARTRESET=3;
reg  nextoutfifo_rd_start,outfifo_rd_start;// -----------------------Fix2
//reg loaddone, nextloaddone; ----------------------------(unused) var Fix2
reg[1:0] ps, ns;//reg ps, ns; //Bug: if start stays 1, FSM counts again. Which is causing error during Loading. -----Fix1
reg[ADDRESSWIDTH-1:0] nextcount;
reg nextrd;
always@(posedge clk)
begin
  if(!rst)
  begin
    ps<=0;
    addr_count<=0;
    LOADADDRESS<=0;
    rd_en<=0;
    load_en<=0;
    outfifo_rd_start<=0; //------------------------Fix2
  end
  else
  begin
    ps<=ns;
    addr_count<=nextcount;
    LOADADDRESS<=addr_count;//1cycle delay=1cycle for fetching data frm fifo.
    rd_en<=nextrd;
    load_en<=rd_en; //1 cycle delayed rd signal = 510 should also have load_en=1..
    outfifo_rd_start<=nextoutfifo_rd_start;//----------------------Fix2
  end
end

always@(ps,addr_count,start,outfifo_rd_start)
begin
  case(ps)
    INIT: begin
            ns = start ? COUNTING : INIT;
            nextcount = 0;
            nextrd = start;
            //nextloaddone=0;//loaddone=0;
            nextoutfifo_rd_start=0;// ------------------------------Fix2            
          end
    COUNTING: begin
                ns=(addr_count<LOADCOUNT-1) ? COUNTING : (start ? DONE_DECODESTART: INIT);//(addr_count<COLDEPTH-1) ? COUNTING : INIT;
                nextcount=(addr_count<LOADCOUNT-1) ? addr_count+1 : 0;
                nextrd=(addr_count<LOADCOUNT-1) ? 1 : 0;
                //nextloaddone=(addr_count<COLDEPTH-1) ? 0 : 1;//loaddone=(addr_count<COLDEPTH-1) ? 0 : 1;
                nextoutfifo_rd_start=(addr_count<LOADCOUNT-1) ? 0 : 1;//outfifo_rd_start=(addr_count<COLDEPTH-2) ? 0 : 1;//signal early ------Fix2
              end
    DONE_DECODESTART: begin  //Bug: if start stays 1, FSM counts again. Which is causing error during Loading. -----Fix1
                        ns=DONE_WAITFORSTARTRESET;
                        nextcount=0;
                        nextrd=0;
                        //nextloaddone= 1;
                        nextoutfifo_rd_start=1;//---------Fix2
                      end 
    DONE_WAITFORSTARTRESET: begin  //Bug: if start stays 1, FSM counts again. Which is causing error during Loading. -----Fix1
                              ns=start ? ps : INIT;
                              nextcount=0;
                              nextrd=0;
                              //nextloaddone=start ? 1 : 0;
                              //nextoutfifo_rd_start=0;//----------------Fix2
                              nextoutfifo_rd_start=outfifo_rd_start;// ------------------------------Fix3 for clk sync
                            end                                    
    default: begin
               ns=0;
               nextcount=0;
               nextrd=0;
               //nextloaddone=0;//loaddone=0;
               nextoutfifo_rd_start=0;//----------------------Fix2
             end
  endcase
end

//clk domain sync when using for unload circuit.
parameter CLKSYNC_WAITCYCLES=10;//4;//4;
reg[CLKSYNC_WAITCYCLES-1:0] outfifo_rd_start_clksync;//arbitrary 4 bit
always@(posedge clk)
begin
  if(!rst)
  begin
    outfifo_rd_start_clksync<={CLKSYNC_WAITCYCLES{1'b0}};//4'd0;
  end
  else
  begin
    outfifo_rd_start_clksync<={outfifo_rd_start_clksync[CLKSYNC_WAITCYCLES-2:0],outfifo_rd_start};
  end
end
assign done = |(outfifo_rd_start_clksync);

endmodule
