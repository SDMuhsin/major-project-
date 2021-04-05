`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2020 12:18:44
// Design Name: 
// Module Name: simpledualportram_wrclk_rdclk_dp
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


module simpledualportram_wrclk_rdclk_ne(DOUT, RA, rd_in, DIN, WA, wr_in, wrclk, rdclk, rst);
parameter WIDTH=6;
parameter ADDRESSWIDTH=9;
parameter MEMDEPTH = 512;
output reg[(WIDTH)-1:0] DOUT;
input[(ADDRESSWIDTH)-1:0] RA;
input rd_in;
input[(WIDTH)-1:0] DIN;
input[(ADDRESSWIDTH)-1:0] WA;
input wr_in;
input wrclk, rdclk, rst;

reg[WIDTH-1:0] Lmemreg[MEMDEPTH-1:0];

//reading at posedge of READ clock
    always@(posedge rdclk)
    begin
        if(!rst)
        begin
          DOUT<=0;
        end
        else
        begin
          DOUT<= rd_in ? Lmemreg[RA] : 0;         
        end
    end 
    
//Writing at posedge of WRITE clock
    always@(posedge wrclk)
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