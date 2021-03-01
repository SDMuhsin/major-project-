`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 14:25:20
// Design Name: 
// Module Name: inmem
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


module simpledualportRAM(read_dout, write_din, rd_address, wr_address, rd_en, wr_en, clk, rst);
parameter WIDTH=4;
parameter DEPTH=16;
parameter ADDRESSWIDTH = 4;
output reg[WIDTH-1:0] read_dout;
input[ADDRESSWIDTH-1:0] rd_address, wr_address;
input[WIDTH-1:0] write_din;
input rd_en, wr_en;
input clk, rst;

reg [WIDTH-1:0] memreg[DEPTH-1:0];

always@(posedge clk)
begin
  if(wr_en)
  begin
    memreg[wr_address]<=write_din;    
  end
  else
  begin
    memreg[wr_address]<=memreg[wr_address];
  end
end

always@(posedge clk)
begin
  if(!rst)
  begin
    read_dout<=0;
  end
  else  
  begin
    if(rd_en)
      read_dout<=memreg[rd_address];
    else
      read_dout<=0;
  end
end
endmodule
