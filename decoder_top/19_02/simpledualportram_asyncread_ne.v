`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2020 19:38:09
// Design Name: 
// Module Name: simpledualportram_asyncread
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


module simpledualportram_asyncread_ne(DOUT, RA, rd_in, DIN, WA, wr_in,memclk, rst);
parameter W=6;
parameter ADDRESSWIDTH=9;//9bits to address Z=511 locations
parameter MEMDEPTH = 16;//511;
output[(W)-1:0] DOUT;
input[(ADDRESSWIDTH)-1:0] RA;
input rd_in;
input[(W)-1:0] DIN;
input[(ADDRESSWIDTH)-1:0] WA;
input wr_in;

//input[(COLADDR_BITS)-1:0] RA_regd;
//input rd_in_regd;
//input[(W)-1:0] DIN_regd;
//input[(COLADDR_BITS)-1:0] WA_regd;
//input wr_in_regd;
//input rdclk, memclk, rst;
input memclk, rst;
//regd inputs
//reg rd_in, wr_in;
//reg[W-1:0] DIN;
//reg[(COLADDR_BITS)-1:0] WA;
//reg[(COLADDR_BITS)-1:0] RA;
//always@(posedge rdclk)
//begin
//  rd_in<= rst ? rd_in_regd : 0;
//  wr_in<= rst ? wr_in_regd : 0;
//  DIN<= rst ? DIN_regd : 0;
//  WA<= rst ? WA_regd : 0;
//  RA<= rst ? RA_regd : 0;
//end
//
reg[W-1:0] Lmemreg[MEMDEPTH-1:0];
//wire[W-1:0] DOUT_temp;
//    always@(RA)
//    begin
//      DOUT= Lmemreg[RA];         
//    end
//Reading at rdclk posedge
//    always@(posedge rdclk)
//    begin
//        if(!rst)
//        begin
//          DOUT<=0;
//        end
//        else
//        begin
//          DOUT<= rd_in ? Lmemreg[RA] : DOUT;         
//        end
//    end 
//Reading Asynchronous: rst or rd clears DOUT iff zero. 
   assign DOUT= rst ? (rd_in ? Lmemreg[RA] : 0 ): 0;
    //Writing at posedge
    always@(posedge memclk)
    begin
      if(!rst)
      begin
        Lmemreg[WA]<=Lmemreg[WA];
      end
      else
      begin
        Lmemreg[WA]<=(wr_in ? (DIN) : Lmemreg[WA] );
      end
    end  

endmodule