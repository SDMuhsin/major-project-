`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 19:28:35
// Design Name: 
// Module Name: acctest_stimulus_ROM
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
// Test stimulus ROM for Accumulator.
//////////////////////////////////////////////////////////////////////////////////


module acctest_stimulus_ROM(dout, rd_address, rd_en);
// Non-configurable
parameter DEPTH=10;
parameter ADDRESSWIDTH=4;
parameter W=8;
parameter Wc=4;
parameter DW=Wc*W;
parameter READDEFAULTCASE=2**ADDRESSWIDTH;//maximum adress value

output reg[DW-1:0] dout;
input [ADDRESSWIDTH-1:0] rd_address;
input rd_en;

wire[ADDRESSWIDTH-1:0] rd_address_case;
assign rd_address_case = rd_en ? rd_address : READDEFAULTCASE;

always@(*)
begin
  case(rd_address_case)
    0,9: begin
         dout={8'd0,8'd1,8'd2,8'd3};
       end
    1,6,7,8: begin
         dout={8'd1,8'd2,8'd3,8'd4};
       end
    2,3,4,5: begin
         dout={8'd6,8'd7,8'd8,8'd9};
       end
    default: begin
               dout={DW{1'b0}};
             end
  endcase
end
endmodule

