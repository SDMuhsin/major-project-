`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2021 13:05:41
// Design Name: 
// Module Name: ne_enc_addrgen
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
// accounting 1 cycle delay of parity shift register update
// we delay the parload en signal and parity shift reg clear signal by 1 cycle.
// rden=1 stays for long time to be captured by slower outclk edge
// parityshiften goes 0 once counting finishes, it is also delayed 1 cycle.
// it stays 0 for longer time so that parity bits stays static 
// for long time to be captured by outclk
//////////////////////////////////////////////////////////////////////////////////


module ne_enc_addrgen(parityregclear, parity_parloaden,parityshiften, rden, msgmem_rdaddress, encstart, clk, rst);
parameter ROMDEPTH= 14;//KB
parameter Z_LM_MSG_DEPTH=32;//(Z+1)/Lm = (511+1)/16) = 32
parameter ROMADDRESSWIDTH = 4; //ceil(log2(KB)) = ceil(log2(14))= 4
parameter Z_LM_MSG_WIDTH = 5;// ceil(log2(Z_LM_MSG_DEPTH)) = ceil(log2(32))=5;
parameter MSGMEM_ADDRESSWIDTH = ROMADDRESSWIDTH + Z_LM_MSG_WIDTH;
parameter CLK_OUTCLK_SYNCCYCLES=10;

output reg parityregclear;
output reg parity_parloaden;
output reg parityshiften;
output reg rden;
output[MSGMEM_ADDRESSWIDTH-1:0] msgmem_rdaddress;
input encstart;//connect wren of load fsm to start
input clk;
input rst;

//Delayed by 1 cycle as parity shifting takes 1 cycle to update
 reg parityregclear_regin;
 reg parity_parloaden_regin;
 reg parityshiften_regin;
always@(posedge clk)
begin
  if(rst)
  begin
    parityregclear<=0;
    parity_parloaden<=0;    
    parityshiften<=0;
  end
  else
  begin
    parityregclear<=parityregclear_regin;
    parity_parloaden<=parity_parloaden_regin;
    parityshiften<=parityshiften_regin;
  end
end

reg[ROMADDRESSWIDTH-1:0] countKB, nextcountKB;
reg[Z_LM_MSG_WIDTH-1:0] count32, nextcount32;

reg[1:0] ps, ns;
parameter INIT=0, COUNTING=1, PARITYLOAD=2;

always@(posedge clk)
begin
  if(rst)
  begin
    ps<=0;
    countKB<=0;
    count32<=0;
  end
  else
  begin
    ps<=ns;
    countKB<=nextcountKB;
    count32<=nextcount32;
  end
end

always@(*)
begin
  case(ps)
    INIT: begin
            ns = encstart ? COUNTING : ps;
            nextcountKB = 0;
            nextcount32= 0;
            rden = 0;
            parity_parloaden_regin = 0;  
            parityregclear_regin=encstart ? 1 : 0;//0;          
            parityshiften_regin=0;
          end
    COUNTING: begin
                ns = (count32==Z_LM_MSG_DEPTH-1) ? ((countKB==ROMDEPTH-1) ? PARITYLOAD : ps) : ps;
                nextcountKB = (count32==Z_LM_MSG_DEPTH-1) ? ((countKB==ROMDEPTH-1) ? 0 : countKB + 1) : countKB;
                nextcount32= (count32==Z_LM_MSG_DEPTH-1) ? 0 : count32 + 1;
                rden = 1;
                parityshiften_regin=1;
                parity_parloaden_regin = (count32==Z_LM_MSG_DEPTH-1) ? ((countKB==ROMDEPTH-1) ? 1 : 0) : 0;
                parityregclear_regin=0;
              end
    PARITYLOAD: begin
                ns = INIT;
                nextcountKB = 0;
                nextcount32= 0;
                rden = 0;
                parityshiften_regin=0;
                parity_parloaden_regin = 0;
                parityregclear_regin=0;//1;
              end              
    default: begin
               ns = 0;
               nextcountKB = 0;
               nextcount32= 0;
               rden = 0;
               parityshiften_regin=0;
               parity_parloaden_regin = 0; 
               parityregclear_regin=0;   
             end
  endcase
end

//output read address:
assign msgmem_rdaddress = {countKB, count32};



endmodule
