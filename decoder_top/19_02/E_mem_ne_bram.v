`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2020 17:43:41
// Design Name: 
// Module Name: E_mem
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
// 32 row parallel processing
// Synchronous read/write RAM
// rst is like enable.
// rst=0 or rd=0 clears dout.
// rst=1 AND wr=1 enables write.
// address is lyr index: 0 to 11
// Change: Adding row counting also. 16 row parallel processing.
// DEPTH = 12*2, ADDRWIDTH = 4+1
//////////////////////////////////////////////////////////////////////////////////


module E_mem_ne_bram(DOUT, DIN, WR_ADDRESS, RD_ADDRESS, wr, rd, clk, rst);

parameter DEPTH = 512; //12;//12*2=24.
parameter ADDRWIDTH = 9; //4;//4+1//LYRWIDTH=4, ROWWIDTH=1.//2**4 = 16 > 12
parameter Wc=32;
parameter Wcbits = 5; //2**5 = 32 > 18
parameter W=6;//8;

parameter Wabs=W-1;
parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;  

output reg[ECOMPSIZE-1:0] DOUT;
input [ECOMPSIZE-1:0] DIN;
input [ADDRWIDTH-1:0] WR_ADDRESS;
input [ADDRWIDTH-1:0] RD_ADDRESS;
input wr, rd, clk, rst;

reg [ECOMPSIZE-1:0] emem[DEPTH-1:0];

integer i;
initial begin
    emem[0] = 47'b0011000110000010010111010010000111110010111101;
 
end

always@(posedge clk)
begin
  if(!rst)
    emem[WR_ADDRESS] <= emem[WR_ADDRESS];
  else
    emem[WR_ADDRESS] <= wr ? DIN : emem[WR_ADDRESS];
//  DOUT <= (rst & rd) ? emem[RD_ADDRESS] : 0;
end

always@(posedge clk)
begin
  if(!rst)
    DOUT<= 0;
  else
    DOUT <= (rd) ? emem[RD_ADDRESS] : 0;
end

endmodule
